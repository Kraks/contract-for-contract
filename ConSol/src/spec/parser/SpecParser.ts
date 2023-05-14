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
	public static readonly TCONN = 13;
	public static readonly OP = 14;
	public static readonly QUOTE = 15;
	public static readonly INT = 16;
	public static readonly EOF = Token.EOF;
	public static readonly RULE_spec = 0;
	public static readonly RULE_vspec = 1;
	public static readonly RULE_tspec = 2;
	public static readonly RULE_sexpr = 3;
	public static readonly RULE_call = 4;
	public static readonly RULE_dict = 5;
	public static readonly RULE_pair = 6;
	public static readonly RULE_tuple = 7;
	public static readonly RULE_idents = 8;
	public static readonly literalNames: (string | null)[] = [ null, "'{'", 
                                                            "'requires'", 
                                                            "'}'", "'where'", 
                                                            "'ensures'", 
                                                            "'when'", "'('", 
                                                            "')'", "'returns'", 
                                                            "','", "':'" ];
	public static readonly symbolicNames: (string | null)[] = [ null, null, 
                                                             null, null, 
                                                             null, null, 
                                                             null, null, 
                                                             null, null, 
                                                             null, null, 
                                                             "IDENT", "TCONN", 
                                                             "OP", "QUOTE", 
                                                             "INT" ];
	// tslint:disable:no-trailing-whitespace
	public static readonly ruleNames: string[] = [
		"spec", "vspec", "tspec", "sexpr", "call", "dict", "pair", "tuple", "idents",
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
			switch ( this._interp.adaptivePredict(this._input, 0, this._ctx) ) {
			case 1:
				this.enterOuterAlt(localctx, 1);
				{
				this.state = 18;
				this.vspec();
				this.state = 19;
				this.match(SpecParser.EOF);
				}
				break;
			case 2:
				this.enterOuterAlt(localctx, 2);
				{
				this.state = 21;
				this.tspec();
				this.state = 22;
				this.match(SpecParser.EOF);
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
	public vspec(): VspecContext {
		let localctx: VspecContext = new VspecContext(this, this._ctx, this.state);
		this.enterRule(localctx, 2, SpecParser.RULE_vspec);
		let _la: number;
		try {
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 26;
			this.match(SpecParser.T__0);
			this.state = 27;
			this.call();
			this.state = 33;
			this._errHandler.sync(this);
			_la = this._input.LA(1);
			if (_la===2) {
				{
				this.state = 28;
				this.match(SpecParser.T__1);
				this.state = 29;
				this.match(SpecParser.T__0);
				this.state = 30;
				this.sexpr();
				this.state = 31;
				this.match(SpecParser.T__2);
				}
			}

			this.state = 42;
			this._errHandler.sync(this);
			switch ( this._interp.adaptivePredict(this._input, 3, this._ctx) ) {
			case 1:
				{
				this.state = 35;
				this.match(SpecParser.T__3);
				this.state = 39;
				this._errHandler.sync(this);
				_la = this._input.LA(1);
				while (_la===1) {
					{
					{
					this.state = 36;
					this.vspec();
					}
					}
					this.state = 41;
					this._errHandler.sync(this);
					_la = this._input.LA(1);
				}
				}
				break;
			}
			this.state = 49;
			this._errHandler.sync(this);
			_la = this._input.LA(1);
			if (_la===5) {
				{
				this.state = 44;
				this.match(SpecParser.T__4);
				this.state = 45;
				this.match(SpecParser.T__0);
				this.state = 46;
				this.sexpr();
				this.state = 47;
				this.match(SpecParser.T__2);
				}
			}

			this.state = 58;
			this._errHandler.sync(this);
			_la = this._input.LA(1);
			if (_la===4) {
				{
				this.state = 51;
				this.match(SpecParser.T__3);
				this.state = 55;
				this._errHandler.sync(this);
				_la = this._input.LA(1);
				while (_la===1) {
					{
					{
					this.state = 52;
					this.vspec();
					}
					}
					this.state = 57;
					this._errHandler.sync(this);
					_la = this._input.LA(1);
				}
				}
			}

			this.state = 60;
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
	public tspec(): TspecContext {
		let localctx: TspecContext = new TspecContext(this, this._ctx, this.state);
		this.enterRule(localctx, 4, SpecParser.RULE_tspec);
		let _la: number;
		try {
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 62;
			this.match(SpecParser.T__0);
			this.state = 63;
			this.call();
			this.state = 64;
			this.match(SpecParser.TCONN);
			this.state = 65;
			this.call();
			this.state = 71;
			this._errHandler.sync(this);
			_la = this._input.LA(1);
			if (_la===6) {
				{
				this.state = 66;
				this.match(SpecParser.T__5);
				this.state = 67;
				this.match(SpecParser.T__0);
				this.state = 68;
				this.sexpr();
				this.state = 69;
				this.match(SpecParser.T__2);
				}
			}

			this.state = 78;
			this._errHandler.sync(this);
			_la = this._input.LA(1);
			if (_la===5) {
				{
				this.state = 73;
				this.match(SpecParser.T__4);
				this.state = 74;
				this.match(SpecParser.T__0);
				this.state = 75;
				this.sexpr();
				this.state = 76;
				this.match(SpecParser.T__2);
				}
			}

			this.state = 80;
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
	public sexpr(): SexprContext {
		let localctx: SexprContext = new SexprContext(this, this._ctx, this.state);
		this.enterRule(localctx, 6, SpecParser.RULE_sexpr);
		let _la: number;
		try {
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 83;
			this._errHandler.sync(this);
			_la = this._input.LA(1);
			do {
				{
				{
				this.state = 82;
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
				this.state = 85;
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
	// @RuleVersion(0)
	public call(): CallContext {
		let localctx: CallContext = new CallContext(this, this._ctx, this.state);
		this.enterRule(localctx, 8, SpecParser.RULE_call);
		let _la: number;
		try {
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 87;
			this.match(SpecParser.IDENT);
			this.state = 89;
			this._errHandler.sync(this);
			_la = this._input.LA(1);
			if (_la===1) {
				{
				this.state = 88;
				this.dict();
				}
			}

			this.state = 91;
			this.match(SpecParser.T__6);
			this.state = 92;
			this.idents();
			this.state = 93;
			this.match(SpecParser.T__7);
			this.state = 96;
			this._errHandler.sync(this);
			_la = this._input.LA(1);
			if (_la===9) {
				{
				this.state = 94;
				this.match(SpecParser.T__8);
				this.state = 95;
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
	public dict(): DictContext {
		let localctx: DictContext = new DictContext(this, this._ctx, this.state);
		this.enterRule(localctx, 10, SpecParser.RULE_dict);
		let _la: number;
		try {
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 98;
			this.match(SpecParser.T__0);
			this.state = 99;
			this.pair();
			this.state = 104;
			this._errHandler.sync(this);
			_la = this._input.LA(1);
			while (_la===10) {
				{
				{
				this.state = 100;
				this.match(SpecParser.T__9);
				this.state = 101;
				this.pair();
				}
				}
				this.state = 106;
				this._errHandler.sync(this);
				_la = this._input.LA(1);
			}
			this.state = 107;
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
			this.state = 109;
			this.match(SpecParser.IDENT);
			this.state = 110;
			this.match(SpecParser.T__10);
			this.state = 111;
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
	public tuple(): TupleContext {
		let localctx: TupleContext = new TupleContext(this, this._ctx, this.state);
		this.enterRule(localctx, 14, SpecParser.RULE_tuple);
		try {
			this.state = 118;
			this._errHandler.sync(this);
			switch (this._input.LA(1)) {
			case 12:
				this.enterOuterAlt(localctx, 1);
				{
				this.state = 113;
				this.match(SpecParser.IDENT);
				}
				break;
			case 7:
				this.enterOuterAlt(localctx, 2);
				{
				this.state = 114;
				this.match(SpecParser.T__6);
				this.state = 115;
				this.idents();
				this.state = 116;
				this.match(SpecParser.T__7);
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
		this.enterRule(localctx, 16, SpecParser.RULE_idents);
		let _la: number;
		try {
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 128;
			this._errHandler.sync(this);
			_la = this._input.LA(1);
			if (_la===12) {
				{
				this.state = 120;
				this.match(SpecParser.IDENT);
				this.state = 125;
				this._errHandler.sync(this);
				_la = this._input.LA(1);
				while (_la===10) {
					{
					{
					this.state = 121;
					this.match(SpecParser.T__9);
					this.state = 122;
					this.match(SpecParser.IDENT);
					}
					}
					this.state = 127;
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

	public static readonly _serializedATN: number[] = [4,1,16,131,2,0,7,0,2,
	1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,6,2,7,7,7,2,8,7,8,1,0,1,0,1,
	0,1,0,1,0,1,0,3,0,25,8,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,34,8,1,1,1,1,1,
	5,1,38,8,1,10,1,12,1,41,9,1,3,1,43,8,1,1,1,1,1,1,1,1,1,1,1,3,1,50,8,1,1,
	1,1,1,5,1,54,8,1,10,1,12,1,57,9,1,3,1,59,8,1,1,1,1,1,1,2,1,2,1,2,1,2,1,
	2,1,2,1,2,1,2,1,2,3,2,72,8,2,1,2,1,2,1,2,1,2,1,2,3,2,79,8,2,1,2,1,2,1,3,
	4,3,84,8,3,11,3,12,3,85,1,4,1,4,3,4,90,8,4,1,4,1,4,1,4,1,4,1,4,3,4,97,8,
	4,1,5,1,5,1,5,1,5,5,5,103,8,5,10,5,12,5,106,9,5,1,5,1,5,1,6,1,6,1,6,1,6,
	1,7,1,7,1,7,1,7,1,7,3,7,119,8,7,1,8,1,8,1,8,5,8,124,8,8,10,8,12,8,127,9,
	8,3,8,129,8,8,1,8,0,0,9,0,2,4,6,8,10,12,14,16,0,1,2,0,1,1,3,3,137,0,24,
	1,0,0,0,2,26,1,0,0,0,4,62,1,0,0,0,6,83,1,0,0,0,8,87,1,0,0,0,10,98,1,0,0,
	0,12,109,1,0,0,0,14,118,1,0,0,0,16,128,1,0,0,0,18,19,3,2,1,0,19,20,5,0,
	0,1,20,25,1,0,0,0,21,22,3,4,2,0,22,23,5,0,0,1,23,25,1,0,0,0,24,18,1,0,0,
	0,24,21,1,0,0,0,25,1,1,0,0,0,26,27,5,1,0,0,27,33,3,8,4,0,28,29,5,2,0,0,
	29,30,5,1,0,0,30,31,3,6,3,0,31,32,5,3,0,0,32,34,1,0,0,0,33,28,1,0,0,0,33,
	34,1,0,0,0,34,42,1,0,0,0,35,39,5,4,0,0,36,38,3,2,1,0,37,36,1,0,0,0,38,41,
	1,0,0,0,39,37,1,0,0,0,39,40,1,0,0,0,40,43,1,0,0,0,41,39,1,0,0,0,42,35,1,
	0,0,0,42,43,1,0,0,0,43,49,1,0,0,0,44,45,5,5,0,0,45,46,5,1,0,0,46,47,3,6,
	3,0,47,48,5,3,0,0,48,50,1,0,0,0,49,44,1,0,0,0,49,50,1,0,0,0,50,58,1,0,0,
	0,51,55,5,4,0,0,52,54,3,2,1,0,53,52,1,0,0,0,54,57,1,0,0,0,55,53,1,0,0,0,
	55,56,1,0,0,0,56,59,1,0,0,0,57,55,1,0,0,0,58,51,1,0,0,0,58,59,1,0,0,0,59,
	60,1,0,0,0,60,61,5,3,0,0,61,3,1,0,0,0,62,63,5,1,0,0,63,64,3,8,4,0,64,65,
	5,13,0,0,65,71,3,8,4,0,66,67,5,6,0,0,67,68,5,1,0,0,68,69,3,6,3,0,69,70,
	5,3,0,0,70,72,1,0,0,0,71,66,1,0,0,0,71,72,1,0,0,0,72,78,1,0,0,0,73,74,5,
	5,0,0,74,75,5,1,0,0,75,76,3,6,3,0,76,77,5,3,0,0,77,79,1,0,0,0,78,73,1,0,
	0,0,78,79,1,0,0,0,79,80,1,0,0,0,80,81,5,3,0,0,81,5,1,0,0,0,82,84,8,0,0,
	0,83,82,1,0,0,0,84,85,1,0,0,0,85,83,1,0,0,0,85,86,1,0,0,0,86,7,1,0,0,0,
	87,89,5,12,0,0,88,90,3,10,5,0,89,88,1,0,0,0,89,90,1,0,0,0,90,91,1,0,0,0,
	91,92,5,7,0,0,92,93,3,16,8,0,93,96,5,8,0,0,94,95,5,9,0,0,95,97,3,14,7,0,
	96,94,1,0,0,0,96,97,1,0,0,0,97,9,1,0,0,0,98,99,5,1,0,0,99,104,3,12,6,0,
	100,101,5,10,0,0,101,103,3,12,6,0,102,100,1,0,0,0,103,106,1,0,0,0,104,102,
	1,0,0,0,104,105,1,0,0,0,105,107,1,0,0,0,106,104,1,0,0,0,107,108,5,3,0,0,
	108,11,1,0,0,0,109,110,5,12,0,0,110,111,5,11,0,0,111,112,5,12,0,0,112,13,
	1,0,0,0,113,119,5,12,0,0,114,115,5,7,0,0,115,116,3,16,8,0,116,117,5,8,0,
	0,117,119,1,0,0,0,118,113,1,0,0,0,118,114,1,0,0,0,119,15,1,0,0,0,120,125,
	5,12,0,0,121,122,5,10,0,0,122,124,5,12,0,0,123,121,1,0,0,0,124,127,1,0,
	0,0,125,123,1,0,0,0,125,126,1,0,0,0,126,129,1,0,0,0,127,125,1,0,0,0,128,
	120,1,0,0,0,128,129,1,0,0,0,129,17,1,0,0,0,16,24,33,39,42,49,55,58,71,78,
	85,89,96,104,118,125,128];

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
	public call(): CallContext {
		return this.getTypedRuleContext(CallContext, 0) as CallContext;
	}
	public sexpr_list(): SexprContext[] {
		return this.getTypedRuleContexts(SexprContext) as SexprContext[];
	}
	public sexpr(i: number): SexprContext {
		return this.getTypedRuleContext(SexprContext, i) as SexprContext;
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
	public call_list(): CallContext[] {
		return this.getTypedRuleContexts(CallContext) as CallContext[];
	}
	public call(i: number): CallContext {
		return this.getTypedRuleContext(CallContext, i) as CallContext;
	}
	public TCONN(): TerminalNode {
		return this.getToken(SpecParser.TCONN, 0);
	}
	public sexpr_list(): SexprContext[] {
		return this.getTypedRuleContexts(SexprContext) as SexprContext[];
	}
	public sexpr(i: number): SexprContext {
		return this.getTypedRuleContext(SexprContext, i) as SexprContext;
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


export class CallContext extends ParserRuleContext {
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
	public dict(): DictContext {
		return this.getTypedRuleContext(DictContext, 0) as DictContext;
	}
	public tuple(): TupleContext {
		return this.getTypedRuleContext(TupleContext, 0) as TupleContext;
	}
    public get ruleIndex(): number {
    	return SpecParser.RULE_call;
	}
	public enterRule(listener: SpecListener): void {
	    if(listener.enterCall) {
	 		listener.enterCall(this);
		}
	}
	public exitRule(listener: SpecListener): void {
	    if(listener.exitCall) {
	 		listener.exitCall(this);
		}
	}
	// @Override
	public accept<Result>(visitor: SpecVisitor<Result>): Result {
		if (visitor.visitCall) {
			return visitor.visitCall(this);
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
