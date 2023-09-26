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
    assert(ctx.children.length == 2);

    return this.visit(ctx.children[0]) as CSSpec<T>;
  };

  /*
    vspec : '{' call
            ('requires' '{' sexpr '}')?
            ('ensures' '{' sexpr '}')?
            ('where' vspec*)?
            '}';
  */
  visitVspec: (ctx: VspecContext) => ValSpec<T> = (ctx) => {
    assert(ctx.children != null);

    const call = this.visit(ctx.children[1]) as Call;
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
        i = i + 1;
        while (i < ctx.children.length - 1) {
          const funspec = this.visit(ctx.children[i]) as ValSpec<T>;
          if (!funspec || !funspec.call) {
            assert(false, 'Undefined fs or fs.call:' + funspec);
            // continue;
          }
          const rawAddr = funspec.call.tgt.addr;
          const tgt = rawAddr === undefined ? funspec.call.tgt.func : rawAddr;
          if (call.args.includes(tgt)) {
            vspec.preFunSpec.push(funspec);
          } else if (call.rets.includes(tgt)) {
            vspec.postFunSpec.push(funspec);
          } else {
            assert(false, 'Unknown address ' + tgt);
          }
          i = i + 1;
        }
      } else {
        assert(false, 'invalid keyword ' + prompt);
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

  // call  :   fname ( dict )? '(' idents ')' ('returns' tuple)? ;
  visitCall: (ctx: CallContext) => Call = (ctx) => {
    assert(ctx.children != null);
    assert(ctx.children.length >= 4 && ctx.children.length <= 7);

    const target = this.visit(ctx.children[0]) as Target;

    // kwargs
    let identsIdx: number, kwargs: Array<Pair<string, string>>;
    if (ctx.children[1] instanceof DictContext) {
      identsIdx = 3;
      kwargs = this.visit(ctx.children[1]) as Array<Pair<string, string>>;
    } else {
      identsIdx = 2;
      kwargs = [];
    }

    // args
    assert(this.extractTermText(ctx.children[identsIdx - 1]) == '(');
    assert(this.extractTermText(ctx.children[identsIdx + 1]) == ')');
    const args = this.visit(ctx.children[identsIdx]) as Array<string>;

    // returns
    let rets: Array<string>;
    if (ctx.children[ctx.children.length - 1] instanceof TupleContext) {
      assert(this.extractTermText(ctx.children[ctx.children.length - 2]) == 'returns');
      rets = this.visit(ctx.children[ctx.children.length - 1]) as Array<string>;
    } else {
      rets = [];
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
      return { func: this.extractTermText(idents[0]) };
    } else if (idents.length == 2) {
      return {
        func: this.extractTermText(idents[1]),
        addr: this.extractTermText(idents[0]),
      };
    } else {
      return {
        func: this.extractTermText(idents[2]),
        addr: this.extractTermText(idents[1]),
        interface: this.extractTermText(idents[0]),
      };
    }
  };

  // tuple :   IDENT | '(' idents ')' ;
  visitTuple: (ctx: TupleContext) => Array<string> = (ctx) => {
    assert(ctx.children != null);
    assert(ctx.children.length == 1 || ctx.children.length == 3);

    if (ctx.children.length == 1) {
      const child = ctx.children[0] as TerminalNode;
      assert(child.symbol.type == SpecLexer.IDENT);
      return [child.symbol.text];
    } else {
      assert(this.extractTermText(ctx.children[0]) == '(');
      assert(this.extractTermText(ctx.children[2]) == ')');
      return this.visit(ctx.children[1]) as Array<string>;
    }
  };

  // pair : IDENT ':' IDENT ;
  visitPair: (ctx: PairContext) => Pair<string, string> = (ctx) => {
    assert(ctx.children != null);
    return { fst: ctx.children[0].getText(), snd: ctx.children[2].getText() };
  };

  // dict  : '{' pair (',' pair)* '}' ;
  visitDict: (ctx: DictContext) => Array<Pair<string, string>> = (ctx) => {
    assert(ctx.children != null);
    assert(ctx.children.length >= 3);

    assert(this.extractTermText(ctx.children[0]) == '{');
    assert(this.extractTermText(ctx.children[ctx.children.length - 1]) == '}');

    const kvs = ctx.children
      .filter((child) => child instanceof PairContext)
      .map((child) => this.visit(child as PairContext) as Pair<string, string>);

    return kvs;
  };

  // idents:    (IDENT (',' IDENT)*)? ;
  visitIdents: (ctx: IdentsContext) => Array<string> = (ctx) => {
    if (ctx.children == null) {
      return [];
    } else {
      return ctx.children
        .filter((child) => (child as TerminalNode).symbol.type == SpecLexer.IDENT)
        .map((child) => child.getText());
    }
  };
}

// TODO: add error handling
// XXX: for now, just for testing
export function CSSpecParse<T>(s: string, visitor: CSSpecVisitor<T>): CSSpec<T> {
  const chars = new CharStream(s); // replace this with a FileStream as required
  const lexer = new SpecLexer(chars);
  const tokens = new CommonTokenStream(lexer);
  const parser = new SpecParser(tokens);
  const tree = parser.spec();

  return tree.accept(visitor) as CSSpec<T>;
}
