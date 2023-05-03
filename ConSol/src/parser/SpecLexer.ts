// @ts-nocheck
// Generated from Spec.g4 by ANTLR 4.12.0
// noinspection ES6UnusedImports,JSUnusedGlobalSymbols,JSUnusedLocalSymbols
import {
	ATN,
	ATNDeserializer,
	CharStream,
	DecisionState, DFA,
	Lexer,
	LexerATNSimulator,
	RuleContext,
	PredictionContextCache,
	Token
} from "antlr4";
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
	public static readonly IDENT = 12;
	public static readonly INT = 13;
	public static readonly WS = 14;
	public static readonly EOF = Token.EOF;

	public static readonly channelNames: string[] = [ "DEFAULT_TOKEN_CHANNEL", "HIDDEN" ];
	public static readonly literalNames: string[] = [ null, "'{'", "','", "'}'", 
                                                   "'|'", "'('", "')'", 
                                                   "':'", "'*'", "'/'", 
                                                   "'+'", "'-'" ];
	public static readonly symbolicNames: string[] = [ null, null, null, null, 
                                                    null, null, null, null, 
                                                    null, null, null, null, 
                                                    "IDENT", "INT", "WS" ];
	public static readonly modeNames: string[] = [ "DEFAULT_MODE", ];

	public static readonly ruleNames: string[] = [
		"T__0", "T__1", "T__2", "T__3", "T__4", "T__5", "T__6", "T__7", "T__8", 
		"T__9", "T__10", "IDENT", "INT", "WS",
	];


	constructor(input: CharStream) {
		super(input);
		this._interp = new LexerATNSimulator(this, SpecLexer._ATN, SpecLexer.DecisionsToDFA, new PredictionContextCache());
	}

	public get grammarFileName(): string { return "Spec.g4"; }

	public get literalNames(): (string | null)[] { return SpecLexer.literalNames; }
	public get symbolicNames(): (string | null)[] { return SpecLexer.symbolicNames; }
	public get ruleNames(): string[] { return SpecLexer.ruleNames; }

	public get serializedATN(): number[] { return SpecLexer._serializedATN; }

	public get channelNames(): string[] { return SpecLexer.channelNames; }

	public get modeNames(): string[] { return SpecLexer.modeNames; }

	public static readonly _serializedATN: number[] = [4,0,14,70,6,-1,2,0,7,
	0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,6,2,7,7,7,2,8,7,8,2,9,7,
	9,2,10,7,10,2,11,7,11,2,12,7,12,2,13,7,13,1,0,1,0,1,1,1,1,1,2,1,2,1,3,1,
	3,1,4,1,4,1,5,1,5,1,6,1,6,1,7,1,7,1,8,1,8,1,9,1,9,1,10,1,10,1,11,1,11,5,
	11,54,8,11,10,11,12,11,57,9,11,1,12,4,12,60,8,12,11,12,12,12,61,1,13,4,
	13,65,8,13,11,13,12,13,66,1,13,1,13,0,0,14,1,1,3,2,5,3,7,4,9,5,11,6,13,
	7,15,8,17,9,19,10,21,11,23,12,25,13,27,14,1,0,4,3,0,65,90,95,95,97,122,
	4,0,48,57,65,90,95,95,97,122,1,0,48,57,3,0,9,10,13,13,32,32,72,0,1,1,0,
	0,0,0,3,1,0,0,0,0,5,1,0,0,0,0,7,1,0,0,0,0,9,1,0,0,0,0,11,1,0,0,0,0,13,1,
	0,0,0,0,15,1,0,0,0,0,17,1,0,0,0,0,19,1,0,0,0,0,21,1,0,0,0,0,23,1,0,0,0,
	0,25,1,0,0,0,0,27,1,0,0,0,1,29,1,0,0,0,3,31,1,0,0,0,5,33,1,0,0,0,7,35,1,
	0,0,0,9,37,1,0,0,0,11,39,1,0,0,0,13,41,1,0,0,0,15,43,1,0,0,0,17,45,1,0,
	0,0,19,47,1,0,0,0,21,49,1,0,0,0,23,51,1,0,0,0,25,59,1,0,0,0,27,64,1,0,0,
	0,29,30,5,123,0,0,30,2,1,0,0,0,31,32,5,44,0,0,32,4,1,0,0,0,33,34,5,125,
	0,0,34,6,1,0,0,0,35,36,5,124,0,0,36,8,1,0,0,0,37,38,5,40,0,0,38,10,1,0,
	0,0,39,40,5,41,0,0,40,12,1,0,0,0,41,42,5,58,0,0,42,14,1,0,0,0,43,44,5,42,
	0,0,44,16,1,0,0,0,45,46,5,47,0,0,46,18,1,0,0,0,47,48,5,43,0,0,48,20,1,0,
	0,0,49,50,5,45,0,0,50,22,1,0,0,0,51,55,7,0,0,0,52,54,7,1,0,0,53,52,1,0,
	0,0,54,57,1,0,0,0,55,53,1,0,0,0,55,56,1,0,0,0,56,24,1,0,0,0,57,55,1,0,0,
	0,58,60,7,2,0,0,59,58,1,0,0,0,60,61,1,0,0,0,61,59,1,0,0,0,61,62,1,0,0,0,
	62,26,1,0,0,0,63,65,7,3,0,0,64,63,1,0,0,0,65,66,1,0,0,0,66,64,1,0,0,0,66,
	67,1,0,0,0,67,68,1,0,0,0,68,69,6,13,0,0,69,28,1,0,0,0,4,0,55,61,66,1,6,
	0,0];

	private static __ATN: ATN;
	public static get _ATN(): ATN {
		if (!SpecLexer.__ATN) {
			SpecLexer.__ATN = new ATNDeserializer().deserialize(SpecLexer._serializedATN);
		}

		return SpecLexer.__ATN;
	}


	static DecisionsToDFA = SpecLexer._ATN.decisionToState.map( (ds: DecisionState, index: number) => new DFA(ds, index) );
}