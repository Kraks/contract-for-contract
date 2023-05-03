// @ts-nocheck
// Generated from Spec.g4 by ANTLR 4.12.0

import {ParseTreeListener} from "antlr4";


import { SpecContext } from "./SpecParser";
import { VspecContext } from "./SpecParser";
import { ArgsContext } from "./SpecParser";
import { IdentsContext } from "./SpecParser";
import { DictContext } from "./SpecParser";
import { PairContext } from "./SpecParser";
import { SexprContext } from "./SpecParser";


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
	 * Enter a parse tree produced by `SpecParser.args`.
	 * @param ctx the parse tree
	 */
	enterArgs?: (ctx: ArgsContext) => void;
	/**
	 * Exit a parse tree produced by `SpecParser.args`.
	 * @param ctx the parse tree
	 */
	exitArgs?: (ctx: ArgsContext) => void;
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

