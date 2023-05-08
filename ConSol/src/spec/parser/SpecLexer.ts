// @ts-nocheck
// Generated from Spec.g4 by ANTLR 4.12.0
// noinspection ES6UnusedImports,JSUnusedGlobalSymbols,JSUnusedLocalSymbols
import {
  ATN,
  ATNDeserializer,
  CharStream,
  DecisionState,
  DFA,
  Lexer,
  LexerATNSimulator,
  RuleContext,
  PredictionContextCache,
  Token,
} from 'antlr4';
export default class SpecLexer extends Lexer {
  public static readonly T__0 = 1;
  public static readonly T__1 = 2;
  public static readonly T__2 = 3;
  public static readonly T__3 = 4;
  public static readonly T__4 = 5;
  public static readonly T__5 = 6;
  public static readonly T__6 = 7;
  public static readonly T__7 = 8;
  public static readonly T__8 = 9;
  public static readonly IDENT = 10;
  public static readonly TCONN = 11;
  public static readonly OP = 12;
  public static readonly QUOTE = 13;
  public static readonly INT = 14;
  public static readonly WS = 15;
  public static readonly EOF = Token.EOF;

  public static readonly channelNames: string[] = [
    'DEFAULT_TOKEN_CHANNEL',
    'HIDDEN',
  ];
  public static readonly literalNames: string[] = [
    null,
    "'{'",
    "'|'",
    "'}'",
    "'->'",
    "'/\\'",
    "'('",
    "')'",
    "','",
    "'returns'",
  ];
  public static readonly symbolicNames: string[] = [
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
  public static readonly modeNames: string[] = ['DEFAULT_MODE'];

  public static readonly ruleNames: string[] = [
    'T__0',
    'T__1',
    'T__2',
    'T__3',
    'T__4',
    'T__5',
    'T__6',
    'T__7',
    'T__8',
    'IDENT',
    'TCONN',
    'OP',
    'QUOTE',
    'INT',
    'WS',
  ];

  constructor(input: CharStream) {
    super(input);
    this._interp = new LexerATNSimulator(
      this,
      SpecLexer._ATN,
      SpecLexer.DecisionsToDFA,
      new PredictionContextCache(),
    );
  }

  public get grammarFileName(): string {
    return 'Spec.g4';
  }

  public get literalNames(): (string | null)[] {
    return SpecLexer.literalNames;
  }
  public get symbolicNames(): (string | null)[] {
    return SpecLexer.symbolicNames;
  }
  public get ruleNames(): string[] {
    return SpecLexer.ruleNames;
  }

  public get serializedATN(): number[] {
    return SpecLexer._serializedATN;
  }

  public get channelNames(): string[] {
    return SpecLexer.channelNames;
  }

  public get modeNames(): string[] {
    return SpecLexer.modeNames;
  }

  public static readonly _serializedATN: number[] = [
    4, 0, 15, 146, 6, -1, 2, 0, 7, 0, 2, 1, 7, 1, 2, 2, 7, 2, 2, 3, 7, 3, 2, 4,
    7, 4, 2, 5, 7, 5, 2, 6, 7, 6, 2, 7, 7, 7, 2, 8, 7, 8, 2, 9, 7, 9, 2, 10, 7,
    10, 2, 11, 7, 11, 2, 12, 7, 12, 2, 13, 7, 13, 2, 14, 7, 14, 1, 0, 1, 0, 1,
    1, 1, 1, 1, 2, 1, 2, 1, 3, 1, 3, 1, 3, 1, 4, 1, 4, 1, 4, 1, 5, 1, 5, 1, 6,
    1, 6, 1, 7, 1, 7, 1, 8, 1, 8, 1, 8, 1, 8, 1, 8, 1, 8, 1, 8, 1, 8, 1, 9, 1,
    9, 5, 9, 60, 8, 9, 10, 9, 12, 9, 63, 9, 9, 1, 10, 1, 10, 1, 10, 1, 10, 1,
    10, 1, 10, 1, 10, 1, 10, 1, 10, 1, 10, 3, 10, 75, 8, 10, 1, 11, 1, 11, 1,
    11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1,
    11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1,
    11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1,
    11, 3, 11, 113, 8, 11, 1, 12, 1, 12, 1, 13, 4, 13, 118, 8, 13, 11, 13, 12,
    13, 119, 1, 13, 1, 13, 1, 13, 4, 13, 125, 8, 13, 11, 13, 12, 13, 126, 1, 13,
    1, 13, 3, 13, 131, 8, 13, 1, 13, 4, 13, 134, 8, 13, 11, 13, 12, 13, 135, 3,
    13, 138, 8, 13, 1, 14, 4, 14, 141, 8, 14, 11, 14, 12, 14, 142, 1, 14, 1, 14,
    0, 0, 15, 1, 1, 3, 2, 5, 3, 7, 4, 9, 5, 11, 6, 13, 7, 15, 8, 17, 9, 19, 10,
    21, 11, 23, 12, 25, 13, 27, 14, 29, 15, 1, 0, 12, 3, 0, 65, 90, 95, 95, 97,
    122, 4, 0, 48, 57, 65, 90, 95, 95, 97, 122, 10, 0, 33, 33, 37, 38, 42, 43,
    45, 45, 47, 47, 58, 58, 63, 63, 94, 94, 124, 124, 126, 126, 2, 0, 60, 60,
    62, 62, 2, 0, 40, 41, 46, 46, 2, 0, 34, 34, 39, 39, 1, 0, 48, 57, 2, 0, 88,
    88, 120, 120, 3, 0, 48, 57, 65, 70, 97, 102, 2, 0, 79, 79, 111, 111, 1, 0,
    48, 55, 3, 0, 9, 10, 13, 13, 32, 32, 174, 0, 1, 1, 0, 0, 0, 0, 3, 1, 0, 0,
    0, 0, 5, 1, 0, 0, 0, 0, 7, 1, 0, 0, 0, 0, 9, 1, 0, 0, 0, 0, 11, 1, 0, 0, 0,
    0, 13, 1, 0, 0, 0, 0, 15, 1, 0, 0, 0, 0, 17, 1, 0, 0, 0, 0, 19, 1, 0, 0, 0,
    0, 21, 1, 0, 0, 0, 0, 23, 1, 0, 0, 0, 0, 25, 1, 0, 0, 0, 0, 27, 1, 0, 0, 0,
    0, 29, 1, 0, 0, 0, 1, 31, 1, 0, 0, 0, 3, 33, 1, 0, 0, 0, 5, 35, 1, 0, 0, 0,
    7, 37, 1, 0, 0, 0, 9, 40, 1, 0, 0, 0, 11, 43, 1, 0, 0, 0, 13, 45, 1, 0, 0,
    0, 15, 47, 1, 0, 0, 0, 17, 49, 1, 0, 0, 0, 19, 57, 1, 0, 0, 0, 21, 74, 1, 0,
    0, 0, 23, 112, 1, 0, 0, 0, 25, 114, 1, 0, 0, 0, 27, 137, 1, 0, 0, 0, 29,
    140, 1, 0, 0, 0, 31, 32, 5, 123, 0, 0, 32, 2, 1, 0, 0, 0, 33, 34, 5, 124, 0,
    0, 34, 4, 1, 0, 0, 0, 35, 36, 5, 125, 0, 0, 36, 6, 1, 0, 0, 0, 37, 38, 5,
    45, 0, 0, 38, 39, 5, 62, 0, 0, 39, 8, 1, 0, 0, 0, 40, 41, 5, 47, 0, 0, 41,
    42, 5, 92, 0, 0, 42, 10, 1, 0, 0, 0, 43, 44, 5, 40, 0, 0, 44, 12, 1, 0, 0,
    0, 45, 46, 5, 41, 0, 0, 46, 14, 1, 0, 0, 0, 47, 48, 5, 44, 0, 0, 48, 16, 1,
    0, 0, 0, 49, 50, 5, 114, 0, 0, 50, 51, 5, 101, 0, 0, 51, 52, 5, 116, 0, 0,
    52, 53, 5, 117, 0, 0, 53, 54, 5, 114, 0, 0, 54, 55, 5, 110, 0, 0, 55, 56, 5,
    115, 0, 0, 56, 18, 1, 0, 0, 0, 57, 61, 7, 0, 0, 0, 58, 60, 7, 1, 0, 0, 59,
    58, 1, 0, 0, 0, 60, 63, 1, 0, 0, 0, 61, 59, 1, 0, 0, 0, 61, 62, 1, 0, 0, 0,
    62, 20, 1, 0, 0, 0, 63, 61, 1, 0, 0, 0, 64, 65, 5, 61, 0, 0, 65, 75, 5, 62,
    0, 0, 66, 67, 5, 61, 0, 0, 67, 68, 5, 47, 0, 0, 68, 75, 5, 62, 0, 0, 69, 70,
    5, 126, 0, 0, 70, 75, 5, 62, 0, 0, 71, 72, 5, 126, 0, 0, 72, 73, 5, 47, 0,
    0, 73, 75, 5, 62, 0, 0, 74, 64, 1, 0, 0, 0, 74, 66, 1, 0, 0, 0, 74, 69, 1,
    0, 0, 0, 74, 71, 1, 0, 0, 0, 75, 22, 1, 0, 0, 0, 76, 113, 7, 2, 0, 0, 77,
    78, 5, 61, 0, 0, 78, 113, 5, 61, 0, 0, 79, 80, 5, 33, 0, 0, 80, 113, 5, 61,
    0, 0, 81, 113, 7, 3, 0, 0, 82, 83, 5, 60, 0, 0, 83, 113, 5, 61, 0, 0, 84,
    85, 5, 62, 0, 0, 85, 113, 5, 61, 0, 0, 86, 87, 5, 38, 0, 0, 87, 113, 5, 38,
    0, 0, 88, 89, 5, 124, 0, 0, 89, 113, 5, 124, 0, 0, 90, 91, 5, 43, 0, 0, 91,
    113, 5, 43, 0, 0, 92, 93, 5, 45, 0, 0, 93, 113, 5, 45, 0, 0, 94, 95, 5, 45,
    0, 0, 95, 113, 5, 61, 0, 0, 96, 97, 5, 43, 0, 0, 97, 113, 5, 61, 0, 0, 98,
    99, 5, 42, 0, 0, 99, 113, 5, 61, 0, 0, 100, 101, 5, 47, 0, 0, 101, 113, 5,
    61, 0, 0, 102, 103, 5, 37, 0, 0, 103, 113, 5, 61, 0, 0, 104, 105, 5, 62, 0,
    0, 105, 113, 5, 62, 0, 0, 106, 107, 5, 62, 0, 0, 107, 108, 5, 62, 0, 0, 108,
    113, 5, 62, 0, 0, 109, 110, 5, 60, 0, 0, 110, 113, 5, 60, 0, 0, 111, 113, 7,
    4, 0, 0, 112, 76, 1, 0, 0, 0, 112, 77, 1, 0, 0, 0, 112, 79, 1, 0, 0, 0, 112,
    81, 1, 0, 0, 0, 112, 82, 1, 0, 0, 0, 112, 84, 1, 0, 0, 0, 112, 86, 1, 0, 0,
    0, 112, 88, 1, 0, 0, 0, 112, 90, 1, 0, 0, 0, 112, 92, 1, 0, 0, 0, 112, 94,
    1, 0, 0, 0, 112, 96, 1, 0, 0, 0, 112, 98, 1, 0, 0, 0, 112, 100, 1, 0, 0, 0,
    112, 102, 1, 0, 0, 0, 112, 104, 1, 0, 0, 0, 112, 106, 1, 0, 0, 0, 112, 109,
    1, 0, 0, 0, 112, 111, 1, 0, 0, 0, 113, 24, 1, 0, 0, 0, 114, 115, 7, 5, 0, 0,
    115, 26, 1, 0, 0, 0, 116, 118, 7, 6, 0, 0, 117, 116, 1, 0, 0, 0, 118, 119,
    1, 0, 0, 0, 119, 117, 1, 0, 0, 0, 119, 120, 1, 0, 0, 0, 120, 138, 1, 0, 0,
    0, 121, 122, 5, 48, 0, 0, 122, 124, 7, 7, 0, 0, 123, 125, 7, 8, 0, 0, 124,
    123, 1, 0, 0, 0, 125, 126, 1, 0, 0, 0, 126, 124, 1, 0, 0, 0, 126, 127, 1, 0,
    0, 0, 127, 138, 1, 0, 0, 0, 128, 130, 5, 48, 0, 0, 129, 131, 7, 9, 0, 0,
    130, 129, 1, 0, 0, 0, 130, 131, 1, 0, 0, 0, 131, 133, 1, 0, 0, 0, 132, 134,
    7, 10, 0, 0, 133, 132, 1, 0, 0, 0, 134, 135, 1, 0, 0, 0, 135, 133, 1, 0, 0,
    0, 135, 136, 1, 0, 0, 0, 136, 138, 1, 0, 0, 0, 137, 117, 1, 0, 0, 0, 137,
    121, 1, 0, 0, 0, 137, 128, 1, 0, 0, 0, 138, 28, 1, 0, 0, 0, 139, 141, 7, 11,
    0, 0, 140, 139, 1, 0, 0, 0, 141, 142, 1, 0, 0, 0, 142, 140, 1, 0, 0, 0, 142,
    143, 1, 0, 0, 0, 143, 144, 1, 0, 0, 0, 144, 145, 6, 14, 0, 0, 145, 30, 1, 0,
    0, 0, 10, 0, 61, 74, 112, 119, 126, 130, 135, 137, 142, 1, 6, 0, 0,
  ];

  private static __ATN: ATN;
  public static get _ATN(): ATN {
    if (!SpecLexer.__ATN) {
      SpecLexer.__ATN = new ATNDeserializer().deserialize(
        SpecLexer._serializedATN,
      );
    }

    return SpecLexer.__ATN;
  }

  static DecisionsToDFA = SpecLexer._ATN.decisionToState.map(
    (ds: DecisionState, index: number) => new DFA(ds, index),
  );
}
