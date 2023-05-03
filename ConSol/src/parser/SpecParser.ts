// @ts-nocheck
// Generated from Spec.g4 by ANTLR 4.12.0
// noinspection ES6UnusedImports,JSUnusedGlobalSymbols,JSUnusedLocalSymbols

import {
	ATN,
	ATNDeserializer, DecisionState, DFA, FailedPredicateException,
	RecognitionException, NoViableAltException, BailErrorStrategy,
	Parser, ParserATNSimulator,
	RuleContext, ParserRuleContext, PredictionMode, PredictionContextCache,
	TerminalNode, RuleNode,
	Token, TokenStream,
	Interval, IntervalSet
} from 'antlr4';
import SpecListener from "./SpecListener.js";
import SpecVisitor from "./SpecVisitor.js";

// for running tests with parameters, TODO: discuss strategy for typed parameters in CI
// eslint-disable-next-line no-unused-vars
type int = number;

export default class SpecParser extends Parser {
	public static readonly T__0 = 1;
	public static readonly T__1 = 2;
	public static readonly T__2 = 3;
	public static readonly T__3 = 4;
	public static readonly T__4 = 5;
	public static readonly T__5 = 6;
	public static readonly NEWLINE = 7;
	public static readonly INT = 8;
	public static readonly EOF = Token.EOF;
	public static readonly RULE_spec = 0;
	public static readonly RULE_expr = 1;
	public static readonly literalNames: (string | null)[] = [ null, "'*'", 
                                                            "'/'", "'+'", 
                                                            "'-'", "'('", 
                                                            "')'" ];
	public static readonly symbolicNames: (string | null)[] = [ null, null, 
                                                             null, null, 
                                                             null, null, 
                                                             null, "NEWLINE", 
                                                             "INT" ];
	// tslint:disable:no-trailing-whitespace
	public static readonly ruleNames: string[] = [
		"spec", "expr",
	];
	public get grammarFileName(): string { return "Spec.g4"; }
	public get literalNames(): (string | null)[] { return SpecParser.literalNames; }
	public get symbolicNames(): (string | null)[] { return SpecParser.symbolicNames; }
	public get ruleNames(): string[] { return SpecParser.ruleNames; }
	public get serializedATN(): number[] { return SpecParser._serializedATN; }

	protected createFailedPredicateException(predicate?: string, message?: string): FailedPredicateException {
		return new FailedPredicateException(this, predicate, message);
	}

