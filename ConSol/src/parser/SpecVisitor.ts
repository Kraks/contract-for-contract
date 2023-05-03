// @ts-nocheck
// Generated from Spec.g4 by ANTLR 4.12.0

import {ParseTreeVisitor} from 'antlr4';


import { SpecContext } from "./SpecParser";
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
	 * Visit a parse tree produced by `SpecParser.expr`.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	visitExpr?: (ctx: ExprContext) => Result;
}

