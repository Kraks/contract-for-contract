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
	public static readonly RULE_args = 2;
	public static readonly RULE_tuple = 3;
	public static readonly RULE_dict = 4;
	public static readonly RULE_idents = 5;
	public static readonly RULE_pairs = 6;
	public static readonly RULE_pair = 7;
	public static readonly RULE_expr = 8;
	public static readonly literalNames: (string | null)[] = [ null, "'{'", 
                                                            "'|'", "'}'", 
                                                            "'('", "')'", 
                                                            "','", "':'", 
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
		"spec", "vspec", "args", "tuple", "dict", "idents", "pairs", "pair", "expr",
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
			this.state = 18;
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
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 20;
			this.match(SpecParser.T__0);
			this.state = 22;
			this._errHandler.sync(this);
			_la = this._input.LA(1);
			if (_la===1) {
				{
				this.state = 21;
				this.dict();
				}
			}

			this.state = 24;
			this.args();
			this.state = 25;
			this.match(SpecParser.T__1);
			this.state = 26;
			this.expr(0);
			this.state = 27;
			this.match(SpecParser.T__2);
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
	public args(): ArgsContext {
		let localctx: ArgsContext = new ArgsContext(this, this._ctx, this.state);
		this.enterRule(localctx, 4, SpecParser.RULE_args);
		try {
			this.state = 31;
			this._errHandler.sync(this);
			switch (this._input.LA(1)) {
			case 12:
				this.enterOuterAlt(localctx, 1);
				{
				this.state = 29;
				this.match(SpecParser.IDENT);
				}
				break;
			case 4:
				this.enterOuterAlt(localctx, 2);
				{
				this.state = 30;
				this.tuple();
				}
				break;
			default:
				throw new NoViableAltException(this);
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
	public tuple(): TupleContext {
		let localctx: TupleContext = new TupleContext(this, this._ctx, this.state);
		this.enterRule(localctx, 6, SpecParser.RULE_tuple);
		try {
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 33;
			this.match(SpecParser.T__3);
			this.state = 34;
			this.idents();
			this.state = 35;
			this.match(SpecParser.T__4);
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
	public dict(): DictContext {
		let localctx: DictContext = new DictContext(this, this._ctx, this.state);
		this.enterRule(localctx, 8, SpecParser.RULE_dict);
		try {
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 37;
			this.match(SpecParser.T__0);
			this.state = 38;
			this.pairs();
			this.state = 39;
			this.match(SpecParser.T__2);
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
	public idents(): IdentsContext {
		let localctx: IdentsContext = new IdentsContext(this, this._ctx, this.state);
		this.enterRule(localctx, 10, SpecParser.RULE_idents);
		let _la: number;
		try {
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 49;
			this._errHandler.sync(this);
			_la = this._input.LA(1);
			if (_la===12) {
				{
				this.state = 41;
				this.match(SpecParser.IDENT);
				this.state = 46;
				this._errHandler.sync(this);
				_la = this._input.LA(1);
				while (_la===6) {
					{
					{
					this.state = 42;
					this.match(SpecParser.T__5);
					this.state = 43;
					this.match(SpecParser.IDENT);
					}
					}
					this.state = 48;
					this._errHandler.sync(this);
					_la = this._input.LA(1);
				}
				}
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
	// @RuleVersion(0)
	public pairs(): PairsContext {
		let localctx: PairsContext = new PairsContext(this, this._ctx, this.state);
		this.enterRule(localctx, 12, SpecParser.RULE_pairs);
		let _la: number;
		try {
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 59;
			this._errHandler.sync(this);
			_la = this._input.LA(1);
			if (_la===12) {
				{
				this.state = 51;
				this.pair();
				this.state = 56;
				this._errHandler.sync(this);
				_la = this._input.LA(1);
				while (_la===6) {
					{
					{
					this.state = 52;
					this.match(SpecParser.T__5);
					this.state = 53;
					this.pair();
					}
					}
					this.state = 58;
					this._errHandler.sync(this);
					_la = this._input.LA(1);
				}
				}
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
	// @RuleVersion(0)
	public pair(): PairContext {
		let localctx: PairContext = new PairContext(this, this._ctx, this.state);
		this.enterRule(localctx, 14, SpecParser.RULE_pair);
		try {
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 61;
			this.match(SpecParser.IDENT);
			this.state = 62;
			this.match(SpecParser.T__6);
			this.state = 63;
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
		let _startState: number = 16;
		this.enterRecursionRule(localctx, 16, SpecParser.RULE_expr, _p);
		let _la: number;
		try {
			let _alt: number;
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 72;
			this._errHandler.sync(this);
			switch (this._input.LA(1)) {
			case 12:
				{
				this.state = 66;
				this.match(SpecParser.IDENT);
				}
				break;
			case 13:
				{
				this.state = 67;
				this.match(SpecParser.INT);
				}
				break;
			case 4:
				{
				this.state = 68;
				this.match(SpecParser.T__3);
				this.state = 69;
				this.expr(0);
				this.state = 70;
				this.match(SpecParser.T__4);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			this._ctx.stop = this._input.LT(-1);
			this.state = 82;
			this._errHandler.sync(this);
			_alt = this._interp.adaptivePredict(this._input, 8, this._ctx);
			while (_alt !== 2 && _alt !== ATN.INVALID_ALT_NUMBER) {
				if (_alt === 1) {
					if (this._parseListeners != null) {
						this.triggerExitRuleEvent();
					}
					_prevctx = localctx;
					{
					this.state = 80;
					this._errHandler.sync(this);
					switch ( this._interp.adaptivePredict(this._input, 7, this._ctx) ) {
					case 1:
						{
						localctx = new ExprContext(this, _parentctx, _parentState);
						this.pushNewRecursionContext(localctx, _startState, SpecParser.RULE_expr);
						this.state = 74;
						if (!(this.precpred(this._ctx, 5))) {
							throw this.createFailedPredicateException("this.precpred(this._ctx, 5)");
						}
						this.state = 75;
						_la = this._input.LA(1);
						if(!(_la===8 || _la===9)) {
						this._errHandler.recoverInline(this);
						}
						else {
							this._errHandler.reportMatch(this);
						    this.consume();
						}
						this.state = 76;
						this.expr(6);
						}
						break;
					case 2:
						{
						localctx = new ExprContext(this, _parentctx, _parentState);
						this.pushNewRecursionContext(localctx, _startState, SpecParser.RULE_expr);
						this.state = 77;
						if (!(this.precpred(this._ctx, 4))) {
							throw this.createFailedPredicateException("this.precpred(this._ctx, 4)");
						}
						this.state = 78;
						_la = this._input.LA(1);
						if(!(_la===10 || _la===11)) {
						this._errHandler.recoverInline(this);
						}
						else {
							this._errHandler.reportMatch(this);
						    this.consume();
						}
						this.state = 79;
						this.expr(5);
						}
						break;
					}
					}
				}
				this.state = 84;
				this._errHandler.sync(this);
				_alt = this._interp.adaptivePredict(this._input, 8, this._ctx);
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
		case 8:
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

	public static readonly _serializedATN: number[] = [4,1,14,86,2,0,7,0,2,
	1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,6,2,7,7,7,2,8,7,8,1,0,1,0,1,
	1,1,1,3,1,23,8,1,1,1,1,1,1,1,1,1,1,1,1,2,1,2,3,2,32,8,2,1,3,1,3,1,3,1,3,
	1,4,1,4,1,4,1,4,1,5,1,5,1,5,5,5,45,8,5,10,5,12,5,48,9,5,3,5,50,8,5,1,6,
	1,6,1,6,5,6,55,8,6,10,6,12,6,58,9,6,3,6,60,8,6,1,7,1,7,1,7,1,7,1,8,1,8,
	1,8,1,8,1,8,1,8,1,8,3,8,73,8,8,1,8,1,8,1,8,1,8,1,8,1,8,5,8,81,8,8,10,8,
	12,8,84,9,8,1,8,0,1,16,9,0,2,4,6,8,10,12,14,16,0,2,1,0,8,9,1,0,10,11,86,
	0,18,1,0,0,0,2,20,1,0,0,0,4,31,1,0,0,0,6,33,1,0,0,0,8,37,1,0,0,0,10,49,
	1,0,0,0,12,59,1,0,0,0,14,61,1,0,0,0,16,72,1,0,0,0,18,19,3,2,1,0,19,1,1,
	0,0,0,20,22,5,1,0,0,21,23,3,8,4,0,22,21,1,0,0,0,22,23,1,0,0,0,23,24,1,0,
	0,0,24,25,3,4,2,0,25,26,5,2,0,0,26,27,3,16,8,0,27,28,5,3,0,0,28,3,1,0,0,
	0,29,32,5,12,0,0,30,32,3,6,3,0,31,29,1,0,0,0,31,30,1,0,0,0,32,5,1,0,0,0,
	33,34,5,4,0,0,34,35,3,10,5,0,35,36,5,5,0,0,36,7,1,0,0,0,37,38,5,1,0,0,38,
	39,3,12,6,0,39,40,5,3,0,0,40,9,1,0,0,0,41,46,5,12,0,0,42,43,5,6,0,0,43,
	45,5,12,0,0,44,42,1,0,0,0,45,48,1,0,0,0,46,44,1,0,0,0,46,47,1,0,0,0,47,
	50,1,0,0,0,48,46,1,0,0,0,49,41,1,0,0,0,49,50,1,0,0,0,50,11,1,0,0,0,51,56,
	3,14,7,0,52,53,5,6,0,0,53,55,3,14,7,0,54,52,1,0,0,0,55,58,1,0,0,0,56,54,
	1,0,0,0,56,57,1,0,0,0,57,60,1,0,0,0,58,56,1,0,0,0,59,51,1,0,0,0,59,60,1,
	0,0,0,60,13,1,0,0,0,61,62,5,12,0,0,62,63,5,7,0,0,63,64,3,16,8,0,64,15,1,
	0,0,0,65,66,6,8,-1,0,66,73,5,12,0,0,67,73,5,13,0,0,68,69,5,4,0,0,69,70,
	3,16,8,0,70,71,5,5,0,0,71,73,1,0,0,0,72,65,1,0,0,0,72,67,1,0,0,0,72,68,
	1,0,0,0,73,82,1,0,0,0,74,75,10,5,0,0,75,76,7,0,0,0,76,81,3,16,8,6,77,78,
	10,4,0,0,78,79,7,1,0,0,79,81,3,16,8,5,80,74,1,0,0,0,80,77,1,0,0,0,81,84,
	1,0,0,0,82,80,1,0,0,0,82,83,1,0,0,0,83,17,1,0,0,0,84,82,1,0,0,0,9,22,31,
	46,49,56,59,72,80,82];

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
	public args(): ArgsContext {
		return this.getTypedRuleContext(ArgsContext, 0) as ArgsContext;
	}
	public expr(): ExprContext {
		return this.getTypedRuleContext(ExprContext, 0) as ExprContext;
	}
	public dict(): DictContext {
		return this.getTypedRuleContext(DictContext, 0) as DictContext;
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


export class ArgsContext extends ParserRuleContext {
	constructor(parser?: SpecParser, parent?: ParserRuleContext, invokingState?: number) {
		super(parent, invokingState);
    	this.parser = parser;
	}
	public IDENT(): TerminalNode {
		return this.getToken(SpecParser.IDENT, 0);
	}
	public tuple(): TupleContext {
		return this.getTypedRuleContext(TupleContext, 0) as TupleContext;
	}
    public get ruleIndex(): number {
    	return SpecParser.RULE_args;
	}
	public enterRule(listener: SpecListener): void {
	    if(listener.enterArgs) {
	 		listener.enterArgs(this);
		}
	}
	public exitRule(listener: SpecListener): void {
	    if(listener.exitArgs) {
	 		listener.exitArgs(this);
		}
	}
	// @Override
	public accept<Result>(visitor: SpecVisitor<Result>): Result {
		if (visitor.visitArgs) {
			return visitor.visitArgs(this);
		} else {
			return visitor.visitChildren(this);
		}
	}
}


export class TupleContext extends ParserRuleContext {
	constructor(parser?: SpecParser, parent?: ParserRuleContext, invokingState?: number) {
		super(parent, invokingState);
    	this.parser = parser;
	}
	public idents(): IdentsContext {
		return this.getTypedRuleContext(IdentsContext, 0) as IdentsContext;
	}
    public get ruleIndex(): number {
    	return SpecParser.RULE_tuple;
	}
	public enterRule(listener: SpecListener): void {
	    if(listener.enterTuple) {
	 		listener.enterTuple(this);
		}
	}
	public exitRule(listener: SpecListener): void {
	    if(listener.exitTuple) {
	 		listener.exitTuple(this);
		}
	}
	// @Override
	public accept<Result>(visitor: SpecVisitor<Result>): Result {
		if (visitor.visitTuple) {
			return visitor.visitTuple(this);
		} else {
			return visitor.visitChildren(this);
		}
	}
}


export class DictContext extends ParserRuleContext {
	constructor(parser?: SpecParser, parent?: ParserRuleContext, invokingState?: number) {
		super(parent, invokingState);
    	this.parser = parser;
	}
	public pairs(): PairsContext {
		return this.getTypedRuleContext(PairsContext, 0) as PairsContext;
	}
    public get ruleIndex(): number {
    	return SpecParser.RULE_dict;
	}
	public enterRule(listener: SpecListener): void {
	    if(listener.enterDict) {
	 		listener.enterDict(this);
		}
	}
	public exitRule(listener: SpecListener): void {
	    if(listener.exitDict) {
	 		listener.exitDict(this);
		}
	}
	// @Override
	public accept<Result>(visitor: SpecVisitor<Result>): Result {
		if (visitor.visitDict) {
			return visitor.visitDict(this);
		} else {
			return visitor.visitChildren(this);
		}
	}
}


export class IdentsContext extends ParserRuleContext {
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
    public get ruleIndex(): number {
    	return SpecParser.RULE_idents;
	}
	public enterRule(listener: SpecListener): void {
	    if(listener.enterIdents) {
	 		listener.enterIdents(this);
		}
	}
	public exitRule(listener: SpecListener): void {
	    if(listener.exitIdents) {
	 		listener.exitIdents(this);
		}
	}
	// @Override
	public accept<Result>(visitor: SpecVisitor<Result>): Result {
		if (visitor.visitIdents) {
			return visitor.visitIdents(this);
		} else {
			return visitor.visitChildren(this);
		}
	}
}


export class PairsContext extends ParserRuleContext {
	constructor(parser?: SpecParser, parent?: ParserRuleContext, invokingState?: number) {
		super(parent, invokingState);
    	this.parser = parser;
	}
	public pair_list(): PairContext[] {
		return this.getTypedRuleContexts(PairContext) as PairContext[];
	}
	public pair(i: number): PairContext {
		return this.getTypedRuleContext(PairContext, i) as PairContext;
	}
    public get ruleIndex(): number {
    	return SpecParser.RULE_pairs;
	}
	public enterRule(listener: SpecListener): void {
	    if(listener.enterPairs) {
	 		listener.enterPairs(this);
		}
	}
	public exitRule(listener: SpecListener): void {
	    if(listener.exitPairs) {
	 		listener.exitPairs(this);
		}
	}
	// @Override
	public accept<Result>(visitor: SpecVisitor<Result>): Result {
		if (visitor.visitPairs) {
			return visitor.visitPairs(this);
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
