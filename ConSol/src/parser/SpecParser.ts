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
	public static readonly IDENT = 8;
	public static readonly OP = 9;
	public static readonly QUOTE = 10;
	public static readonly INT = 11;
	public static readonly WS = 12;
	public static readonly EOF = Token.EOF;
	public static readonly RULE_spec = 0;
	public static readonly RULE_vspec = 1;
	public static readonly RULE_args = 2;
	public static readonly RULE_idents = 3;
	public static readonly RULE_dict = 4;
	public static readonly RULE_pair = 5;
	public static readonly RULE_sexpr = 6;
	public static readonly literalNames: (string | null)[] = [ null, "'{'", 
                                                            "'|'", "'}'", 
                                                            "'('", "')'", 
                                                            "','", "':'" ];
	public static readonly symbolicNames: (string | null)[] = [ null, null, 
                                                             null, null, 
                                                             null, null, 
                                                             null, null, 
                                                             "IDENT", "OP", 
                                                             "QUOTE", "INT", 
                                                             "WS" ];
	// tslint:disable:no-trailing-whitespace
	public static readonly ruleNames: string[] = [
		"spec", "vspec", "args", "idents", "dict", "pair", "sexpr",
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
			this.state = 14;
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
			this.state = 16;
			this.match(SpecParser.T__0);
			this.state = 18;
			this._errHandler.sync(this);
			_la = this._input.LA(1);
			if (_la===1) {
				{
				this.state = 17;
				this.dict();
				}
			}

			this.state = 20;
			this.args();
			this.state = 21;
			this.match(SpecParser.T__1);
			this.state = 22;
			this.sexpr();
			this.state = 23;
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
			this.state = 30;
			this._errHandler.sync(this);
			switch (this._input.LA(1)) {
			case 8:
				this.enterOuterAlt(localctx, 1);
				{
				this.state = 25;
				this.match(SpecParser.IDENT);
				}
				break;
			case 4:
				this.enterOuterAlt(localctx, 2);
				{
				this.state = 26;
				this.match(SpecParser.T__3);
				this.state = 27;
				this.idents();
				this.state = 28;
				this.match(SpecParser.T__4);
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
		this.enterRule(localctx, 6, SpecParser.RULE_idents);
		let _la: number;
		try {
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 40;
			this._errHandler.sync(this);
			_la = this._input.LA(1);
			if (_la===8) {
				{
				this.state = 32;
				this.match(SpecParser.IDENT);
				this.state = 37;
				this._errHandler.sync(this);
				_la = this._input.LA(1);
				while (_la===6) {
					{
					{
					this.state = 33;
					this.match(SpecParser.T__5);
					this.state = 34;
					this.match(SpecParser.IDENT);
					}
					}
					this.state = 39;
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
		this.enterRule(localctx, 8, SpecParser.RULE_dict);
		let _la: number;
		try {
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 42;
			this.match(SpecParser.T__0);
			this.state = 51;
			this._errHandler.sync(this);
			_la = this._input.LA(1);
			if (_la===8) {
				{
				this.state = 43;
				this.pair();
				this.state = 48;
				this._errHandler.sync(this);
				_la = this._input.LA(1);
				while (_la===6) {
					{
					{
					this.state = 44;
					this.match(SpecParser.T__5);
					this.state = 45;
					this.pair();
					}
					}
					this.state = 50;
					this._errHandler.sync(this);
					_la = this._input.LA(1);
				}
				}
			}

			this.state = 53;
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
		this.enterRule(localctx, 10, SpecParser.RULE_pair);
		try {
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 55;
			this.match(SpecParser.IDENT);
			this.state = 56;
			this.match(SpecParser.T__6);
			this.state = 57;
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
	public sexpr(): SexprContext {
		let localctx: SexprContext = new SexprContext(this, this._ctx, this.state);
		this.enterRule(localctx, 12, SpecParser.RULE_sexpr);
		let _la: number;
		try {
			this.enterOuterAlt(localctx, 1);
			{
			this.state = 60;
			this._errHandler.sync(this);
			_la = this._input.LA(1);
			do {
				{
				{
				this.state = 59;
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
				this.state = 62;
				this._errHandler.sync(this);
				_la = this._input.LA(1);
			} while ((((_la) & ~0x1F) === 0 && ((1 << _la) & 8180) !== 0));
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

	public static readonly _serializedATN: number[] = [4,1,12,65,2,0,7,0,2,
	1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,6,1,0,1,0,1,1,1,1,3,1,19,8,
	1,1,1,1,1,1,1,1,1,1,1,1,2,1,2,1,2,1,2,1,2,3,2,31,8,2,1,3,1,3,1,3,5,3,36,
	8,3,10,3,12,3,39,9,3,3,3,41,8,3,1,4,1,4,1,4,1,4,5,4,47,8,4,10,4,12,4,50,
	9,4,3,4,52,8,4,1,4,1,4,1,5,1,5,1,5,1,5,1,6,4,6,61,8,6,11,6,12,6,62,1,6,
	0,0,7,0,2,4,6,8,10,12,0,1,2,0,1,1,3,3,64,0,14,1,0,0,0,2,16,1,0,0,0,4,30,
	1,0,0,0,6,40,1,0,0,0,8,42,1,0,0,0,10,55,1,0,0,0,12,60,1,0,0,0,14,15,3,2,
	1,0,15,1,1,0,0,0,16,18,5,1,0,0,17,19,3,8,4,0,18,17,1,0,0,0,18,19,1,0,0,
	0,19,20,1,0,0,0,20,21,3,4,2,0,21,22,5,2,0,0,22,23,3,12,6,0,23,24,5,3,0,
	0,24,3,1,0,0,0,25,31,5,8,0,0,26,27,5,4,0,0,27,28,3,6,3,0,28,29,5,5,0,0,
	29,31,1,0,0,0,30,25,1,0,0,0,30,26,1,0,0,0,31,5,1,0,0,0,32,37,5,8,0,0,33,
	34,5,6,0,0,34,36,5,8,0,0,35,33,1,0,0,0,36,39,1,0,0,0,37,35,1,0,0,0,37,38,
	1,0,0,0,38,41,1,0,0,0,39,37,1,0,0,0,40,32,1,0,0,0,40,41,1,0,0,0,41,7,1,
	0,0,0,42,51,5,1,0,0,43,48,3,10,5,0,44,45,5,6,0,0,45,47,3,10,5,0,46,44,1,
	0,0,0,47,50,1,0,0,0,48,46,1,0,0,0,48,49,1,0,0,0,49,52,1,0,0,0,50,48,1,0,
	0,0,51,43,1,0,0,0,51,52,1,0,0,0,52,53,1,0,0,0,53,54,5,3,0,0,54,9,1,0,0,
	0,55,56,5,8,0,0,56,57,5,7,0,0,57,58,5,8,0,0,58,11,1,0,0,0,59,61,8,0,0,0,
	60,59,1,0,0,0,61,62,1,0,0,0,62,60,1,0,0,0,62,63,1,0,0,0,63,13,1,0,0,0,7,
	18,30,37,40,48,51,62];

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
	public sexpr(): SexprContext {
		return this.getTypedRuleContext(SexprContext, 0) as SexprContext;
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
	public idents(): IdentsContext {
		return this.getTypedRuleContext(IdentsContext, 0) as IdentsContext;
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
