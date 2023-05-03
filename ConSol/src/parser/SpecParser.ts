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
	public static readonly T__6 = 7;
	public static readonly T__7 = 8;
	public static readonly T__8 = 9;
	public static readonly T__9 = 10;
	public static readonly T__10 = 11;
	public static readonly IDENT = 12;
	public static readonly INT = 13;
	public static readonly WS = 14;
	public static readonly EOF = Token.EOF;
	public static readonly RULE_spec = 0;
	public static readonly RULE_vspec = 1;
	public static readonly RULE_pair = 2;
	public static readonly RULE_expr = 3;
	public static readonly literalNames: (string | null)[] = [ null, "'{'", 
                                                            "','", "'}'", 
                                                            "'|'", "'('", 
                                                            "')'", "':'", 
                                                            "'*'", "'/'", 
                                                            "'+'", "'-'" ];
	public static readonly symbolicNames: (string | null)[] = [ null, null, 
                                                             null, null, 
                                                             null, null, 
                                                             null, null, 
                                                             null, null, 
                                                             null, null, 
                                                             "IDENT", "INT", 
                                                             "WS" ];
	// tslint:disable:no-trailing-whitespace
	public static readonly ruleNames: string[] = [
		"spec", "vspec", "pair", "expr",
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
		try {
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 8;
			this.vspec();
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
	// @RuleVersion(0)
	public vspec(): VspecContext {
		let localctx: VspecContext = new VspecContext(this, this._ctx, this.state);
		this.enterRule(localctx, 2, SpecParser.RULE_vspec);
		let _la: number;
		try {
			this.state = 61;
			this._errHandler.sync(this);
			switch ( this._interp.adaptivePredict(this._input, 8, this._ctx) ) {
			case 1:
				this.enterOuterAlt(localctx, 1);
				{
				this.state = 10;
				this.match(SpecParser.T__0);
				this.state = 23;
				this._errHandler.sync(this);
				_la = this._input.LA(1);
				if (_la===1) {
					{
					this.state = 11;
					this.match(SpecParser.T__0);
					this.state = 20;
					this._errHandler.sync(this);
					_la = this._input.LA(1);
					if (_la===12) {
						{
						this.state = 12;
						this.pair();
						this.state = 17;
						this._errHandler.sync(this);
						_la = this._input.LA(1);
						while (_la===2) {
							{
							{
							this.state = 13;
							this.match(SpecParser.T__1);
							this.state = 14;
							this.pair();
							}
							}
							this.state = 19;
							this._errHandler.sync(this);
							_la = this._input.LA(1);
						}
						}
					}

					this.state = 22;
					this.match(SpecParser.T__2);
					}
				}

				this.state = 25;
				this.match(SpecParser.IDENT);
				this.state = 26;
				this.match(SpecParser.T__3);
				this.state = 27;
				this.expr(0);
				this.state = 28;
				this.match(SpecParser.T__2);
				}
				break;
			case 2:
				this.enterOuterAlt(localctx, 2);
				{
				this.state = 30;
				this.match(SpecParser.T__0);
				this.state = 43;
				this._errHandler.sync(this);
				_la = this._input.LA(1);
				if (_la===1) {
					{
					this.state = 31;
					this.match(SpecParser.T__0);
					this.state = 40;
					this._errHandler.sync(this);
					_la = this._input.LA(1);
					if (_la===12) {
						{
						this.state = 32;
						this.pair();
						this.state = 37;
						this._errHandler.sync(this);
						_la = this._input.LA(1);
						while (_la===2) {
							{
							{
							this.state = 33;
							this.match(SpecParser.T__1);
							this.state = 34;
							this.pair();
							}
							}
							this.state = 39;
							this._errHandler.sync(this);
							_la = this._input.LA(1);
						}
						}
					}

					this.state = 42;
					this.match(SpecParser.T__2);
					}
				}

				this.state = 45;
				this.match(SpecParser.T__4);
				this.state = 54;
				this._errHandler.sync(this);
				_la = this._input.LA(1);
				if (_la===12) {
					{
					this.state = 46;
					this.match(SpecParser.IDENT);
					this.state = 51;
					this._errHandler.sync(this);
					_la = this._input.LA(1);
					while (_la===2) {
						{
						{
						this.state = 47;
						this.match(SpecParser.T__1);
						this.state = 48;
						this.match(SpecParser.IDENT);
						}
						}
						this.state = 53;
						this._errHandler.sync(this);
						_la = this._input.LA(1);
					}
					}
				}

				this.state = 56;
				this.match(SpecParser.T__5);
				this.state = 57;
				this.match(SpecParser.T__3);
				this.state = 58;
				this.expr(0);
				this.state = 59;
				this.match(SpecParser.T__2);
				}
				break;
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
	// @RuleVersion(0)
	public pair(): PairContext {
		let localctx: PairContext = new PairContext(this, this._ctx, this.state);
		this.enterRule(localctx, 4, SpecParser.RULE_pair);
		try {
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 63;
			this.match(SpecParser.IDENT);
			this.state = 64;
			this.match(SpecParser.T__6);
			this.state = 65;
			this.expr(0);
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
		let _startState: number = 6;
		this.enterRecursionRule(localctx, 6, SpecParser.RULE_expr, _p);
		let _la: number;
		try {
			let _alt: number;
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 74;
			this._errHandler.sync(this);
			switch (this._input.LA(1)) {
			case 12:
				{
				this.state = 68;
				this.match(SpecParser.IDENT);
				}
				break;
			case 13:
				{
				this.state = 69;
				this.match(SpecParser.INT);
				}
				break;
			case 5:
				{
				this.state = 70;
				this.match(SpecParser.T__4);
				this.state = 71;
				this.expr(0);
				this.state = 72;
				this.match(SpecParser.T__5);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			this._ctx.stop = this._input.LT(-1);
			this.state = 84;
			this._errHandler.sync(this);
			_alt = this._interp.adaptivePredict(this._input, 11, this._ctx);
			while (_alt !== 2 && _alt !== ATN.INVALID_ALT_NUMBER) {
				if (_alt === 1) {
					if (this._parseListeners != null) {
						this.triggerExitRuleEvent();
					}
					_prevctx = localctx;
					{
					this.state = 82;
					this._errHandler.sync(this);
					switch ( this._interp.adaptivePredict(this._input, 10, this._ctx) ) {
					case 1:
						{
						localctx = new ExprContext(this, _parentctx, _parentState);
						this.pushNewRecursionContext(localctx, _startState, SpecParser.RULE_expr);
						this.state = 76;
						if (!(this.precpred(this._ctx, 5))) {
							throw this.createFailedPredicateException("this.precpred(this._ctx, 5)");
						}
						this.state = 77;
						_la = this._input.LA(1);
						if(!(_la===8 || _la===9)) {
						this._errHandler.recoverInline(this);
						}
						else {
							this._errHandler.reportMatch(this);
						    this.consume();
						}
						this.state = 78;
						this.expr(6);
						}
						break;
					case 2:
						{
						localctx = new ExprContext(this, _parentctx, _parentState);
						this.pushNewRecursionContext(localctx, _startState, SpecParser.RULE_expr);
						this.state = 79;
						if (!(this.precpred(this._ctx, 4))) {
							throw this.createFailedPredicateException("this.precpred(this._ctx, 4)");
						}
						this.state = 80;
						_la = this._input.LA(1);
						if(!(_la===10 || _la===11)) {
						this._errHandler.recoverInline(this);
						}
						else {
							this._errHandler.reportMatch(this);
						    this.consume();
						}
						this.state = 81;
						this.expr(5);
						}
						break;
					}
					}
				}
				this.state = 86;
				this._errHandler.sync(this);
				_alt = this._interp.adaptivePredict(this._input, 11, this._ctx);
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
		case 3:
			return this.expr_sempred(localctx as ExprContext, predIndex);
		}
		return true;
	}
	private expr_sempred(localctx: ExprContext, predIndex: number): boolean {
		switch (predIndex) {
		case 0:
			return this.precpred(this._ctx, 5);
		case 1:
			return this.precpred(this._ctx, 4);
		}
		return true;
	}

	public static readonly _serializedATN: number[] = [4,1,14,88,2,0,7,0,2,
	1,7,1,2,2,7,2,2,3,7,3,1,0,1,0,1,1,1,1,1,1,1,1,1,1,5,1,16,8,1,10,1,12,1,
	19,9,1,3,1,21,8,1,1,1,3,1,24,8,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,5,1,36,8,1,10,1,12,1,39,9,1,3,1,41,8,1,1,1,3,1,44,8,1,1,1,1,1,1,1,1,1,
	5,1,50,8,1,10,1,12,1,53,9,1,3,1,55,8,1,1,1,1,1,1,1,1,1,1,1,3,1,62,8,1,1,
	2,1,2,1,2,1,2,1,3,1,3,1,3,1,3,1,3,1,3,1,3,3,3,75,8,3,1,3,1,3,1,3,1,3,1,
	3,1,3,5,3,83,8,3,10,3,12,3,86,9,3,1,3,0,1,6,4,0,2,4,6,0,2,1,0,8,9,1,0,10,
	11,96,0,8,1,0,0,0,2,61,1,0,0,0,4,63,1,0,0,0,6,74,1,0,0,0,8,9,3,2,1,0,9,
	1,1,0,0,0,10,23,5,1,0,0,11,20,5,1,0,0,12,17,3,4,2,0,13,14,5,2,0,0,14,16,
	3,4,2,0,15,13,1,0,0,0,16,19,1,0,0,0,17,15,1,0,0,0,17,18,1,0,0,0,18,21,1,
	0,0,0,19,17,1,0,0,0,20,12,1,0,0,0,20,21,1,0,0,0,21,22,1,0,0,0,22,24,5,3,
	0,0,23,11,1,0,0,0,23,24,1,0,0,0,24,25,1,0,0,0,25,26,5,12,0,0,26,27,5,4,
	0,0,27,28,3,6,3,0,28,29,5,3,0,0,29,62,1,0,0,0,30,43,5,1,0,0,31,40,5,1,0,
	0,32,37,3,4,2,0,33,34,5,2,0,0,34,36,3,4,2,0,35,33,1,0,0,0,36,39,1,0,0,0,
	37,35,1,0,0,0,37,38,1,0,0,0,38,41,1,0,0,0,39,37,1,0,0,0,40,32,1,0,0,0,40,
	41,1,0,0,0,41,42,1,0,0,0,42,44,5,3,0,0,43,31,1,0,0,0,43,44,1,0,0,0,44,45,
	1,0,0,0,45,54,5,5,0,0,46,51,5,12,0,0,47,48,5,2,0,0,48,50,5,12,0,0,49,47,
	1,0,0,0,50,53,1,0,0,0,51,49,1,0,0,0,51,52,1,0,0,0,52,55,1,0,0,0,53,51,1,
	0,0,0,54,46,1,0,0,0,54,55,1,0,0,0,55,56,1,0,0,0,56,57,5,6,0,0,57,58,5,4,
	0,0,58,59,3,6,3,0,59,60,5,3,0,0,60,62,1,0,0,0,61,10,1,0,0,0,61,30,1,0,0,
	0,62,3,1,0,0,0,63,64,5,12,0,0,64,65,5,7,0,0,65,66,3,6,3,0,66,5,1,0,0,0,
	67,68,6,3,-1,0,68,75,5,12,0,0,69,75,5,13,0,0,70,71,5,5,0,0,71,72,3,6,3,
	0,72,73,5,6,0,0,73,75,1,0,0,0,74,67,1,0,0,0,74,69,1,0,0,0,74,70,1,0,0,0,
	75,84,1,0,0,0,76,77,10,5,0,0,77,78,7,0,0,0,78,83,3,6,3,6,79,80,10,4,0,0,
	80,81,7,1,0,0,81,83,3,6,3,5,82,76,1,0,0,0,82,79,1,0,0,0,83,86,1,0,0,0,84,
	82,1,0,0,0,84,85,1,0,0,0,85,7,1,0,0,0,86,84,1,0,0,0,12,17,20,23,37,40,43,
	51,54,61,74,82,84];

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
	public vspec(): VspecContext {
		return this.getTypedRuleContext(VspecContext, 0) as VspecContext;
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


export class VspecContext extends ParserRuleContext {
	constructor(parser?: SpecParser, parent?: ParserRuleContext, invokingState?: number) {
		super(parent, invokingState);
    	this.parser = parser;
	}
	public IDENT_list(): TerminalNode[] {
	    	return this.getTokens(SpecParser.IDENT);
	}
	public IDENT(i: number): TerminalNode {
		return this.getToken(SpecParser.IDENT, i);
	}
	public expr(): ExprContext {
		return this.getTypedRuleContext(ExprContext, 0) as ExprContext;
	}
	public pair_list(): PairContext[] {
		return this.getTypedRuleContexts(PairContext) as PairContext[];
	}
	public pair(i: number): PairContext {
		return this.getTypedRuleContext(PairContext, i) as PairContext;
	}
    public get ruleIndex(): number {
    	return SpecParser.RULE_vspec;
	}
	public enterRule(listener: SpecListener): void {
	    if(listener.enterVspec) {
	 		listener.enterVspec(this);
		}
	}
	public exitRule(listener: SpecListener): void {
	    if(listener.exitVspec) {
	 		listener.exitVspec(this);
		}
	}
	// @Override
	public accept<Result>(visitor: SpecVisitor<Result>): Result {
		if (visitor.visitVspec) {
			return visitor.visitVspec(this);
		} else {
			return visitor.visitChildren(this);
		}
	}
}


export class PairContext extends ParserRuleContext {
	constructor(parser?: SpecParser, parent?: ParserRuleContext, invokingState?: number) {
		super(parent, invokingState);
    	this.parser = parser;
	}
	public IDENT(): TerminalNode {
		return this.getToken(SpecParser.IDENT, 0);
	}
	public expr(): ExprContext {
		return this.getTypedRuleContext(ExprContext, 0) as ExprContext;
	}
    public get ruleIndex(): number {
    	return SpecParser.RULE_pair;
	}
	public enterRule(listener: SpecListener): void {
	    if(listener.enterPair) {
	 		listener.enterPair(this);
		}
	}
	public exitRule(listener: SpecListener): void {
	    if(listener.exitPair) {
	 		listener.exitPair(this);
		}
	}
	// @Override
	public accept<Result>(visitor: SpecVisitor<Result>): Result {
		if (visitor.visitPair) {
			return visitor.visitPair(this);
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
	public IDENT(): TerminalNode {
		return this.getToken(SpecParser.IDENT, 0);
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
