// @ts-nocheck
// Generated from Spec.g4 by ANTLR 4.12.0

import {ParseTreeVisitor} from 'antlr4';


import { SpecContext } from "./SpecParser";
import { VspecContext } from "./SpecParser";
import { ArgsContext } from "./SpecParser";
import { TupleContext } from "./SpecParser";
import { DictContext } from "./SpecParser";
import { IdentsContext } from "./SpecParser";
import { PairsContext } from "./SpecParser";
import { PairContext } from "./SpecParser";
import { ExprContext } from "./SpecParser";


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
	 * Visit a parse tree produced by `SpecParser.args`.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	visitArgs?: (ctx: ArgsContext) => Result;
	/**
	 * Visit a parse tree produced by `SpecParser.tuple`.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	visitTuple?: (ctx: TupleContext) => Result;
	/**
	 * Visit a parse tree produced by `SpecParser.dict`.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	visitDict?: (ctx: DictContext) => Result;
	/**
	 * Visit a parse tree produced by `SpecParser.idents`.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	visitIdents?: (ctx: IdentsContext) => Result;
	/**
	 * Visit a parse tree produced by `SpecParser.pairs`.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	visitPairs?: (ctx: PairsContext) => Result;
	/**
	 * Visit a parse tree produced by `SpecParser.pair`.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	visitPair?: (ctx: PairContext) => Result;
	/**
	 * Visit a parse tree produced by `SpecParser.expr`.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	visitExpr?: (ctx: ExprContext) => Result;
}

