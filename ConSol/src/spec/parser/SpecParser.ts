// @ts-nocheck
// Generated from Spec.g4 by ANTLR 4.12.0
// noinspection ES6UnusedImports,JSUnusedGlobalSymbols,JSUnusedLocalSymbols

import {
  ATN,
  ATNDeserializer,
  DecisionState,
  DFA,
  FailedPredicateException,
  RecognitionException,
  NoViableAltException,
  BailErrorStrategy,
  Parser,
  ParserATNSimulator,
  RuleContext,
  ParserRuleContext,
  PredictionMode,
  PredictionContextCache,
  TerminalNode,
  RuleNode,
  Token,
  TokenStream,
  Interval,
  IntervalSet,
} from 'antlr4';
import SpecListener from './SpecListener.js';
import SpecVisitor from './SpecVisitor.js';

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
  public static readonly T__11 = 12;
  public static readonly IDENT = 13;
  public static readonly TCONN = 14;
  public static readonly OP = 15;
  public static readonly QUOTE = 16;
  public static readonly INT = 17;
  public static readonly WS = 18;
  public static readonly EOF = Token.EOF;
  public static readonly RULE_spec = 0;
  public static readonly RULE_vspec = 1;
  public static readonly RULE_tspec = 2;
  public static readonly RULE_sexpr = 3;
  public static readonly RULE_call = 4;
  public static readonly RULE_fname = 5;
  public static readonly RULE_dict = 6;
  public static readonly RULE_pair = 7;
  public static readonly RULE_tuple = 8;
  public static readonly RULE_idents = 9;
  public static readonly literalNames: (string | null)[] = [
    null,
    "'{'",
    "'requires'",
    "'}'",
    "'ensures'",
    "'where'",
    "'when'",
    "'('",
    "')'",
    "'returns'",
    "'.'",
    "','",
    "':'",
  ];
  public static readonly symbolicNames: (string | null)[] = [
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    'IDENT',
    'TCONN',
    'OP',
    'QUOTE',
    'INT',
    'WS',
  ];
  // tslint:disable:no-trailing-whitespace
  public static readonly ruleNames: string[] = [
    'spec',
    'vspec',
    'tspec',
    'sexpr',
    'call',
    'fname',
    'dict',
    'pair',
    'tuple',
    'idents',
  ];
  public get grammarFileName(): string {
    return 'Spec.g4';
  }
  public get literalNames(): (string | null)[] {
    return SpecParser.literalNames;
  }
  public get symbolicNames(): (string | null)[] {
    return SpecParser.symbolicNames;
  }
  public get ruleNames(): string[] {
    return SpecParser.ruleNames;
  }
  public get serializedATN(): number[] {
    return SpecParser._serializedATN;
  }

  protected createFailedPredicateException(
    predicate?: string,
    message?: string,
  ): FailedPredicateException {
    return new FailedPredicateException(this, predicate, message);
  }

  constructor(input: TokenStream) {
    super(input);
    this._interp = new ParserATNSimulator(
      this,
      SpecParser._ATN,
      SpecParser.DecisionsToDFA,
      new PredictionContextCache(),
    );
  }
  // @RuleVersion(0)
  public spec(): SpecContext {
    let localctx: SpecContext = new SpecContext(this, this._ctx, this.state);
    this.enterRule(localctx, 0, SpecParser.RULE_spec);
    try {
      this.state = 26;
      this._errHandler.sync(this);
      switch (this._interp.adaptivePredict(this._input, 0, this._ctx)) {
        case 1:
          this.enterOuterAlt(localctx, 1);
          {
            this.state = 20;
            this.vspec();
            this.state = 21;
            this.match(SpecParser.EOF);
          }
          break;
        case 2:
          this.enterOuterAlt(localctx, 2);
          {
            this.state = 23;
            this.tspec();
            this.state = 24;
            this.match(SpecParser.EOF);
          }
          break;
      }
    } catch (re) {
      if (re instanceof RecognitionException) {
        localctx.exception = re;
        this._errHandler.reportError(this, re);
        this._errHandler.recover(this, re);
      } else {
        throw re;
      }
    } finally {
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
        this.state = 28;
        this.match(SpecParser.T__0);
        this.state = 29;
        this.call();
        this.state = 35;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        if (_la === 2) {
          {
            this.state = 30;
            this.match(SpecParser.T__1);
            this.state = 31;
            this.match(SpecParser.T__0);
            this.state = 32;
            this.sexpr();
            this.state = 33;
            this.match(SpecParser.T__2);
          }
        }

        this.state = 42;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        if (_la === 4) {
          {
            this.state = 37;
            this.match(SpecParser.T__3);
            this.state = 38;
            this.match(SpecParser.T__0);
            this.state = 39;
            this.sexpr();
            this.state = 40;
            this.match(SpecParser.T__2);
          }
        }

        this.state = 51;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        if (_la === 5) {
          {
            this.state = 44;
            this.match(SpecParser.T__4);
            this.state = 48;
            this._errHandler.sync(this);
            _la = this._input.LA(1);
            while (_la === 1) {
              {
                {
                  this.state = 45;
                  this.vspec();
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
    } catch (re) {
      if (re instanceof RecognitionException) {
        localctx.exception = re;
        this._errHandler.reportError(this, re);
        this._errHandler.recover(this, re);
      } else {
        throw re;
      }
    } finally {
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
        this.state = 55;
        this.match(SpecParser.T__0);
        this.state = 56;
        this.call();
        this.state = 57;
        this.match(SpecParser.TCONN);
        this.state = 58;
        this.call();
        this.state = 64;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        if (_la === 6) {
          {
            this.state = 59;
            this.match(SpecParser.T__5);
            this.state = 60;
            this.match(SpecParser.T__0);
            this.state = 61;
            this.sexpr();
            this.state = 62;
            this.match(SpecParser.T__2);
          }
        }

        this.state = 71;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        if (_la === 4) {
          {
            this.state = 66;
            this.match(SpecParser.T__3);
            this.state = 67;
            this.match(SpecParser.T__0);
            this.state = 68;
            this.sexpr();
            this.state = 69;
            this.match(SpecParser.T__2);
          }
        }

        this.state = 73;
        this.match(SpecParser.T__2);
      }
    } catch (re) {
      if (re instanceof RecognitionException) {
        localctx.exception = re;
        this._errHandler.reportError(this, re);
        this._errHandler.recover(this, re);
      } else {
        throw re;
      }
    } finally {
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
        this.state = 76;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        do {
          {
            {
              this.state = 75;
              _la = this._input.LA(1);
              if (_la <= 0 || _la === 1 || _la === 3) {
                this._errHandler.recoverInline(this);
              } else {
                this._errHandler.reportMatch(this);
                this.consume();
              }
            }
          }
          this.state = 78;
          this._errHandler.sync(this);
          _la = this._input.LA(1);
        } while ((_la & ~0x1f) === 0 && ((1 << _la) & 524276) !== 0);
      }
    } catch (re) {
      if (re instanceof RecognitionException) {
        localctx.exception = re;
        this._errHandler.reportError(this, re);
        this._errHandler.recover(this, re);
      } else {
        throw re;
      }
    } finally {
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
        this.state = 80;
        this.fname();
        this.state = 82;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        if (_la === 1) {
          {
            this.state = 81;
            this.dict();
          }
        }

        this.state = 84;
        this.match(SpecParser.T__6);
        this.state = 85;
        this.idents();
        this.state = 86;
        this.match(SpecParser.T__7);
        this.state = 89;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        if (_la === 9) {
          {
            this.state = 87;
            this.match(SpecParser.T__8);
            this.state = 88;
            this.tuple();
          }
        }
      }
    } catch (re) {
      if (re instanceof RecognitionException) {
        localctx.exception = re;
        this._errHandler.reportError(this, re);
        this._errHandler.recover(this, re);
      } else {
        throw re;
      }
    } finally {
      this.exitRule();
    }
    return localctx;
  }
  // @RuleVersion(0)
  public fname(): FnameContext {
    let localctx: FnameContext = new FnameContext(this, this._ctx, this.state);
    this.enterRule(localctx, 10, SpecParser.RULE_fname);
    let _la: number;
    try {
      this.enterOuterAlt(localctx, 1);
      {
        this.state = 91;
        this.match(SpecParser.IDENT);
        this.state = 94;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        if (_la === 10) {
          {
            this.state = 92;
            this.match(SpecParser.T__9);
            this.state = 93;
            this.match(SpecParser.IDENT);
          }
        }
      }
    } catch (re) {
      if (re instanceof RecognitionException) {
        localctx.exception = re;
        this._errHandler.reportError(this, re);
        this._errHandler.recover(this, re);
      } else {
        throw re;
      }
    } finally {
      this.exitRule();
    }
    return localctx;
  }
  // @RuleVersion(0)
  public dict(): DictContext {
    let localctx: DictContext = new DictContext(this, this._ctx, this.state);
    this.enterRule(localctx, 12, SpecParser.RULE_dict);
    let _la: number;
    try {
      this.enterOuterAlt(localctx, 1);
      {
        this.state = 96;
        this.match(SpecParser.T__0);
        this.state = 97;
        this.pair();
        this.state = 102;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        while (_la === 11) {
          {
            {
              this.state = 98;
              this.match(SpecParser.T__10);
              this.state = 99;
              this.pair();
            }
          }
          this.state = 104;
          this._errHandler.sync(this);
          _la = this._input.LA(1);
        }
        this.state = 105;
        this.match(SpecParser.T__2);
      }
    } catch (re) {
      if (re instanceof RecognitionException) {
        localctx.exception = re;
        this._errHandler.reportError(this, re);
        this._errHandler.recover(this, re);
      } else {
        throw re;
      }
    } finally {
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
        this.state = 107;
        this.match(SpecParser.IDENT);
        this.state = 108;
        this.match(SpecParser.T__11);
        this.state = 109;
        this.match(SpecParser.IDENT);
      }
    } catch (re) {
      if (re instanceof RecognitionException) {
        localctx.exception = re;
        this._errHandler.reportError(this, re);
        this._errHandler.recover(this, re);
      } else {
        throw re;
      }
    } finally {
      this.exitRule();
    }
    return localctx;
  }
  // @RuleVersion(0)
  public tuple(): TupleContext {
    let localctx: TupleContext = new TupleContext(this, this._ctx, this.state);
    this.enterRule(localctx, 16, SpecParser.RULE_tuple);
    try {
      this.state = 116;
      this._errHandler.sync(this);
      switch (this._input.LA(1)) {
        case 13:
          this.enterOuterAlt(localctx, 1);
          {
            this.state = 111;
            this.match(SpecParser.IDENT);
          }
          break;
        case 7:
          this.enterOuterAlt(localctx, 2);
          {
            this.state = 112;
            this.match(SpecParser.T__6);
            this.state = 113;
            this.idents();
            this.state = 114;
            this.match(SpecParser.T__7);
          }
          break;
        default:
          throw new NoViableAltException(this);
      }
    } catch (re) {
      if (re instanceof RecognitionException) {
        localctx.exception = re;
        this._errHandler.reportError(this, re);
        this._errHandler.recover(this, re);
      } else {
        throw re;
      }
    } finally {
      this.exitRule();
    }
    return localctx;
  }
  // @RuleVersion(0)
  public idents(): IdentsContext {
    let localctx: IdentsContext = new IdentsContext(
      this,
      this._ctx,
      this.state,
    );
    this.enterRule(localctx, 18, SpecParser.RULE_idents);
    let _la: number;
    try {
      this.enterOuterAlt(localctx, 1);
      {
        this.state = 126;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        if (_la === 13) {
          {
            this.state = 118;
            this.match(SpecParser.IDENT);
            this.state = 123;
            this._errHandler.sync(this);
            _la = this._input.LA(1);
            while (_la === 11) {
              {
                {
                  this.state = 119;
                  this.match(SpecParser.T__10);
                  this.state = 120;
                  this.match(SpecParser.IDENT);
                }
              }
              this.state = 125;
              this._errHandler.sync(this);
              _la = this._input.LA(1);
            }
          }
        }
      }
    } catch (re) {
      if (re instanceof RecognitionException) {
        localctx.exception = re;
        this._errHandler.reportError(this, re);
        this._errHandler.recover(this, re);
      } else {
        throw re;
      }
    } finally {
      this.exitRule();
    }
    return localctx;
  }

  public static readonly _serializedATN: number[] = [
    4, 1, 18, 129, 2, 0, 7, 0, 2, 1, 7, 1, 2, 2, 7, 2, 2, 3, 7, 3, 2, 4, 7, 4,
    2, 5, 7, 5, 2, 6, 7, 6, 2, 7, 7, 7, 2, 8, 7, 8, 2, 9, 7, 9, 1, 0, 1, 0, 1,
    0, 1, 0, 1, 0, 1, 0, 3, 0, 27, 8, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 3, 1, 36, 8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 43, 8, 1, 1, 1, 1, 1,
    5, 1, 47, 8, 1, 10, 1, 12, 1, 50, 9, 1, 3, 1, 52, 8, 1, 1, 1, 1, 1, 1, 2, 1,
    2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 3, 2, 65, 8, 2, 1, 2, 1, 2, 1,
    2, 1, 2, 1, 2, 3, 2, 72, 8, 2, 1, 2, 1, 2, 1, 3, 4, 3, 77, 8, 3, 11, 3, 12,
    3, 78, 1, 4, 1, 4, 3, 4, 83, 8, 4, 1, 4, 1, 4, 1, 4, 1, 4, 1, 4, 3, 4, 90,
    8, 4, 1, 5, 1, 5, 1, 5, 3, 5, 95, 8, 5, 1, 6, 1, 6, 1, 6, 1, 6, 5, 6, 101,
    8, 6, 10, 6, 12, 6, 104, 9, 6, 1, 6, 1, 6, 1, 7, 1, 7, 1, 7, 1, 7, 1, 8, 1,
    8, 1, 8, 1, 8, 1, 8, 3, 8, 117, 8, 8, 1, 9, 1, 9, 1, 9, 5, 9, 122, 8, 9, 10,
    9, 12, 9, 125, 9, 9, 3, 9, 127, 8, 9, 1, 9, 0, 0, 10, 0, 2, 4, 6, 8, 10, 12,
    14, 16, 18, 0, 1, 2, 0, 1, 1, 3, 3, 133, 0, 26, 1, 0, 0, 0, 2, 28, 1, 0, 0,
    0, 4, 55, 1, 0, 0, 0, 6, 76, 1, 0, 0, 0, 8, 80, 1, 0, 0, 0, 10, 91, 1, 0, 0,
    0, 12, 96, 1, 0, 0, 0, 14, 107, 1, 0, 0, 0, 16, 116, 1, 0, 0, 0, 18, 126, 1,
    0, 0, 0, 20, 21, 3, 2, 1, 0, 21, 22, 5, 0, 0, 1, 22, 27, 1, 0, 0, 0, 23, 24,
    3, 4, 2, 0, 24, 25, 5, 0, 0, 1, 25, 27, 1, 0, 0, 0, 26, 20, 1, 0, 0, 0, 26,
    23, 1, 0, 0, 0, 27, 1, 1, 0, 0, 0, 28, 29, 5, 1, 0, 0, 29, 35, 3, 8, 4, 0,
    30, 31, 5, 2, 0, 0, 31, 32, 5, 1, 0, 0, 32, 33, 3, 6, 3, 0, 33, 34, 5, 3, 0,
    0, 34, 36, 1, 0, 0, 0, 35, 30, 1, 0, 0, 0, 35, 36, 1, 0, 0, 0, 36, 42, 1, 0,
    0, 0, 37, 38, 5, 4, 0, 0, 38, 39, 5, 1, 0, 0, 39, 40, 3, 6, 3, 0, 40, 41, 5,
    3, 0, 0, 41, 43, 1, 0, 0, 0, 42, 37, 1, 0, 0, 0, 42, 43, 1, 0, 0, 0, 43, 51,
    1, 0, 0, 0, 44, 48, 5, 5, 0, 0, 45, 47, 3, 2, 1, 0, 46, 45, 1, 0, 0, 0, 47,
    50, 1, 0, 0, 0, 48, 46, 1, 0, 0, 0, 48, 49, 1, 0, 0, 0, 49, 52, 1, 0, 0, 0,
    50, 48, 1, 0, 0, 0, 51, 44, 1, 0, 0, 0, 51, 52, 1, 0, 0, 0, 52, 53, 1, 0, 0,
    0, 53, 54, 5, 3, 0, 0, 54, 3, 1, 0, 0, 0, 55, 56, 5, 1, 0, 0, 56, 57, 3, 8,
    4, 0, 57, 58, 5, 14, 0, 0, 58, 64, 3, 8, 4, 0, 59, 60, 5, 6, 0, 0, 60, 61,
    5, 1, 0, 0, 61, 62, 3, 6, 3, 0, 62, 63, 5, 3, 0, 0, 63, 65, 1, 0, 0, 0, 64,
    59, 1, 0, 0, 0, 64, 65, 1, 0, 0, 0, 65, 71, 1, 0, 0, 0, 66, 67, 5, 4, 0, 0,
    67, 68, 5, 1, 0, 0, 68, 69, 3, 6, 3, 0, 69, 70, 5, 3, 0, 0, 70, 72, 1, 0, 0,
    0, 71, 66, 1, 0, 0, 0, 71, 72, 1, 0, 0, 0, 72, 73, 1, 0, 0, 0, 73, 74, 5, 3,
    0, 0, 74, 5, 1, 0, 0, 0, 75, 77, 8, 0, 0, 0, 76, 75, 1, 0, 0, 0, 77, 78, 1,
    0, 0, 0, 78, 76, 1, 0, 0, 0, 78, 79, 1, 0, 0, 0, 79, 7, 1, 0, 0, 0, 80, 82,
    3, 10, 5, 0, 81, 83, 3, 12, 6, 0, 82, 81, 1, 0, 0, 0, 82, 83, 1, 0, 0, 0,
    83, 84, 1, 0, 0, 0, 84, 85, 5, 7, 0, 0, 85, 86, 3, 18, 9, 0, 86, 89, 5, 8,
    0, 0, 87, 88, 5, 9, 0, 0, 88, 90, 3, 16, 8, 0, 89, 87, 1, 0, 0, 0, 89, 90,
    1, 0, 0, 0, 90, 9, 1, 0, 0, 0, 91, 94, 5, 13, 0, 0, 92, 93, 5, 10, 0, 0, 93,
    95, 5, 13, 0, 0, 94, 92, 1, 0, 0, 0, 94, 95, 1, 0, 0, 0, 95, 11, 1, 0, 0, 0,
    96, 97, 5, 1, 0, 0, 97, 102, 3, 14, 7, 0, 98, 99, 5, 11, 0, 0, 99, 101, 3,
    14, 7, 0, 100, 98, 1, 0, 0, 0, 101, 104, 1, 0, 0, 0, 102, 100, 1, 0, 0, 0,
    102, 103, 1, 0, 0, 0, 103, 105, 1, 0, 0, 0, 104, 102, 1, 0, 0, 0, 105, 106,
    5, 3, 0, 0, 106, 13, 1, 0, 0, 0, 107, 108, 5, 13, 0, 0, 108, 109, 5, 12, 0,
    0, 109, 110, 5, 13, 0, 0, 110, 15, 1, 0, 0, 0, 111, 117, 5, 13, 0, 0, 112,
    113, 5, 7, 0, 0, 113, 114, 3, 18, 9, 0, 114, 115, 5, 8, 0, 0, 115, 117, 1,
    0, 0, 0, 116, 111, 1, 0, 0, 0, 116, 112, 1, 0, 0, 0, 117, 17, 1, 0, 0, 0,
    118, 123, 5, 13, 0, 0, 119, 120, 5, 11, 0, 0, 120, 122, 5, 13, 0, 0, 121,
    119, 1, 0, 0, 0, 122, 125, 1, 0, 0, 0, 123, 121, 1, 0, 0, 0, 123, 124, 1, 0,
    0, 0, 124, 127, 1, 0, 0, 0, 125, 123, 1, 0, 0, 0, 126, 118, 1, 0, 0, 0, 126,
    127, 1, 0, 0, 0, 127, 19, 1, 0, 0, 0, 15, 26, 35, 42, 48, 51, 64, 71, 78,
    82, 89, 94, 102, 116, 123, 126,
  ];

  private static __ATN: ATN;
  public static get _ATN(): ATN {
    if (!SpecParser.__ATN) {
      SpecParser.__ATN = new ATNDeserializer().deserialize(
        SpecParser._serializedATN,
      );
    }

    return SpecParser.__ATN;
  }

  static DecisionsToDFA = SpecParser._ATN.decisionToState.map(
    (ds: DecisionState, index: number) => new DFA(ds, index),
  );
}