	constructor(input: TokenStream) {
		super(input);
		this._interp = new ParserATNSimulator(this, SpecParser._ATN, SpecParser.DecisionsToDFA, new PredictionContextCache());
	}
	// @RuleVersion(0)
	public spec(): SpecContext {
		let localctx: SpecContext = new SpecContext(this, this._ctx, this.state);
		this.enterRule(localctx, 0, SpecParser.RULE_spec);
		let _la: number;
		try {
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 9;
			this._errHandler.sync(this);
			_la = this._input.LA(1);
			while (_la===5 || _la===8) {
				{
				{
				this.state = 4;
				this.expr(0);
				this.state = 5;
				this.match(SpecParser.NEWLINE);
				}
				}
				this.state = 11;
				this._errHandler.sync(this);
				_la = this._input.LA(1);
			}
			}
		}
		catch (re) {
			if (re instanceof RecognitionException) {
				localctx.exception = re;
				this._errHandler.reportError(this, re);
				this._errHandler.recover(this, re);
			} else {
				throw re;
			}
		}
		finally {
			this.exitRule();
		}
		return localctx;
	}

	public expr(): ExprContext;
	public expr(_p: number): ExprContext;
	// @RuleVersion(0)
	public expr(_p?: number): ExprContext {
		if (_p === undefined) {
			_p = 0;
		}

		let _parentctx: ParserRuleContext = this._ctx;
		let _parentState: number = this.state;
		let localctx: ExprContext = new ExprContext(this, this._ctx, _parentState);
		let _prevctx: ExprContext = localctx;
		let _startState: number = 2;
		this.enterRecursionRule(localctx, 2, SpecParser.RULE_expr, _p);
		let _la: number;
		try {
			let _alt: number;
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 18;
			this._errHandler.sync(this);
			switch (this._input.LA(1)) {
			case 8:
				{
				this.state = 13;
				this.match(SpecParser.INT);
				}
				break;
			case 5:
				{
				this.state = 14;
				this.match(SpecParser.T__4);
				this.state = 15;
				this.expr(0);
				this.state = 16;
				this.match(SpecParser.T__5);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			this._ctx.stop = this._input.LT(-1);
			this.state = 28;
			this._errHandler.sync(this);
			_alt = this._interp.adaptivePredict(this._input, 3, this._ctx);
			while (_alt !== 2 && _alt !== ATN.INVALID_ALT_NUMBER) {
				if (_alt === 1) {
					if (this._parseListeners != null) {
						this.triggerExitRuleEvent();
					}
					_prevctx = localctx;
					{
					this.state = 26;
					this._errHandler.sync(this);
					switch ( this._interp.adaptivePredict(this._input, 2, this._ctx) ) {
					case 1:
						{
						localctx = new ExprContext(this, _parentctx, _parentState);
						this.pushNewRecursionContext(localctx, _startState, SpecParser.RULE_expr);
						this.state = 20;
						if (!(this.precpred(this._ctx, 4))) {
							throw this.createFailedPredicateException("this.precpred(this._ctx, 4)");
						}
						this.state = 21;
						_la = this._input.LA(1);
						if(!(_la===1 || _la===2)) {
						this._errHandler.recoverInline(this);
						}
						else {
							this._errHandler.reportMatch(this);
						    this.consume();
						}
						this.state = 22;
						this.expr(5);
						}
						break;
					case 2:
						{
						localctx = new ExprContext(this, _parentctx, _parentState);
						this.pushNewRecursionContext(localctx, _startState, SpecParser.RULE_expr);
						this.state = 23;
						if (!(this.precpred(this._ctx, 3))) {
							throw this.createFailedPredicateException("this.precpred(this._ctx, 3)");
						}
						this.state = 24;
						_la = this._input.LA(1);
						if(!(_la===3 || _la===4)) {
						this._errHandler.recoverInline(this);
						}
						else {
							this._errHandler.reportMatch(this);
						    this.consume();
						}
						this.state = 25;
						this.expr(4);
						}
						break;
					}
					}
				}
				this.state = 30;
				this._errHandler.sync(this);
				_alt = this._interp.adaptivePredict(this._input, 3, this._ctx);
			}
			}
		}
		catch (re) {
			if (re instanceof RecognitionException) {
				localctx.exception = re;
				this._errHandler.reportError(this, re);
				this._errHandler.recover(this, re);
			} else {
				throw re;
			}
		}
		finally {
			this.unrollRecursionContexts(_parentctx);
		}
		return localctx;
	}

	public sempred(localctx: RuleContext, ruleIndex: number, predIndex: number): boolean {
		switch (ruleIndex) {
		case 1:
			return this.expr_sempred(localctx as ExprContext, predIndex);
		}
		return true;
	}
	private expr_sempred(localctx: ExprContext, predIndex: number): boolean {
		switch (predIndex) {
		case 0:
			return this.precpred(this._ctx, 4);
		case 1:
			return this.precpred(this._ctx, 3);
		}
		return true;
	}

	public static readonly _serializedATN: number[] = [4,1,8,32,2,0,7,0,2,1,
	7,1,1,0,1,0,1,0,5,0,8,8,0,10,0,12,0,11,9,0,1,1,1,1,1,1,1,1,1,1,1,1,3,1,
	19,8,1,1,1,1,1,1,1,1,1,1,1,1,1,5,1,27,8,1,10,1,12,1,30,9,1,1,1,0,1,2,2,
	0,2,0,2,1,0,1,2,1,0,3,4,33,0,9,1,0,0,0,2,18,1,0,0,0,4,5,3,2,1,0,5,6,5,7,
	0,0,6,8,1,0,0,0,7,4,1,0,0,0,8,11,1,0,0,0,9,7,1,0,0,0,9,10,1,0,0,0,10,1,
	1,0,0,0,11,9,1,0,0,0,12,13,6,1,-1,0,13,19,5,8,0,0,14,15,5,5,0,0,15,16,3,
	2,1,0,16,17,5,6,0,0,17,19,1,0,0,0,18,12,1,0,0,0,18,14,1,0,0,0,19,28,1,0,
	0,0,20,21,10,4,0,0,21,22,7,0,0,0,22,27,3,2,1,5,23,24,10,3,0,0,24,25,7,1,
	0,0,25,27,3,2,1,4,26,20,1,0,0,0,26,23,1,0,0,0,27,30,1,0,0,0,28,26,1,0,0,
	0,28,29,1,0,0,0,29,3,1,0,0,0,30,28,1,0,0,0,4,9,18,26,28];

	private static __ATN: ATN;
	public static get _ATN(): ATN {
		if (!SpecParser.__ATN) {
			SpecParser.__ATN = new ATNDeserializer().deserialize(SpecParser._serializedATN);
		}

		return SpecParser.__ATN;
	}


	static DecisionsToDFA = SpecParser._ATN.decisionToState.map( (ds: DecisionState, index: number) => new DFA(ds, index) );

}

