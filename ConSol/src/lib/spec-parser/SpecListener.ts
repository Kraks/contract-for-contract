// @ts-nocheck
// Generated from Spec.g4 by ANTLR 4.12.0

import { ParseTreeListener } from 'antlr4';

import { SpecContext } from './SpecParser';
import { VspecContext } from './SpecParser';
import { TspecContext } from './SpecParser';
import { TupleContext } from './SpecParser';
import { IdentsContext } from './SpecParser';
import { DictContext } from './SpecParser';
import { PairContext } from './SpecParser';
import { CallContext } from './SpecParser';
import { SexprContext } from './SpecParser';

/**
 * This interface defines a complete listener for a parse tree produced by
 * `SpecParser`.
 */
export default class SpecListener extends ParseTreeListener {
  /**
   * Enter a parse tree produced by `SpecParser.spec`.
   * @param ctx the parse tree
   */
  enterSpec?: (ctx: SpecContext) => void;
  /**
   * Exit a parse tree produced by `SpecParser.spec`.
   * @param ctx the parse tree
   */
  exitSpec?: (ctx: SpecContext) => void;
  /**
   * Enter a parse tree produced by `SpecParser.vspec`.
   * @param ctx the parse tree
   */
  enterVspec?: (ctx: VspecContext) => void;
  /**
   * Exit a parse tree produced by `SpecParser.vspec`.
   * @param ctx the parse tree
   */
  exitVspec?: (ctx: VspecContext) => void;
  /**
   * Enter a parse tree produced by `SpecParser.tspec`.
   * @param ctx the parse tree
   */
  enterTspec?: (ctx: TspecContext) => void;
  /**
   * Exit a parse tree produced by `SpecParser.tspec`.
   * @param ctx the parse tree
   */
  exitTspec?: (ctx: TspecContext) => void;
  /**
   * Enter a parse tree produced by `SpecParser.tuple`.
   * @param ctx the parse tree
   */
  enterTuple?: (ctx: TupleContext) => void;
  /**
   * Exit a parse tree produced by `SpecParser.tuple`.
   * @param ctx the parse tree
   */
  exitTuple?: (ctx: TupleContext) => void;
  /**
   * Enter a parse tree produced by `SpecParser.idents`.
   * @param ctx the parse tree
   */
  enterIdents?: (ctx: IdentsContext) => void;
  /**
   * Exit a parse tree produced by `SpecParser.idents`.
   * @param ctx the parse tree
   */
  exitIdents?: (ctx: IdentsContext) => void;
  /**
   * Enter a parse tree produced by `SpecParser.dict`.
   * @param ctx the parse tree
   */
  enterDict?: (ctx: DictContext) => void;
  /**
   * Exit a parse tree produced by `SpecParser.dict`.
   * @param ctx the parse tree
   */
  exitDict?: (ctx: DictContext) => void;
  /**
   * Enter a parse tree produced by `SpecParser.pair`.
   * @param ctx the parse tree
   */
  enterPair?: (ctx: PairContext) => void;
  /**
   * Exit a parse tree produced by `SpecParser.pair`.
   * @param ctx the parse tree
   */
  exitPair?: (ctx: PairContext) => void;
  /**
   * Enter a parse tree produced by `SpecParser.call`.
   * @param ctx the parse tree
   */
  enterCall?: (ctx: CallContext) => void;
  /**
   * Exit a parse tree produced by `SpecParser.call`.
   * @param ctx the parse tree
   */
  exitCall?: (ctx: CallContext) => void;
  /**
   * Enter a parse tree produced by `SpecParser.sexpr`.
   * @param ctx the parse tree
   */
  enterSexpr?: (ctx: SexprContext) => void;
  /**
   * Exit a parse tree produced by `SpecParser.sexpr`.
   * @param ctx the parse tree
   */
  exitSexpr?: (ctx: SexprContext) => void;
}
