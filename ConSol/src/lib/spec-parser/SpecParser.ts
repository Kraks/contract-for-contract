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
	public static readonly IDENT = 11;
	public static readonly TCONN = 12;
	public static readonly OP = 13;
	public static readonly QUOTE = 14;
	public static readonly INT = 15;
	public static readonly WS = 16;
	public static readonly EOF = Token.EOF;
	public static readonly RULE_spec = 0;
	public static readonly RULE_vspec = 1;
	public static readonly RULE_tspec = 2;
	public static readonly RULE_tuple = 3;
	public static readonly RULE_idents = 4;
	public static readonly RULE_dict = 5;
	public static readonly RULE_pair = 6;
	public static readonly RULE_func = 7;
	public static readonly RULE_sexpr = 8;
	public static readonly literalNames: (string | null)[] = [ null, "'{'", 
                                                            "'|'", "'}'", 
                                                            "'->'", "'/\\'", 
                                                            "'('", "')'", 
                                                            "','", "':'", 
                                                            "'returns'" ];
	public static readonly symbolicNames: (string | null)[] = [ null, null, 
                                                             null, null, 
                                                             null, null, 
                                                             null, null, 
                                                             null, null, 
                                                             null, "IDENT", 
                                                             "TCONN", "OP", 
                                                             "QUOTE", "INT", 
                                                             "WS" ];
	// tslint:disable:no-trailing-whitespace
	public static readonly ruleNames: string[] = [
		"spec", "vspec", "tspec", "tuple", "idents", "dict", "pair", "func", "sexpr",
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
			this.state = 24;
			this._errHandler.sync(this);
			switch (this._input.LA(1)) {
			case 1:
				this.enterOuterAlt(localctx, 1);
				{
				this.state = 18;
				this.vspec(0);
				this.state = 19;
				this.match(SpecParser.EOF);
				}
				break;
			case 11:
				this.enterOuterAlt(localctx, 2);
				{
				this.state = 21;
				this.tspec();
				this.state = 22;
				this.match(SpecParser.EOF);
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

	public vspec(): VspecContext;
	public vspec(_p: number): VspecContext;
	// @RuleVersion(0)
	public vspec(_p?: number): VspecContext {
		if (_p === undefined) {
			_p = 0;
		}

		let _parentctx: ParserRuleContext = this._ctx;
		let _parentState: number = this.state;
		let localctx: VspecContext = new VspecContext(this, this._ctx, _parentState);
		let _prevctx: VspecContext = localctx;
		let _startState: number = 2;
		this.enterRecursionRule(localctx, 2, SpecParser.RULE_vspec, _p);
		let _la: number;
		try {
			let _alt: number;
			this.enterOuterAlt(localctx, 1);
			{
			{
			this.state = 27;
			this.match(SpecParser.T__0);
			this.state = 29;
			this._errHandler.sync(this);
			_la = this._input.LA(1);
			if (_la===1) {
				{
				this.state = 28;
				this.dict();
				}
			}

			this.state = 31;
			this.tuple();
			this.state = 32;
			this.match(SpecParser.T__1);
			this.state = 33;
			this.sexpr();
			this.state = 34;
			this.match(SpecParser.T__2);
			}
			this._ctx.stop = this._input.LT(-1);
			this.state = 41;
			this._errHandler.sync(this);
			_alt = this._interp.adaptivePredict(this._input, 2, this._ctx);
			while (_alt !== 2 && _alt !== ATN.INVALID_ALT_NUMBER) {
				if (_alt === 1) {
					if (this._parseListeners != null) {
						this.triggerExitRuleEvent();
					}
					_prevctx = localctx;
					{
					{
					localctx = new VspecContext(this, _parentctx, _parentState);
					this.pushNewRecursionContext(localctx, _startState, SpecParser.RULE_vspec);
					this.state = 36;
					if (!(this.precpred(this._ctx, 1))) {
						throw this.createFailedPredicateException("this.precpred(this._ctx, 1)");
					}
					this.state = 37;
					this.match(SpecParser.T__3);
					this.state = 38;
					this.vspec(2);
					}
					}
				}
				this.state = 43;
				this._errHandler.sync(this);
				_alt = this._interp.adaptivePredict(this._input, 2, this._ctx);
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
	// @RuleVersion(0)
	public tspec(): TspecContext {
		let localctx: TspecContext = new TspecContext(this, this._ctx, this.state);
		this.enterRule(localctx, 4, SpecParser.RULE_tspec);
		let _la: number;
		try {
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 44;
			this.func();
			this.state = 45;
			this.match(SpecParser.TCONN);
			this.state = 46;
			this.func();
			this.state = 49;
			this._errHandler.sync(this);
			_la = this._input.LA(1);
			if (_la===5) {
				{
				this.state = 47;
				this.match(SpecParser.T__4);
				this.state = 48;
				this.sexpr();
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
	public tuple(): TupleContext {
		let localctx: TupleContext = new TupleContext(this, this._ctx, this.state);
		this.enterRule(localctx, 6, SpecParser.RULE_tuple);
		try {
			this.state = 56;
			this._errHandler.sync(this);
			switch (this._input.LA(1)) {
			case 11:
				this.enterOuterAlt(localctx, 1);
				{
				this.state = 51;
				this.match(SpecParser.IDENT);
				}
				break;
			case 6:
				this.enterOuterAlt(localctx, 2);
				{
				this.state = 52;
				this.match(SpecParser.T__5);
				this.state = 53;
				this.idents();
				this.state = 54;
				this.match(SpecParser.T__6);
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
	public idents(): IdentsContext {
		let localctx: IdentsContext = new IdentsContext(this, this._ctx, this.state);
		this.enterRule(localctx, 8, SpecParser.RULE_idents);
		let _la: number;
		try {
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 66;
			this._errHandler.sync(this);
			_la = this._input.LA(1);
			if (_la===11) {
				{
				this.state = 58;
				this.match(SpecParser.IDENT);
				this.state = 63;
				this._errHandler.sync(this);
				_la = this._input.LA(1);
				while (_la===8) {
					{
					{
					this.state = 59;
					this.match(SpecParser.T__7);
					this.state = 60;
					this.match(SpecParser.IDENT);
					}
					}
					this.state = 65;
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
	public dict(): DictContext {
		let localctx: DictContext = new DictContext(this, this._ctx, this.state);
		this.enterRule(localctx, 10, SpecParser.RULE_dict);
		let _la: number;
		try {
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 68;
			this.match(SpecParser.T__0);
			this.state = 77;
			this._errHandler.sync(this);
			_la = this._input.LA(1);
			if (_la===11) {
				{
				this.state = 69;
				this.pair();
				this.state = 74;
				this._errHandler.sync(this);
				_la = this._input.LA(1);
				while (_la===8) {
					{
					{
					this.state = 70;
					this.match(SpecParser.T__7);
					this.state = 71;
					this.pair();
					}
					}
					this.state = 76;
					this._errHandler.sync(this);
					_la = this._input.LA(1);
				}
				}
			}

			this.state = 79;
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
	public pair(): PairContext {
		let localctx: PairContext = new PairContext(this, this._ctx, this.state);
		this.enterRule(localctx, 12, SpecParser.RULE_pair);
		try {
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 81;
			this.match(SpecParser.IDENT);
			this.state = 82;
			this.match(SpecParser.T__8);
			this.state = 83;
			this.match(SpecParser.IDENT);
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
	public func(): FuncContext {
		let localctx: FuncContext = new FuncContext(this, this._ctx, this.state);
		this.enterRule(localctx, 14, SpecParser.RULE_func);
		let _la: number;
		try {
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 85;
			this.match(SpecParser.IDENT);
			this.state = 86;
			this.match(SpecParser.T__5);
			this.state = 87;
			this.idents();
			this.state = 88;
			this.match(SpecParser.T__6);
			this.state = 91;
			this._errHandler.sync(this);
			_la = this._input.LA(1);
			if (_la===10) {
				{
				this.state = 89;
				this.match(SpecParser.T__9);
				this.state = 90;
				this.tuple();
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
	public sexpr(): SexprContext {
		let localctx: SexprContext = new SexprContext(this, this._ctx, this.state);
		this.enterRule(localctx, 16, SpecParser.RULE_sexpr);
		let _la: number;
		try {
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 94;
			this._errHandler.sync(this);
			_la = this._input.LA(1);
			do {
				{
				{
				this.state = 93;
				_la = this._input.LA(1);
				if(_la<=0 || _la===1 || _la===3) {
				this._errHandler.recoverInline(this);
				}
				else {
					this._errHandler.reportMatch(this);
				    this.consume();
				}
				}
				}
				this.state = 96;
				this._errHandler.sync(this);
				_la = this._input.LA(1);
			} while ((((_la) & ~0x1F) === 0 && ((1 << _la) & 131060) !== 0));
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

	public sempred(localctx: RuleContext, ruleIndex: number, predIndex: number): boolean {
		switch (ruleIndex) {
		case 1:
			return this.vspec_sempred(localctx as VspecContext, predIndex);
		}
		return true;
	}
	private vspec_sempred(localctx: VspecContext, predIndex: number): boolean {
		switch (predIndex) {
		case 0:
			return this.precpred(this._ctx, 1);
		}
		return true;
	}

	public static readonly _serializedATN: number[] = [4,1,16,99,2,0,7,0,2,
	1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,6,2,7,7,7,2,8,7,8,1,0,1,0,1,
	0,1,0,1,0,1,0,3,0,25,8,0,1,1,1,1,1,1,3,1,30,8,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,5,1,40,8,1,10,1,12,1,43,9,1,1,2,1,2,1,2,1,2,1,2,3,2,50,8,2,1,3,
	1,3,1,3,1,3,1,3,3,3,57,8,3,1,4,1,4,1,4,5,4,62,8,4,10,4,12,4,65,9,4,3,4,
	67,8,4,1,5,1,5,1,5,1,5,5,5,73,8,5,10,5,12,5,76,9,5,3,5,78,8,5,1,5,1,5,1,
	6,1,6,1,6,1,6,1,7,1,7,1,7,1,7,1,7,1,7,3,7,92,8,7,1,8,4,8,95,8,8,11,8,12,
	8,96,1,8,0,1,2,9,0,2,4,6,8,10,12,14,16,0,1,2,0,1,1,3,3,100,0,24,1,0,0,0,
	2,26,1,0,0,0,4,44,1,0,0,0,6,56,1,0,0,0,8,66,1,0,0,0,10,68,1,0,0,0,12,81,
	1,0,0,0,14,85,1,0,0,0,16,94,1,0,0,0,18,19,3,2,1,0,19,20,5,0,0,1,20,25,1,
	0,0,0,21,22,3,4,2,0,22,23,5,0,0,1,23,25,1,0,0,0,24,18,1,0,0,0,24,21,1,0,
	0,0,25,1,1,0,0,0,26,27,6,1,-1,0,27,29,5,1,0,0,28,30,3,10,5,0,29,28,1,0,
	0,0,29,30,1,0,0,0,30,31,1,0,0,0,31,32,3,6,3,0,32,33,5,2,0,0,33,34,3,16,
	8,0,34,35,5,3,0,0,35,41,1,0,0,0,36,37,10,1,0,0,37,38,5,4,0,0,38,40,3,2,
	1,2,39,36,1,0,0,0,40,43,1,0,0,0,41,39,1,0,0,0,41,42,1,0,0,0,42,3,1,0,0,
	0,43,41,1,0,0,0,44,45,3,14,7,0,45,46,5,12,0,0,46,49,3,14,7,0,47,48,5,5,
	0,0,48,50,3,16,8,0,49,47,1,0,0,0,49,50,1,0,0,0,50,5,1,0,0,0,51,57,5,11,
	0,0,52,53,5,6,0,0,53,54,3,8,4,0,54,55,5,7,0,0,55,57,1,0,0,0,56,51,1,0,0,
	0,56,52,1,0,0,0,57,7,1,0,0,0,58,63,5,11,0,0,59,60,5,8,0,0,60,62,5,11,0,
	0,61,59,1,0,0,0,62,65,1,0,0,0,63,61,1,0,0,0,63,64,1,0,0,0,64,67,1,0,0,0,
	65,63,1,0,0,0,66,58,1,0,0,0,66,67,1,0,0,0,67,9,1,0,0,0,68,77,5,1,0,0,69,
	74,3,12,6,0,70,71,5,8,0,0,71,73,3,12,6,0,72,70,1,0,0,0,73,76,1,0,0,0,74,
	72,1,0,0,0,74,75,1,0,0,0,75,78,1,0,0,0,76,74,1,0,0,0,77,69,1,0,0,0,77,78,
	1,0,0,0,78,79,1,0,0,0,79,80,5,3,0,0,80,11,1,0,0,0,81,82,5,11,0,0,82,83,
	5,9,0,0,83,84,5,11,0,0,84,13,1,0,0,0,85,86,5,11,0,0,86,87,5,6,0,0,87,88,
	3,8,4,0,88,91,5,7,0,0,89,90,5,10,0,0,90,92,3,6,3,0,91,89,1,0,0,0,91,92,
	1,0,0,0,92,15,1,0,0,0,93,95,8,0,0,0,94,93,1,0,0,0,95,96,1,0,0,0,96,94,1,
	0,0,0,96,97,1,0,0,0,97,17,1,0,0,0,11,24,29,41,49,56,63,66,74,77,91,96];

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
	public EOF(): TerminalNode {
		return this.getToken(SpecParser.EOF, 0);
	}
	public tspec(): TspecContext {
		return this.getTypedRuleContext(TspecContext, 0) as TspecContext;
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
	public tuple(): TupleContext {
		return this.getTypedRuleContext(TupleContext, 0) as TupleContext;
	}
	public sexpr(): SexprContext {
		return this.getTypedRuleContext(SexprContext, 0) as SexprContext;
	}
	public dict(): DictContext {
		return this.getTypedRuleContext(DictContext, 0) as DictContext;
	}
	public vspec_list(): VspecContext[] {
		return this.getTypedRuleContexts(VspecContext) as VspecContext[];
	}
	public vspec(i: number): VspecContext {
		return this.getTypedRuleContext(VspecContext, i) as VspecContext;
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


export class TspecContext extends ParserRuleContext {
	constructor(parser?: SpecParser, parent?: ParserRuleContext, invokingState?: number) {
		super(parent, invokingState);
    	this.parser = parser;
	}
	public func_list(): FuncContext[] {
		return this.getTypedRuleContexts(FuncContext) as FuncContext[];
	}
	public func(i: number): FuncContext {
		return this.getTypedRuleContext(FuncContext, i) as FuncContext;
	}
	public TCONN(): TerminalNode {
		return this.getToken(SpecParser.TCONN, 0);
	}
	public sexpr(): SexprContext {
		return this.getTypedRuleContext(SexprContext, 0) as SexprContext;
	}
    public get ruleIndex(): number {
    	return SpecParser.RULE_tspec;
	}
	public enterRule(listener: SpecListener): void {
	    if(listener.enterTspec) {
	 		listener.enterTspec(this);
		}
	}
	public exitRule(listener: SpecListener): void {
	    if(listener.exitTspec) {
	 		listener.exitTspec(this);
		}
	}
	// @Override
	public accept<Result>(visitor: SpecVisitor<Result>): Result {
		if (visitor.visitTspec) {
			return visitor.visitTspec(this);
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
	public IDENT(): TerminalNode {
		return this.getToken(SpecParser.IDENT, 0);
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


export class DictContext extends ParserRuleContext {
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


export class PairContext extends ParserRuleContext {
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


export class FuncContext extends ParserRuleContext {
	constructor(parser?: SpecParser, parent?: ParserRuleContext, invokingState?: number) {
		super(parent, invokingState);
    	this.parser = parser;
	}
	public IDENT(): TerminalNode {
		return this.getToken(SpecParser.IDENT, 0);
	}
	public idents(): IdentsContext {
		return this.getTypedRuleContext(IdentsContext, 0) as IdentsContext;
	}
	public tuple(): TupleContext {
		return this.getTypedRuleContext(TupleContext, 0) as TupleContext;
	}
    public get ruleIndex(): number {
    	return SpecParser.RULE_func;
	}
	public enterRule(listener: SpecListener): void {
	    if(listener.enterFunc) {
	 		listener.enterFunc(this);
		}
	}
	public exitRule(listener: SpecListener): void {
	    if(listener.exitFunc) {
	 		listener.exitFunc(this);
		}
	}
	// @Override
	public accept<Result>(visitor: SpecVisitor<Result>): Result {
		if (visitor.visitFunc) {
			return visitor.visitFunc(this);
		} else {
			return visitor.visitChildren(this);
		}
	}
}


export class SexprContext extends ParserRuleContext {
	constructor(parser?: SpecParser, parent?: ParserRuleContext, invokingState?: number) {
		super(parent, invokingState);
    	this.parser = parser;
	}
    public get ruleIndex(): number {
    	return SpecParser.RULE_sexpr;
	}
	public enterRule(listener: SpecListener): void {
	    if(listener.enterSexpr) {
	 		listener.enterSexpr(this);
		}
	}
	public exitRule(listener: SpecListener): void {
	    if(listener.exitSexpr) {
	 		listener.exitSexpr(this);
		}
	}
	// @Override
	public accept<Result>(visitor: SpecVisitor<Result>): Result {
		if (visitor.visitSexpr) {
			return visitor.visitSexpr(this);
		} else {
			return visitor.visitChildren(this);
		}
	}
}
