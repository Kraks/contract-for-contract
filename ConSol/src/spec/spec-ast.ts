import assert from 'assert';
import { ParseTree, TerminalNode } from 'antlr4';
import { CharStream, CommonTokenStream } from 'antlr4';

import SpecVisitor from '../parser/SpecVisitor.js';
import SpecLexer from '../parser/SpecLexer.js';
import SpecParser from '../parser/SpecParser.js';
import {
  SpecContext,
  TargetContext,
  TupleContext,
  DictContext,
  VspecContext,
  TspecContext,
  CallContext,
  SexprContext,
  PairContext,
  IdentsContext,
} from '../parser/SpecParser.js';
import { nextAddrSpecId, resetAddrSpecId } from '../Global.js';

type Tagged<Tag> = {
  readonly tag: Tag;
};

export type Opaque<T, Tag> = T & Tagged<Tag>;

export interface $ValSpec<T> {
  call: Call;
  preCond?: T;
  preFunSpec: Array<Opaque<$ValSpec<T>, 'ValSpec'>>;
  postCond?: T;
  postFunSpec: Array<Opaque<$ValSpec<T>, 'ValSpec'>>;
  id?: number;
}

export enum TempConn {
  After,
  NotAfter,
  UnderCtx,
  NotUnderCtx,
}

export interface Pair<T1, T2> {
  fst: T1;
  snd: T2;
}

export interface Call {
  tgt: Target;
  args: Array<string>;
  kwargs: Array<Pair<string, string>>;
  rets: Array<string>;
}

export interface Target {
  func: string;
  addr?: string;
  interface?: string;
}

export interface $TempSpec<T> {
  conn: TempConn;
  call1: Call;
  call2: Call;
  preCond?: T;
  postCond?: T;
}

export type ValSpec<T> = Opaque<$ValSpec<T>, 'ValSpec'>;

export type TempSpec<T> = Opaque<$TempSpec<T>, 'TempSpec'>;

export type CSSpec<T> = ValSpec<T> | TempSpec<T>;

// only field `call` is required to make ValSpec
export function makeValSpec<T>(obj: Partial<ValSpec<T>> & Pick<$ValSpec<T>, 'call'>): ValSpec<T> {
  const ret = {
    preFunSpec: [],
    postFunSpec: [],
    ...obj,
    tag: 'ValSpec',
  };
  if (ret.preFunSpec === undefined) ret.preFunSpec = [];
  if (ret.postFunSpec === undefined) ret.postFunSpec = [];
  return ret as ValSpec<T>;
}

export function makeTempSpec<T>(obj: $TempSpec<T>): TempSpec<T> {
  return {
    ...obj,
    tag: 'TempSpec',
  } as TempSpec<T>;
}

export function isValSpec<T>(v: CSSpec<T>): v is ValSpec<T> {
  return v.tag === 'ValSpec';
}

export function isTempSpec<T>(v: CSSpec<T>): v is TempSpec<T> {
  return v.tag === 'TempSpec';
}

export type SpecParseResult<T> =
  | T
  | CSSpec<T>
  | Call
  | Target
  | TempConn
  | string
  | Array<Pair<string, string>>
  | Array<string>
  | Pair<string, string>;

/*
 * XXX: [discussion]
 *  Should we use assertions or error handling for invalid parsed tree?
 */
export class CSSpecVisitor<T> extends SpecVisitor<SpecParseResult<T>> {
  parseSexpr: (_: string) => T;

  constructor(parseSexpr: (_: string) => T) {
    super();
    this.parseSexpr = parseSexpr;
  }

  extractTermText(n: ParseTree): string {
    assert(n instanceof TerminalNode);
    return (n as TerminalNode).symbol.text;
  }

  // spec  :   vspec EOF | tspec EOF;
  visitSpec: (ctx: SpecContext) => CSSpec<T> = (ctx) => {
    assert(ctx.children != null);
    return this.visit(ctx.children[0]) as CSSpec<T>;
  };

  /*
    vspec : '{' call
            ('requires' '{' sexpr '}')?
            ('ensures' '{' sexpr '}')?
            ('where' vspec*)?
            '}';
  */
  // TODO: also attach spec id to storage addr. fix.
  visitVspec: (ctx: VspecContext) => ValSpec<T> = (ctx) => {
    assert(ctx.children != null);
    const call = this.visitCall(ctx.call());
    const vspec: ValSpec<T> = makeValSpec({ call: call });

    for (let i = 2; i < ctx.children.length - 1; i += 4) {
      const prompt = this.extractTermText(ctx.children[i]);
      if (prompt == 'requires') {
        assert(ctx.children[i + 2] instanceof SexprContext);
        vspec.preCond = this.parseSexpr(ctx.children[i + 2].getText());
      } else if (prompt == 'ensures') {
        assert(ctx.children[i + 2] instanceof SexprContext);
        vspec.postCond = this.parseSexpr(ctx.children[i + 2].getText());
      } else if (prompt == 'where') {
        ctx
          .vspec_list()
          .map((vspec) => this.visitVspec(vspec))
          .forEach((addrSpec) => {
            addrSpec.id = nextAddrSpecId();
            const rawAddr = addrSpec.call.tgt.addr;
            const tgt = rawAddr === undefined ? addrSpec.call.tgt.func : rawAddr;
            if (call.args.includes(tgt)) {
              vspec.preFunSpec.push(addrSpec);
            } else if (call.rets.includes(tgt)) {
              vspec.postFunSpec.push(addrSpec);
            } else assert(false, 'Unknown address: ' + tgt);
          });
      } else {
        assert(false, 'invalid keyword: ' + prompt);
      }
    }
    return vspec;
  };

