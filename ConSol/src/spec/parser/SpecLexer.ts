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

  public static readonly channelNames: string[] = [
    'DEFAULT_TOKEN_CHANNEL',
    'HIDDEN',
  ];
  public static readonly literalNames: string[] = [
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
    'T__9',
    'T__10',
    'T__11',
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
    4, 0, 18, 176, 6, -1, 2, 0, 7, 0, 2, 1, 7, 1, 2, 2, 7, 2, 2, 3, 7, 3, 2, 4,
    7, 4, 2, 5, 7, 5, 2, 6, 7, 6, 2, 7, 7, 7, 2, 8, 7, 8, 2, 9, 7, 9, 2, 10, 7,
    10, 2, 11, 7, 11, 2, 12, 7, 12, 2, 13, 7, 13, 2, 14, 7, 14, 2, 15, 7, 15, 2,
    16, 7, 16, 2, 17, 7, 17, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 2, 1, 2, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 4, 1, 4,
    1, 4, 1, 4, 1, 4, 1, 4, 1, 4, 1, 4, 1, 5, 1, 5, 1, 5, 1, 5, 1, 5, 1, 6, 1,
    6, 1, 7, 1, 7, 1, 8, 1, 8, 1, 8, 1, 8, 1, 8, 1, 8, 1, 8, 1, 8, 1, 9, 1, 9,
    1, 10, 1, 10, 1, 11, 1, 11, 1, 12, 1, 12, 5, 12, 90, 8, 12, 10, 12, 12, 12,
    93, 9, 12, 1, 13, 1, 13, 1, 13, 1, 13, 1, 13, 1, 13, 1, 13, 1, 13, 1, 13, 1,
    13, 3, 13, 105, 8, 13, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 1,
    14, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 1,
    14, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 1,
    14, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 3, 14, 143, 8, 14, 1, 15, 1,
    15, 1, 16, 4, 16, 148, 8, 16, 11, 16, 12, 16, 149, 1, 16, 1, 16, 1, 16, 4,
    16, 155, 8, 16, 11, 16, 12, 16, 156, 1, 16, 1, 16, 3, 16, 161, 8, 16, 1, 16,
    4, 16, 164, 8, 16, 11, 16, 12, 16, 165, 3, 16, 168, 8, 16, 1, 17, 4, 17,
    171, 8, 17, 11, 17, 12, 17, 172, 1, 17, 1, 17, 0, 0, 18, 1, 1, 3, 2, 5, 3,
    7, 4, 9, 5, 11, 6, 13, 7, 15, 8, 17, 9, 19, 10, 21, 11, 23, 12, 25, 13, 27,
    14, 29, 15, 31, 16, 33, 17, 35, 18, 1, 0, 12, 3, 0, 65, 90, 95, 95, 97, 122,
    4, 0, 48, 57, 65, 90, 95, 95, 97, 122, 10, 0, 33, 33, 37, 38, 42, 43, 45,
    45, 47, 47, 58, 58, 63, 63, 94, 94, 124, 124, 126, 126, 2, 0, 60, 60, 62,
    62, 2, 0, 40, 41, 46, 46, 2, 0, 34, 34, 39, 39, 1, 0, 48, 57, 2, 0, 88, 88,
    120, 120, 3, 0, 48, 57, 65, 70, 97, 102, 2, 0, 79, 79, 111, 111, 1, 0, 48,
    55, 3, 0, 9, 10, 13, 13, 32, 32, 204, 0, 1, 1, 0, 0, 0, 0, 3, 1, 0, 0, 0, 0,
    5, 1, 0, 0, 0, 0, 7, 1, 0, 0, 0, 0, 9, 1, 0, 0, 0, 0, 11, 1, 0, 0, 0, 0, 13,
    1, 0, 0, 0, 0, 15, 1, 0, 0, 0, 0, 17, 1, 0, 0, 0, 0, 19, 1, 0, 0, 0, 0, 21,
    1, 0, 0, 0, 0, 23, 1, 0, 0, 0, 0, 25, 1, 0, 0, 0, 0, 27, 1, 0, 0, 0, 0, 29,
    1, 0, 0, 0, 0, 31, 1, 0, 0, 0, 0, 33, 1, 0, 0, 0, 0, 35, 1, 0, 0, 0, 1, 37,
    1, 0, 0, 0, 3, 39, 1, 0, 0, 0, 5, 48, 1, 0, 0, 0, 7, 50, 1, 0, 0, 0, 9, 56,
    1, 0, 0, 0, 11, 64, 1, 0, 0, 0, 13, 69, 1, 0, 0, 0, 15, 71, 1, 0, 0, 0, 17,
    73, 1, 0, 0, 0, 19, 81, 1, 0, 0, 0, 21, 83, 1, 0, 0, 0, 23, 85, 1, 0, 0, 0,
    25, 87, 1, 0, 0, 0, 27, 104, 1, 0, 0, 0, 29, 142, 1, 0, 0, 0, 31, 144, 1, 0,
    0, 0, 33, 167, 1, 0, 0, 0, 35, 170, 1, 0, 0, 0, 37, 38, 5, 123, 0, 0, 38, 2,
    1, 0, 0, 0, 39, 40, 5, 114, 0, 0, 40, 41, 5, 101, 0, 0, 41, 42, 5, 113, 0,
    0, 42, 43, 5, 117, 0, 0, 43, 44, 5, 105, 0, 0, 44, 45, 5, 114, 0, 0, 45, 46,
    5, 101, 0, 0, 46, 47, 5, 115, 0, 0, 47, 4, 1, 0, 0, 0, 48, 49, 5, 125, 0, 0,
    49, 6, 1, 0, 0, 0, 50, 51, 5, 119, 0, 0, 51, 52, 5, 104, 0, 0, 52, 53, 5,
    101, 0, 0, 53, 54, 5, 114, 0, 0, 54, 55, 5, 101, 0, 0, 55, 8, 1, 0, 0, 0,
    56, 57, 5, 101, 0, 0, 57, 58, 5, 110, 0, 0, 58, 59, 5, 115, 0, 0, 59, 60, 5,
    117, 0, 0, 60, 61, 5, 114, 0, 0, 61, 62, 5, 101, 0, 0, 62, 63, 5, 115, 0, 0,
    63, 10, 1, 0, 0, 0, 64, 65, 5, 119, 0, 0, 65, 66, 5, 104, 0, 0, 66, 67, 5,
    101, 0, 0, 67, 68, 5, 110, 0, 0, 68, 12, 1, 0, 0, 0, 69, 70, 5, 40, 0, 0,
    70, 14, 1, 0, 0, 0, 71, 72, 5, 41, 0, 0, 72, 16, 1, 0, 0, 0, 73, 74, 5, 114,
    0, 0, 74, 75, 5, 101, 0, 0, 75, 76, 5, 116, 0, 0, 76, 77, 5, 117, 0, 0, 77,
    78, 5, 114, 0, 0, 78, 79, 5, 110, 0, 0, 79, 80, 5, 115, 0, 0, 80, 18, 1, 0,
    0, 0, 81, 82, 5, 46, 0, 0, 82, 20, 1, 0, 0, 0, 83, 84, 5, 44, 0, 0, 84, 22,
    1, 0, 0, 0, 85, 86, 5, 58, 0, 0, 86, 24, 1, 0, 0, 0, 87, 91, 7, 0, 0, 0, 88,
    90, 7, 1, 0, 0, 89, 88, 1, 0, 0, 0, 90, 93, 1, 0, 0, 0, 91, 89, 1, 0, 0, 0,
    91, 92, 1, 0, 0, 0, 92, 26, 1, 0, 0, 0, 93, 91, 1, 0, 0, 0, 94, 95, 5, 61,
    0, 0, 95, 105, 5, 62, 0, 0, 96, 97, 5, 61, 0, 0, 97, 98, 5, 47, 0, 0, 98,
    105, 5, 62, 0, 0, 99, 100, 5, 126, 0, 0, 100, 105, 5, 62, 0, 0, 101, 102, 5,
    126, 0, 0, 102, 103, 5, 47, 0, 0, 103, 105, 5, 62, 0, 0, 104, 94, 1, 0, 0,
    0, 104, 96, 1, 0, 0, 0, 104, 99, 1, 0, 0, 0, 104, 101, 1, 0, 0, 0, 105, 28,
    1, 0, 0, 0, 106, 143, 7, 2, 0, 0, 107, 108, 5, 61, 0, 0, 108, 143, 5, 61, 0,
    0, 109, 110, 5, 33, 0, 0, 110, 143, 5, 61, 0, 0, 111, 143, 7, 3, 0, 0, 112,
    113, 5, 60, 0, 0, 113, 143, 5, 61, 0, 0, 114, 115, 5, 62, 0, 0, 115, 143, 5,
    61, 0, 0, 116, 117, 5, 38, 0, 0, 117, 143, 5, 38, 0, 0, 118, 119, 5, 124, 0,
    0, 119, 143, 5, 124, 0, 0, 120, 121, 5, 43, 0, 0, 121, 143, 5, 43, 0, 0,
    122, 123, 5, 45, 0, 0, 123, 143, 5, 45, 0, 0, 124, 125, 5, 45, 0, 0, 125,
    143, 5, 61, 0, 0, 126, 127, 5, 43, 0, 0, 127, 143, 5, 61, 0, 0, 128, 129, 5,
    42, 0, 0, 129, 143, 5, 61, 0, 0, 130, 131, 5, 47, 0, 0, 131, 143, 5, 61, 0,
    0, 132, 133, 5, 37, 0, 0, 133, 143, 5, 61, 0, 0, 134, 135, 5, 62, 0, 0, 135,
    143, 5, 62, 0, 0, 136, 137, 5, 62, 0, 0, 137, 138, 5, 62, 0, 0, 138, 143, 5,
    62, 0, 0, 139, 140, 5, 60, 0, 0, 140, 143, 5, 60, 0, 0, 141, 143, 7, 4, 0,
    0, 142, 106, 1, 0, 0, 0, 142, 107, 1, 0, 0, 0, 142, 109, 1, 0, 0, 0, 142,
    111, 1, 0, 0, 0, 142, 112, 1, 0, 0, 0, 142, 114, 1, 0, 0, 0, 142, 116, 1, 0,
    0, 0, 142, 118, 1, 0, 0, 0, 142, 120, 1, 0, 0, 0, 142, 122, 1, 0, 0, 0, 142,
    124, 1, 0, 0, 0, 142, 126, 1, 0, 0, 0, 142, 128, 1, 0, 0, 0, 142, 130, 1, 0,
    0, 0, 142, 132, 1, 0, 0, 0, 142, 134, 1, 0, 0, 0, 142, 136, 1, 0, 0, 0, 142,
    139, 1, 0, 0, 0, 142, 141, 1, 0, 0, 0, 143, 30, 1, 0, 0, 0, 144, 145, 7, 5,
    0, 0, 145, 32, 1, 0, 0, 0, 146, 148, 7, 6, 0, 0, 147, 146, 1, 0, 0, 0, 148,
    149, 1, 0, 0, 0, 149, 147, 1, 0, 0, 0, 149, 150, 1, 0, 0, 0, 150, 168, 1, 0,
    0, 0, 151, 152, 5, 48, 0, 0, 152, 154, 7, 7, 0, 0, 153, 155, 7, 8, 0, 0,
    154, 153, 1, 0, 0, 0, 155, 156, 1, 0, 0, 0, 156, 154, 1, 0, 0, 0, 156, 157,
    1, 0, 0, 0, 157, 168, 1, 0, 0, 0, 158, 160, 5, 48, 0, 0, 159, 161, 7, 9, 0,
    0, 160, 159, 1, 0, 0, 0, 160, 161, 1, 0, 0, 0, 161, 163, 1, 0, 0, 0, 162,
    164, 7, 10, 0, 0, 163, 162, 1, 0, 0, 0, 164, 165, 1, 0, 0, 0, 165, 163, 1,
    0, 0, 0, 165, 166, 1, 0, 0, 0, 166, 168, 1, 0, 0, 0, 167, 147, 1, 0, 0, 0,
    167, 151, 1, 0, 0, 0, 167, 158, 1, 0, 0, 0, 168, 34, 1, 0, 0, 0, 169, 171,
    7, 11, 0, 0, 170, 169, 1, 0, 0, 0, 171, 172, 1, 0, 0, 0, 172, 170, 1, 0, 0,
    0, 172, 173, 1, 0, 0, 0, 173, 174, 1, 0, 0, 0, 174, 175, 6, 17, 0, 0, 175,
    36, 1, 0, 0, 0, 10, 0, 91, 104, 142, 149, 156, 160, 165, 167, 172, 1, 6, 0,
    0,
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