export class SpecContext extends ParserRuleContext {
	constructor(parser?: SpecParser, parent?: ParserRuleContext, invokingState?: number) {
		super(parent, invokingState);
    	this.parser = parser;
	}
	public expr_list(): ExprContext[] {
		return this.getTypedRuleContexts(ExprContext) as ExprContext[];
	}
	public expr(i: number): ExprContext {
		return this.getTypedRuleContext(ExprContext, i) as ExprContext;
	}
	public NEWLINE_list(): TerminalNode[] {
	    	return this.getTokens(SpecParser.NEWLINE);
	}
	public NEWLINE(i: number): TerminalNode {
		return this.getToken(SpecParser.NEWLINE, i);
	}
    public get ruleIndex(): number {
    	return SpecParser.RULE_spec;
	}
	public enterRule(listener: SpecListener): void {
	    if(listener.enterSpec) {
	 		listener.enterSpec(this);
		}
	}
	public exitRule(listener: SpecListener): void {
	    if(listener.exitSpec) {
	 		listener.exitSpec(this);
		}
	}
	// @Override
	public accept<Result>(visitor: SpecVisitor<Result>): Result {
		if (visitor.visitSpec) {
			return visitor.visitSpec(this);
		} else {
			return visitor.visitChildren(this);
		}
	}
}


export class ExprContext extends ParserRuleContext {
	constructor(parser?: SpecParser, parent?: ParserRuleContext, invokingState?: number) {
		super(parent, invokingState);
    	this.parser = parser;
	}
	public INT(): TerminalNode {
		return this.getToken(SpecParser.INT, 0);
	}
	public expr_list(): ExprContext[] {
		return this.getTypedRuleContexts(ExprContext) as ExprContext[];
	}
	public expr(i: number): ExprContext {
		return this.getTypedRuleContext(ExprContext, i) as ExprContext;
	}
    public get ruleIndex(): number {
    	return SpecParser.RULE_expr;
	}
	public enterRule(listener: SpecListener): void {
	    if(listener.enterExpr) {
	 		listener.enterExpr(this);
		}
	}
	public exitRule(listener: SpecListener): void {
	    if(listener.exitExpr) {
	 		listener.exitExpr(this);
		}
	}
	// @Override
	public accept<Result>(visitor: SpecVisitor<Result>): Result {
		if (visitor.visitExpr) {
			return visitor.visitExpr(this);
		} else {
			return visitor.visitChildren(this);
		}
	}
}
