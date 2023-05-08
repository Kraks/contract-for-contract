// @ts-nocheck
// Generated from Spec.g4 by ANTLR 4.12.0

import { ParseTreeVisitor } from 'antlr4';

import { SpecContext } from './SpecParser';
import { VspecContext } from './SpecParser';
import { TspecContext } from './SpecParser';
import { TupleContext } from './SpecParser';
import { IdentsContext } from './SpecParser';
import { CallContext } from './SpecParser';
import { DictContext } from './SpecParser';
import { SexprContext } from './SpecParser';

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by `SpecParser`.
 *
 * @param <Result> The return type of the visit operation. Use `void` for
 * operations with no return type.
 */
export default class SpecVisitor<Result> extends ParseTreeVisitor<Result> {
  /**
   * Visit a parse tree produced by `SpecParser.spec`.
   * @param ctx the parse tree
   * @return the visitor result
   */
  visitSpec?: (ctx: SpecContext) => Result;
  /**
   * Visit a parse tree produced by `SpecParser.vspec`.
   * @param ctx the parse tree
   * @return the visitor result
   */
  visitVspec?: (ctx: VspecContext) => Result;
  /**
   * Visit a parse tree produced by `SpecParser.tspec`.
   * @param ctx the parse tree
   * @return the visitor result
   */
  visitTspec?: (ctx: TspecContext) => Result;
  /**
   * Visit a parse tree produced by `SpecParser.tuple`.
   * @param ctx the parse tree
   * @return the visitor result
   */
  visitTuple?: (ctx: TupleContext) => Result;
  /**
   * Visit a parse tree produced by `SpecParser.idents`.
   * @param ctx the parse tree
   * @return the visitor result
   */
  visitIdents?: (ctx: IdentsContext) => Result;
  /**
   * Visit a parse tree produced by `SpecParser.call`.
   * @param ctx the parse tree
   * @return the visitor result
   */
  visitCall?: (ctx: CallContext) => Result;
  /**
   * Visit a parse tree produced by `SpecParser.dict`.
   * @param ctx the parse tree
   * @return the visitor result
   */
  visitDict?: (ctx: DictContext) => Result;
  /**
   * Visit a parse tree produced by `SpecParser.sexpr`.
   * @param ctx the parse tree
   * @return the visitor result
   */
  visitSexpr?: (ctx: SexprContext) => Result;
}
