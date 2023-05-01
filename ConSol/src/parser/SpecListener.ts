// @ts-nocheck
// Generated from Spec.g4 by ANTLR 4.12.0

import {ParseTreeListener} from "antlr4";


import { ProgContext } from "./SpecParser";
import { ExprContext } from "./SpecParser";


/**
 * This interface defines a complete listener for a parse tree produced by
 * `SpecParser`.
 */
export default class SpecListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by `SpecParser.prog`.
	 * @param ctx the parse tree
	 */
	enterProg?: (ctx: ProgContext) => void;
	/**
	 * Exit a parse tree produced by `SpecParser.prog`.
	 * @param ctx the parse tree
	 */
	exitProg?: (ctx: ProgContext) => void;
	/**
	 * Enter a parse tree produced by `SpecParser.expr`.
	 * @param ctx the parse tree
	 */
	enterExpr?: (ctx: ExprContext) => void;
	/**
	 * Exit a parse tree produced by `SpecParser.expr`.
	 * @param ctx the parse tree
	 */
	exitExpr?: (ctx: ExprContext) => void;
}

