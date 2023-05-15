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
    "'where'",
    "'ensures'",
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

        this.state = 44;
        this._errHandler.sync(this);
        switch (this._interp.adaptivePredict(this._input, 3, this._ctx)) {
          case 1:
            {
              this.state = 37;
              this.match(SpecParser.T__3);
              this.state = 41;
              this._errHandler.sync(this);
              _la = this._input.LA(1);
              while (_la === 1) {
                {
                  {
                    this.state = 38;
                    this.vspec();
                  }
                }
                this.state = 43;
                this._errHandler.sync(this);
                _la = this._input.LA(1);
              }
            }
            break;
        }
        this.state = 51;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        if (_la === 5) {
          {
            this.state = 46;
            this.match(SpecParser.T__4);
            this.state = 47;
            this.match(SpecParser.T__0);
            this.state = 48;
            this.sexpr();
            this.state = 49;
            this.match(SpecParser.T__2);
          }
        }

        this.state = 60;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        if (_la === 4) {
          {
            this.state = 53;
            this.match(SpecParser.T__3);
            this.state = 57;
            this._errHandler.sync(this);
            _la = this._input.LA(1);
            while (_la === 1) {
              {
                {
                  this.state = 54;
                  this.vspec();
                }
              }
              this.state = 59;
              this._errHandler.sync(this);
              _la = this._input.LA(1);
            }
          }
        }

        this.state = 62;
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
        this.state = 64;
        this.match(SpecParser.T__0);
        this.state = 65;
        this.call();
        this.state = 66;
        this.match(SpecParser.TCONN);
        this.state = 67;
        this.call();
        this.state = 73;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        if (_la === 6) {
          {
            this.state = 68;
            this.match(SpecParser.T__5);
            this.state = 69;
            this.match(SpecParser.T__0);
            this.state = 70;
            this.sexpr();
            this.state = 71;
            this.match(SpecParser.T__2);
          }
        }

        this.state = 80;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        if (_la === 5) {
          {
            this.state = 75;
            this.match(SpecParser.T__4);
            this.state = 76;
            this.match(SpecParser.T__0);
            this.state = 77;
            this.sexpr();
            this.state = 78;
            this.match(SpecParser.T__2);
          }
        }

        this.state = 82;
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
        this.state = 85;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        do {
          {
            {
              this.state = 84;
              _la = this._input.LA(1);
              if (_la <= 0 || _la === 1 || _la === 3) {
                this._errHandler.recoverInline(this);
              } else {
                this._errHandler.reportMatch(this);
                this.consume();
              }
            }
          }
          this.state = 87;
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
        this.state = 89;
        this.fname();
        this.state = 91;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        if (_la === 1) {
          {
            this.state = 90;
            this.dict();
          }
        }

        this.state = 93;
        this.match(SpecParser.T__6);
        this.state = 94;
        this.idents();
        this.state = 95;
        this.match(SpecParser.T__7);
        this.state = 98;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        if (_la === 9) {
          {
            this.state = 96;
            this.match(SpecParser.T__8);
            this.state = 97;
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
        this.state = 100;
        this.match(SpecParser.IDENT);
        this.state = 103;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        if (_la === 10) {
          {
            this.state = 101;
            this.match(SpecParser.T__9);
            this.state = 102;
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
        this.state = 105;
        this.match(SpecParser.T__0);
        this.state = 106;
        this.pair();
        this.state = 111;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        while (_la === 11) {
          {
            {
              this.state = 107;
              this.match(SpecParser.T__10);
              this.state = 108;
              this.pair();
            }
          }
          this.state = 113;
          this._errHandler.sync(this);
          _la = this._input.LA(1);
        }
        this.state = 114;
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
        this.state = 116;
        this.match(SpecParser.IDENT);
        this.state = 117;
        this.match(SpecParser.T__11);
        this.state = 118;
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
      this.state = 125;
      this._errHandler.sync(this);
      switch (this._input.LA(1)) {
        case 13:
          this.enterOuterAlt(localctx, 1);
          {
            this.state = 120;
            this.match(SpecParser.IDENT);
          }
          break;
        case 7:
          this.enterOuterAlt(localctx, 2);
          {
            this.state = 121;
            this.match(SpecParser.T__6);
            this.state = 122;
            this.idents();
            this.state = 123;
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
        this.state = 135;
        this._errHandler.sync(this);
        _la = this._input.LA(1);
        if (_la === 13) {
          {
            this.state = 127;
            this.match(SpecParser.IDENT);
            this.state = 132;
            this._errHandler.sync(this);
            _la = this._input.LA(1);
            while (_la === 11) {
              {
                {
                  this.state = 128;
                  this.match(SpecParser.T__10);
                  this.state = 129;
                  this.match(SpecParser.IDENT);
                }
              }
              this.state = 134;
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
    4, 1, 18, 138, 2, 0, 7, 0, 2, 1, 7, 1, 2, 2, 7, 2, 2, 3, 7, 3, 2, 4, 7, 4,
    2, 5, 7, 5, 2, 6, 7, 6, 2, 7, 7, 7, 2, 8, 7, 8, 2, 9, 7, 9, 1, 0, 1, 0, 1,
    0, 1, 0, 1, 0, 1, 0, 3, 0, 27, 8, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 3, 1, 36, 8, 1, 1, 1, 1, 1, 5, 1, 40, 8, 1, 10, 1, 12, 1, 43, 9, 1, 3, 1,
    45, 8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 52, 8, 1, 1, 1, 1, 1, 5, 1,
    56, 8, 1, 10, 1, 12, 1, 59, 9, 1, 3, 1, 61, 8, 1, 1, 1, 1, 1, 1, 2, 1, 2, 1,
    2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 3, 2, 74, 8, 2, 1, 2, 1, 2, 1, 2, 1,
    2, 1, 2, 3, 2, 81, 8, 2, 1, 2, 1, 2, 1, 3, 4, 3, 86, 8, 3, 11, 3, 12, 3, 87,
    1, 4, 1, 4, 3, 4, 92, 8, 4, 1, 4, 1, 4, 1, 4, 1, 4, 1, 4, 3, 4, 99, 8, 4, 1,
    5, 1, 5, 1, 5, 3, 5, 104, 8, 5, 1, 6, 1, 6, 1, 6, 1, 6, 5, 6, 110, 8, 6, 10,
    6, 12, 6, 113, 9, 6, 1, 6, 1, 6, 1, 7, 1, 7, 1, 7, 1, 7, 1, 8, 1, 8, 1, 8,
    1, 8, 1, 8, 3, 8, 126, 8, 8, 1, 9, 1, 9, 1, 9, 5, 9, 131, 8, 9, 10, 9, 12,
    9, 134, 9, 9, 3, 9, 136, 8, 9, 1, 9, 0, 0, 10, 0, 2, 4, 6, 8, 10, 12, 14,
    16, 18, 0, 1, 2, 0, 1, 1, 3, 3, 144, 0, 26, 1, 0, 0, 0, 2, 28, 1, 0, 0, 0,
    4, 64, 1, 0, 0, 0, 6, 85, 1, 0, 0, 0, 8, 89, 1, 0, 0, 0, 10, 100, 1, 0, 0,
    0, 12, 105, 1, 0, 0, 0, 14, 116, 1, 0, 0, 0, 16, 125, 1, 0, 0, 0, 18, 135,
    1, 0, 0, 0, 20, 21, 3, 2, 1, 0, 21, 22, 5, 0, 0, 1, 22, 27, 1, 0, 0, 0, 23,
    24, 3, 4, 2, 0, 24, 25, 5, 0, 0, 1, 25, 27, 1, 0, 0, 0, 26, 20, 1, 0, 0, 0,
    26, 23, 1, 0, 0, 0, 27, 1, 1, 0, 0, 0, 28, 29, 5, 1, 0, 0, 29, 35, 3, 8, 4,
    0, 30, 31, 5, 2, 0, 0, 31, 32, 5, 1, 0, 0, 32, 33, 3, 6, 3, 0, 33, 34, 5, 3,
    0, 0, 34, 36, 1, 0, 0, 0, 35, 30, 1, 0, 0, 0, 35, 36, 1, 0, 0, 0, 36, 44, 1,
    0, 0, 0, 37, 41, 5, 4, 0, 0, 38, 40, 3, 2, 1, 0, 39, 38, 1, 0, 0, 0, 40, 43,
    1, 0, 0, 0, 41, 39, 1, 0, 0, 0, 41, 42, 1, 0, 0, 0, 42, 45, 1, 0, 0, 0, 43,
    41, 1, 0, 0, 0, 44, 37, 1, 0, 0, 0, 44, 45, 1, 0, 0, 0, 45, 51, 1, 0, 0, 0,
    46, 47, 5, 5, 0, 0, 47, 48, 5, 1, 0, 0, 48, 49, 3, 6, 3, 0, 49, 50, 5, 3, 0,
    0, 50, 52, 1, 0, 0, 0, 51, 46, 1, 0, 0, 0, 51, 52, 1, 0, 0, 0, 52, 60, 1, 0,
    0, 0, 53, 57, 5, 4, 0, 0, 54, 56, 3, 2, 1, 0, 55, 54, 1, 0, 0, 0, 56, 59, 1,
    0, 0, 0, 57, 55, 1, 0, 0, 0, 57, 58, 1, 0, 0, 0, 58, 61, 1, 0, 0, 0, 59, 57,
    1, 0, 0, 0, 60, 53, 1, 0, 0, 0, 60, 61, 1, 0, 0, 0, 61, 62, 1, 0, 0, 0, 62,
    63, 5, 3, 0, 0, 63, 3, 1, 0, 0, 0, 64, 65, 5, 1, 0, 0, 65, 66, 3, 8, 4, 0,
    66, 67, 5, 14, 0, 0, 67, 73, 3, 8, 4, 0, 68, 69, 5, 6, 0, 0, 69, 70, 5, 1,
    0, 0, 70, 71, 3, 6, 3, 0, 71, 72, 5, 3, 0, 0, 72, 74, 1, 0, 0, 0, 73, 68, 1,
    0, 0, 0, 73, 74, 1, 0, 0, 0, 74, 80, 1, 0, 0, 0, 75, 76, 5, 5, 0, 0, 76, 77,
    5, 1, 0, 0, 77, 78, 3, 6, 3, 0, 78, 79, 5, 3, 0, 0, 79, 81, 1, 0, 0, 0, 80,
    75, 1, 0, 0, 0, 80, 81, 1, 0, 0, 0, 81, 82, 1, 0, 0, 0, 82, 83, 5, 3, 0, 0,
    83, 5, 1, 0, 0, 0, 84, 86, 8, 0, 0, 0, 85, 84, 1, 0, 0, 0, 86, 87, 1, 0, 0,
    0, 87, 85, 1, 0, 0, 0, 87, 88, 1, 0, 0, 0, 88, 7, 1, 0, 0, 0, 89, 91, 3, 10,
    5, 0, 90, 92, 3, 12, 6, 0, 91, 90, 1, 0, 0, 0, 91, 92, 1, 0, 0, 0, 92, 93,
    1, 0, 0, 0, 93, 94, 5, 7, 0, 0, 94, 95, 3, 18, 9, 0, 95, 98, 5, 8, 0, 0, 96,
    97, 5, 9, 0, 0, 97, 99, 3, 16, 8, 0, 98, 96, 1, 0, 0, 0, 98, 99, 1, 0, 0, 0,
    99, 9, 1, 0, 0, 0, 100, 103, 5, 13, 0, 0, 101, 102, 5, 10, 0, 0, 102, 104,
    5, 13, 0, 0, 103, 101, 1, 0, 0, 0, 103, 104, 1, 0, 0, 0, 104, 11, 1, 0, 0,
    0, 105, 106, 5, 1, 0, 0, 106, 111, 3, 14, 7, 0, 107, 108, 5, 11, 0, 0, 108,
    110, 3, 14, 7, 0, 109, 107, 1, 0, 0, 0, 110, 113, 1, 0, 0, 0, 111, 109, 1,
    0, 0, 0, 111, 112, 1, 0, 0, 0, 112, 114, 1, 0, 0, 0, 113, 111, 1, 0, 0, 0,
    114, 115, 5, 3, 0, 0, 115, 13, 1, 0, 0, 0, 116, 117, 5, 13, 0, 0, 117, 118,
    5, 12, 0, 0, 118, 119, 5, 13, 0, 0, 119, 15, 1, 0, 0, 0, 120, 126, 5, 13, 0,
    0, 121, 122, 5, 7, 0, 0, 122, 123, 3, 18, 9, 0, 123, 124, 5, 8, 0, 0, 124,
    126, 1, 0, 0, 0, 125, 120, 1, 0, 0, 0, 125, 121, 1, 0, 0, 0, 126, 17, 1, 0,
    0, 0, 127, 132, 5, 13, 0, 0, 128, 129, 5, 11, 0, 0, 129, 131, 5, 13, 0, 0,
    130, 128, 1, 0, 0, 0, 131, 134, 1, 0, 0, 0, 132, 130, 1, 0, 0, 0, 132, 133,
    1, 0, 0, 0, 133, 136, 1, 0, 0, 0, 134, 132, 1, 0, 0, 0, 135, 127, 1, 0, 0,
    0, 135, 136, 1, 0, 0, 0, 136, 19, 1, 0, 0, 0, 17, 26, 35, 41, 44, 51, 57,
    60, 73, 80, 87, 91, 98, 103, 111, 125, 132, 135,
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
