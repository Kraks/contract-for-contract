import assert from 'assert';
import type { Opaque } from 'type-fest';
import { TerminalNode } from 'antlr4';
import { CharStream, CommonTokenStream } from 'antlr4';

import SpecVisitor from './spec-parser/SpecVisitor.js';
import SpecLexer from './spec-parser/SpecLexer.js';
import SpecParser from './spec-parser/SpecParser.js';
import {
  SpecContext,
  TupleContext,
  DictContext,
  VspecContext,
  TspecContext,
  CallContext,
  SexprContext,
  IdentsContext,
} from './spec-parser/SpecParser.js';

export interface FlatSpec<T> {
  vars: Array<string>;
  cond: T;
}

export interface FunSpec<T> {
  dom: ValSpec<T>;
  codom: ValSpec<T>;
}

export type ValSpec<T> =
  | Opaque<FlatSpec<T>, 'FlatSpec'>
  | Opaque<FunSpec<T>, 'FunSpec'>;

export enum TempConn {
  After,
  NotAfter,
  UnderCtx,
  NotUnderCtx,
}

export interface Call {
  funName: string;
  args: Array<string>;
  kwargs: Array<string>;
  rets: Array<string>;
}

export interface TempSpec<T> {
  conn: TempConn;
  call1: Call;
  call2: Call;
  cond?: T;
}

export type CSSpec<T> = ValSpec<T> | Opaque<TempSpec<T>, 'TempSpec'>;

export type SpecParseResult<T> =
  | T
  | CSSpec<T>
  | Call
  | TempConn
  | Array<string>;

/*
 * XXX: [discussion]
 *  Should we use assertions or error handling for invalid parsed tree?
 */
export abstract class CSSpecVisitor<T> extends SpecVisitor<SpecParseResult<T>> {
  abstract parseSexpr(text: string): T;

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

  // tspec :   call TCONN call ( '/\\' sexpr )? ;
  visitTspec: (ctx: TspecContext) => Opaque<TempSpec<T>, 'TempSpec'> = (
    ctx,
  ) => {
    assert(ctx.children != null);
    assert(ctx.children.length == 3 || ctx.children.length == 5);

    // XXX: shall we use assertion or `as` here?
    const _call1 = this.visitCall(ctx.children[0] as CallContext);
    const _call2 = this.visitCall(ctx.children[2] as CallContext);

    // XXX: same question here: is the `as` a safe casting with runtime type check?
    let _conn: TempConn;
    switch ((ctx.children[1] as TerminalNode).symbol.text) {
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
    if (ctx.children.length == 5) {
      assert((ctx.children[3] as TerminalNode).symbol.text == '/\\');
      assert(ctx.children[4] instanceof SexprContext);
      tspec.cond = this.parseSexpr(ctx.children[4].getText());
    }

    return tspec as Opaque<TempSpec<T>, 'TempSpec'>;
  };

  // call  :   IDENT ( dict )? '(' idents ')' ('returns' tuple)? ;
  visitCall: (ctx: CallContext) => Call = (ctx) => {
    assert(ctx.children != null);
    assert(ctx.children.length >= 4 && ctx.children.length <= 7);

    const _funName = (ctx.children[0] as TerminalNode).symbol.text;

    // kwargs
    let identsIdx: number, _kwargs: Array<string>;
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

  // dict  :   '{' idents '}' ;
  visitDict: (ctx: DictContext) => Array<string> = (ctx) => {
    assert(ctx.children != null);
    assert(ctx.children.length == 3);

    assert((ctx.children[0] as TerminalNode).symbol.text == '{');
    assert((ctx.children[2] as TerminalNode).symbol.text == '}');

    return this.visitIdents(ctx.children[1] as IdentsContext);
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

// XXX: only for testing (a predefined visitor)
// we can direct make a CSSpecVisitor<Solidity> without abstract method later
export class CSSpecVisitorString extends CSSpecVisitor<string> {
  parseSexpr(text: string): string {
    return text;
  }
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