  /*
    tspec : '{' call TCONN call
            ('when' '{' sexpr '}')?
            ('ensures' '{' sexpr '}')?
            '}';
  */
  visitTspec: (ctx: TspecContext) => TempSpec<T> = (ctx) => {
    assert(ctx.children != null);
    assert(ctx.children.length == 5 || ctx.children.length == 9 || ctx.children.length == 13);

    // XXX: shall we use assertion or `as` here?
    const call1 = this.visit(ctx.children[1]) as Call;
    const call2 = this.visit(ctx.children[3]) as Call;

    // XXX: same question here: is the `as` a safe casting with runtime type check?
    let conn: TempConn;
    switch (this.extractTermText(ctx.children[2])) {
      case '=>':
        conn = TempConn.After;
        break;
      case '=/>':
        conn = TempConn.NotAfter;
        break;
      case '~>':
        conn = TempConn.UnderCtx;
        break;
      case '~/>':
        conn = TempConn.NotUnderCtx;
        break;
      default:
        assert(false, 'invald TempConn');
    }

    const tspec: TempSpec<T> = makeTempSpec({
      call1: call1,
      call2: call2,
      conn: conn,
    });
    for (let i = 4; i < ctx.children.length - 1; i += 4) {
      const prompt = this.extractTermText(ctx.children[i]);
      if (prompt == 'when') {
        assert(ctx.children[i + 2] instanceof SexprContext);
        tspec.preCond = this.parseSexpr(ctx.children[i + 2].getText());
      } else if (prompt == 'ensures') {
        assert(ctx.children[i + 2] instanceof SexprContext);
        tspec.postCond = this.parseSexpr(ctx.children[i + 2].getText());
      } else {
        assert(false, "invalid keyword (which shouldn't happen at all)");
      }

      assert(this.extractTermText(ctx.children[i + 1]) == '{');
      assert(this.extractTermText(ctx.children[i + 3]) == '}');
    }

    return tspec;
  };

  // call  :   target ( dict )? '(' idents ')' ('returns' tuple)? ;
  visitCall: (ctx: CallContext) => Call = (ctx) => {
    const target = this.visitTarget(ctx.target());
    // kwargs
    let kwargs: Array<Pair<string, string>> = [];
    if (ctx.dict() != undefined) {
      kwargs = this.visitDict(ctx.dict());
    }
    // args
    const args = this.visitIdents(ctx.idents());
    // returns
    let rets: Array<string> = [];
    if (ctx.RETURNS() != undefined) {
      rets = this.visitTuple(ctx.tuple());
    }
    const call: Call = {
      tgt: target,
      kwargs: kwargs,
      args: args,
      rets: rets,
    };

    return call;
  };

  // fname :   IDENT
  //       |   IDENT '.' IDENT
  //       |   IDENT '(' IDENT ')' '.' IDENT
  visitTarget: (ctx: TargetContext) => Target = (ctx) => {
    assert(ctx.children != null);
    const idents = ctx.IDENT_list();
    if (idents.length == 1) {
      return { func: idents[0].getText() };
    } else if (idents.length == 2) {
      return {
        func: idents[1].getText(),
        addr: idents[0].getText(),
      };
    } else {
      return {
        func: idents[2].getText(),
        addr: idents[1].getText(),
        interface: idents[0].getText(),
      };
    }
  };

  // tuple :   IDENT | '(' idents ')' ;
  visitTuple: (ctx: TupleContext) => Array<string> = (ctx) => {
    if (ctx.IDENT() != undefined) {
      return [ctx.IDENT().getText()];
    } else {
      return this.visitIdents(ctx.idents());
    }
  };

  // pair : IDENT ':' IDENT ;
  visitPair: (ctx: PairContext) => Pair<string, string> = (ctx) => {
    return { fst: ctx.IDENT(0).getText(), snd: ctx.IDENT(1).getText() };
  };

  // dict  : '{' pair (',' pair)* '}' ;
  visitDict: (ctx: DictContext) => Array<Pair<string, string>> = (ctx) => {
    return ctx.pair_list().map((child) => this.visitPair(child));
  };

  // idents:    (IDENT (',' IDENT)*)? ;
  visitIdents: (ctx: IdentsContext) => Array<string> = (ctx) => {
    return ctx.IDENT_list().map((child) => child.getText());
  };
}

// TODO: add error handling
// XXX: for now, just for testing
export function CSSpecParse<T>(s: string, visitor: CSSpecVisitor<T>): CSSpec<T> {
  resetAddrSpecId();
  const chars = new CharStream(s); // replace this with a FileStream as required
  const lexer = new SpecLexer(chars);
  const tokens = new CommonTokenStream(lexer);
  const parser = new SpecParser(tokens);
  const tree = parser.spec();

  return tree.accept(visitor) as CSSpec<T>;
}