export class SpecContext extends ParserRuleContext {
  constructor(
    parser?: SpecParser,
    parent?: ParserRuleContext,
    invokingState?: number,
  ) {
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
    if (listener.enterSpec) {
      listener.enterSpec(this);
    }
  }
  public exitRule(listener: SpecListener): void {
    if (listener.exitSpec) {
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
  constructor(
    parser?: SpecParser,
    parent?: ParserRuleContext,
    invokingState?: number,
  ) {
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
    if (listener.enterVspec) {
      listener.enterVspec(this);
    }
  }
  public exitRule(listener: SpecListener): void {
    if (listener.exitVspec) {
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
  constructor(
    parser?: SpecParser,
    parent?: ParserRuleContext,
    invokingState?: number,
  ) {
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
    if (listener.enterTspec) {
      listener.enterTspec(this);
    }
  }
  public exitRule(listener: SpecListener): void {
    if (listener.exitTspec) {
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
  constructor(
    parser?: SpecParser,
    parent?: ParserRuleContext,
    invokingState?: number,
  ) {
    super(parent, invokingState);
    this.parser = parser;
  }
  public get ruleIndex(): number {
    return SpecParser.RULE_sexpr;
  }
  public enterRule(listener: SpecListener): void {
    if (listener.enterSexpr) {
      listener.enterSexpr(this);
    }
  }
  public exitRule(listener: SpecListener): void {
    if (listener.exitSexpr) {
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
  constructor(
    parser?: SpecParser,
    parent?: ParserRuleContext,
    invokingState?: number,
  ) {
    super(parent, invokingState);
    this.parser = parser;
  }
  public fname(): FnameContext {
    return this.getTypedRuleContext(FnameContext, 0) as FnameContext;
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
    if (listener.enterCall) {
      listener.enterCall(this);
    }
  }
  public exitRule(listener: SpecListener): void {
    if (listener.exitCall) {
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

export class FnameContext extends ParserRuleContext {
  constructor(
    parser?: SpecParser,
    parent?: ParserRuleContext,
    invokingState?: number,
  ) {
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
    return SpecParser.RULE_fname;
  }
  public enterRule(listener: SpecListener): void {
    if (listener.enterFname) {
      listener.enterFname(this);
    }
  }
  public exitRule(listener: SpecListener): void {
    if (listener.exitFname) {
      listener.exitFname(this);
    }
  }
  // @Override
  public accept<Result>(visitor: SpecVisitor<Result>): Result {
    if (visitor.visitFname) {
      return visitor.visitFname(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

export class DictContext extends ParserRuleContext {
  constructor(
    parser?: SpecParser,
    parent?: ParserRuleContext,
    invokingState?: number,
  ) {
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
    if (listener.enterDict) {
      listener.enterDict(this);
    }
  }
  public exitRule(listener: SpecListener): void {
    if (listener.exitDict) {
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
  constructor(
    parser?: SpecParser,
    parent?: ParserRuleContext,
    invokingState?: number,
  ) {
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
    if (listener.enterPair) {
      listener.enterPair(this);
    }
  }
  public exitRule(listener: SpecListener): void {
    if (listener.exitPair) {
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
  constructor(
    parser?: SpecParser,
    parent?: ParserRuleContext,
    invokingState?: number,
  ) {
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
    if (listener.enterTuple) {
      listener.enterTuple(this);
    }
  }
  public exitRule(listener: SpecListener): void {
    if (listener.exitTuple) {
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
  constructor(
    parser?: SpecParser,
    parent?: ParserRuleContext,
    invokingState?: number,
  ) {
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
    if (listener.enterIdents) {
      listener.enterIdents(this);
    }
  }
  public exitRule(listener: SpecListener): void {
    if (listener.exitIdents) {
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
