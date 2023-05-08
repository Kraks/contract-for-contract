import assert from 'assert';
import type { Opaque } from 'type-fest';
import { TerminalNode } from 'antlr4';

import SpecVisitor from './spec-parser/SpecVisitor.js'
import { 
    SpecContext, VspecContext, TspecContext, CallContext, SexprContext, IdentsContext
} from "./spec-parser/SpecParser.js";

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

export type SpecParseResult<T> = T 
  | CSSpec<T>
  | Call
  | TempConn
  | Array<string>
  ;

/*
 * XXX: [discussion]
 *  Should we use assertions or error handling for invalid parsed tree?
 */
export abstract class CSSpecVisitor<T> extends SpecVisitor<SpecParseResult<T>> {
  abstract parseSexpr(text: string): T;

  visitSpec: (ctx: SpecContext) => CSSpec<T> = ((ctx) => {
    assert(ctx.children != null);
    assert(ctx.children.length == 2);

    if (ctx.children[0] instanceof VspecContext) {
      assert(false);
    } else {
      assert(ctx.children[0] instanceof TspecContext);
      return this.visitTspec(ctx.children[0]);
    }
  })

  visitTspec: (ctx: TspecContext) => Opaque<TempSpec<T>, 'TempSpec'>  = ((ctx) => {
    assert(ctx.children != null);
    assert(ctx.children.length == 3 || ctx.children.length == 5);
    
    // XXX: to bypass type checking: is there a better way to do so???
    assert(ctx.children[0] instanceof CallContext);
    assert(ctx.children[2] instanceof CallContext);
    const _call1 = this.visitCall(ctx.children[0]);
    const _call2 = this.visitCall(ctx.children[2]);

    // XXX: type checking again
    assert(ctx.children[1] instanceof TerminalNode);
    let _conn;
    if (ctx.children[1].symbol.text == '=>') {
      _conn = TempConn.After;
    } else if (ctx.children[1].symbol.text == '=/>') {
      _conn = TempConn.NotAfter;
    } else if (ctx.children[1].symbol.text == '~>') {
      _conn = TempConn.UnderCtx;
    } else {
      assert(ctx.children[1].symbol.text == '~/>');
      _conn = TempConn.NotUnderCtx;
    }

    const tspec: TempSpec<T> = {call1: _call1, call2: _call2, conn: _conn};
    if (ctx.children.length == 5) {
      assert(ctx.children[3] instanceof TerminalNode);
      assert(ctx.children[3].symbol.text == '/\\');

      assert(ctx.children[4] instanceof SexprContext);
      tspec.cond = this.parseSexpr(ctx.children[4].getText());
    }

    return tspec as Opaque<TempSpec<T>, 'TempSpec'>;  
  })

  visitCall: (ctx: CallContext) => Call = ((ctx) => {
    assert(ctx.children != null);
    assert(ctx.children.length == 4 || ctx.children.length == 6);

    assert(ctx.children[0] instanceof TerminalNode);
    const _funName = ctx.children[0].symbol.text;

    assert(ctx.children[1] instanceof TerminalNode);
    assert(ctx.children[1].symbol.text == '(');

    assert(ctx.children[2] instanceof IdentsContext);
    const _args = this.visitIdents(ctx.children[2]);

    assert(ctx.children[3] instanceof TerminalNode);
    assert(ctx.children[3].symbol.text == ')');

    return {
      funName: _funName,
      args: _args,
      kwargs: [],
      rets: [],
    }
  })

  visitIdents: (ctx: IdentsContext) => Array<string> = ((ctx) => {
    return [];
  })
}

// XXX: only for testing
// we can direct make a CSSpecVisitor<Solidity> without abstract method later
export class CSSpecVisitorString extends CSSpecVisitor<string> {
  parseSexpr(text: string): string {
    return text; 
  }
}
