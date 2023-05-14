import assert from 'assert';
import type { Opaque } from 'type-fest';
import { TerminalNode } from 'antlr4';
import { CharStream, CommonTokenStream } from 'antlr4';

import SpecVisitor from './parser/SpecVisitor.js';
import SpecLexer from './parser/SpecLexer.js';
import SpecParser from './parser/SpecParser.js';
import {
  SpecContext,
  TupleContext,
  DictContext,
  VspecContext,
  TspecContext,
  CallContext,
  SexprContext,
  PairContext,
  IdentsContext,
} from './parser/SpecParser.js';

export interface ValSpec<T> {
  call: Call,
  preCond: T,
  preFunSpec: Array<ValSpec<T>>,
  postCond: T
  postFunSpec: Array<ValSpec<T>>,
}

export enum TempConn {
  After,
  NotAfter,
  UnderCtx,
  NotUnderCtx,
}

export interface Pair<T1, T2> {
  fst: T1,
  snd: T2
}

export interface Call {
  funName: string;
  args: Array<string>;
  kwargs: Array<Pair<string, string>>;
  rets: Array<string>;
}

export interface TempSpec<T> {
  conn: TempConn;
  call1: Call;
  call2: Call;
  preCond?: T;
  postCond?: T;
}

export type CSSpec<T> = ValSpec<T> | Opaque<TempSpec<T>, 'TempSpec'>;

export type SpecParseResult<T> =
  | T
  | CSSpec<T>
  | Call
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

  extractTermText(n: any): string {
    return (n as TerminalNode).symbol.text;
  }

  // spec  :   vspec EOF | tspec EOF;
  visitSpec: (ctx: SpecContext) => CSSpec<T> = (ctx) => {
    assert(ctx.children != null);
    assert(ctx.children.length == 2);

    if (ctx.children[0] instanceof VspecContext) {
      assert(false); // TODO
    } else {
      return this.visitTspec(ctx.children[0] as TspecContext);
    }
  };

  /*
    tspec : '{' call TCONN call
            ('when' '{' sexpr '}')?
            ('ensures' '{' sexpr '}')?
            '}';
  */
  visitTspec: (ctx: TspecContext) => Opaque<TempSpec<T>, 'TempSpec'> = (
    ctx,
  ) => {
    assert(ctx.children != null);
    assert(ctx.children.length == 5 || ctx.children.length == 9 || ctx.children.length == 13);

    // XXX: shall we use assertion or `as` here?
    const _call1 = this.visitCall(ctx.children[1] as CallContext);
    const _call2 = this.visitCall(ctx.children[3] as CallContext);

    // XXX: same question here: is the `as` a safe casting with runtime type check?
    let _conn: TempConn;
    switch ((ctx.children[2] as TerminalNode).symbol.text) {
      case '=>':
        _conn = TempConn.After;
        break;
      case '=/>':
        _conn = TempConn.NotAfter;
        break;
      case '~>':
        _conn = TempConn.UnderCtx;
        break;
      case '~/>':
        _conn = TempConn.NotUnderCtx;
        break;
      default:
        assert(false, 'invald TempConn');
    }

    const tspec: TempSpec<T> = { call1: _call1, call2: _call2, conn: _conn };
    if (ctx.children.length == 9) {
      // Only "when" or "ensures" is provided
      let prompt = this.extractTermText(ctx.children[4]) 
      if (prompt == "when") {
	assert(ctx.children[6] instanceof SexprContext);
	tspec.preCond = this.parseSexpr(ctx.children[6].getText());
      } else if (prompt == "ensures") {
	assert(ctx.children[6] instanceof SexprContext);
	tspec.postCond = this.parseSexpr(ctx.children[6].getText());
      } else {
	assert(false, "invalid keyword (which shouldn't happen at all)");
      }
    }
    if (ctx.children.length == 13) {
      // both "when" or "ensures" is provided
      // TODO
    }

    return tspec as Opaque<TempSpec<T>, 'TempSpec'>;
  };

  // call  :   IDENT ( dict )? '(' idents ')' ('returns' tuple)? ;
  visitCall: (ctx: CallContext) => Call = (ctx) => {
    assert(ctx.children != null);
    assert(ctx.children.length >= 4 && ctx.children.length <= 7);

    const _funName = (ctx.children[0] as TerminalNode).symbol.text;

    // kwargs
    let identsIdx: number, _kwargs: Array<Pair<string, string>>;
    if (ctx.children[1] instanceof DictContext) {
      identsIdx = 3;
      _kwargs = this.visitDict(ctx.children[1]);
    } else {
      identsIdx = 2;
      _kwargs = [];
    }

    // args
    assert((ctx.children[identsIdx - 1] as TerminalNode).symbol.text == '(');
    assert((ctx.children[identsIdx + 1] as TerminalNode).symbol.text == ')');
    const _args = this.visitIdents(ctx.children[identsIdx] as IdentsContext);

    // returns
    let _rets: Array<string>;
    if (ctx.children[ctx.children.length - 1] instanceof TupleContext) {
      assert(
        (ctx.children[ctx.children.length - 2] as TerminalNode).symbol.text ==
          'returns',
      );
      _rets = this.visitTuple(
        ctx.children[ctx.children.length - 1] as TupleContext,
      );
    } else {
      _rets = [];
    }

    return {
      funName: _funName,
      kwargs: _kwargs,
      args: _args,
      rets: _rets,
    };
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
      assert((ctx.children[0] as TerminalNode).symbol.text == '(');
      assert((ctx.children[2] as TerminalNode).symbol.text == ')');
      return this.visitIdents(ctx.children[1] as IdentsContext);
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

    assert((ctx.children[0] as TerminalNode).symbol.text == '{');
    assert((ctx.children[ctx.children.length-1] as TerminalNode).symbol.text == '}');

    let kvs = ctx.children.filter((child) => (child instanceof PairContext)).map((child) => this.visitPair(child as PairContext));

    return kvs;
  };

  // idents:    (IDENT (',' IDENT)*)? ;
  visitIdents: (ctx: IdentsContext) => Array<string> = (ctx) => {
    if (ctx.children == null) {
      return [];
    } else {
      return ctx.children
        .filter(
          (child) => (child as TerminalNode).symbol.type == SpecLexer.IDENT,
        )
        .map((child) => child.getText());
    }
  };
}

// TODO: add error handling
// XXX: for now, just for testing
export function CSSpecParse<T>(
  s: string,
  visitor: CSSpecVisitor<T>,
): CSSpec<T> {
  const chars = new CharStream(s); // replace this with a FileStream as required
  const lexer = new SpecLexer(chars);
  const tokens = new CommonTokenStream(lexer);
  const parser = new SpecParser(tokens);
  const tree = parser.spec();

  return tree.accept(visitor) as CSSpec<T>;
}
