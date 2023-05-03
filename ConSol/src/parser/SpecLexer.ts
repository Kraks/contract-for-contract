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
	public static readonly IDENT = 8;
	public static readonly OP = 9;
	public static readonly QUOTE = 10;
	public static readonly INT = 11;
	public static readonly WS = 12;
	public static readonly EOF = Token.EOF;

	public static readonly channelNames: string[] = [ "DEFAULT_TOKEN_CHANNEL", "HIDDEN" ];
	public static readonly literalNames: string[] = [ null, "'{'", "'|'", "'}'", 
                                                   "'('", "')'", "','", 
                                                   "':'" ];
	public static readonly symbolicNames: string[] = [ null, null, null, null, 
                                                    null, null, null, null, 
                                                    "IDENT", "OP", "QUOTE", 
                                                    "INT", "WS" ];
	public static readonly modeNames: string[] = [ "DEFAULT_MODE", ];

	public static readonly ruleNames: string[] = [
		"T__0", "T__1", "T__2", "T__3", "T__4", "T__5", "T__6", "IDENT", "OP", 
		"QUOTE", "INT", "WS",
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

	public static readonly _serializedATN: number[] = [4,0,12,116,6,-1,2,0,
	7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,6,2,7,7,7,2,8,7,8,2,9,
	7,9,2,10,7,10,2,11,7,11,1,0,1,0,1,1,1,1,1,2,1,2,1,3,1,3,1,4,1,4,1,5,1,5,
	1,6,1,6,1,7,1,7,5,7,42,8,7,10,7,12,7,45,9,7,1,8,1,8,1,8,1,8,1,8,1,8,1,8,
	1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,
	1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,1,8,3,8,83,8,8,1,9,1,9,1,10,4,10,
	88,8,10,11,10,12,10,89,1,10,1,10,1,10,4,10,95,8,10,11,10,12,10,96,1,10,
	1,10,3,10,101,8,10,1,10,4,10,104,8,10,11,10,12,10,105,3,10,108,8,10,1,11,
	4,11,111,8,11,11,11,12,11,112,1,11,1,11,0,0,12,1,1,3,2,5,3,7,4,9,5,11,6,
	13,7,15,8,17,9,19,10,21,11,23,12,1,0,11,3,0,65,90,95,95,97,122,4,0,48,57,
	65,90,95,95,97,122,10,0,33,33,37,38,42,43,45,45,47,47,58,58,63,63,94,94,
	124,124,126,126,2,0,60,60,62,62,2,0,34,34,39,39,1,0,48,57,2,0,88,88,120,
	120,3,0,48,57,65,70,97,102,2,0,79,79,111,111,1,0,48,55,3,0,9,10,13,13,32,
	32,141,0,1,1,0,0,0,0,3,1,0,0,0,0,5,1,0,0,0,0,7,1,0,0,0,0,9,1,0,0,0,0,11,
	1,0,0,0,0,13,1,0,0,0,0,15,1,0,0,0,0,17,1,0,0,0,0,19,1,0,0,0,0,21,1,0,0,
	0,0,23,1,0,0,0,1,25,1,0,0,0,3,27,1,0,0,0,5,29,1,0,0,0,7,31,1,0,0,0,9,33,
	1,0,0,0,11,35,1,0,0,0,13,37,1,0,0,0,15,39,1,0,0,0,17,82,1,0,0,0,19,84,1,
	0,0,0,21,107,1,0,0,0,23,110,1,0,0,0,25,26,5,123,0,0,26,2,1,0,0,0,27,28,
	5,124,0,0,28,4,1,0,0,0,29,30,5,125,0,0,30,6,1,0,0,0,31,32,5,40,0,0,32,8,
	1,0,0,0,33,34,5,41,0,0,34,10,1,0,0,0,35,36,5,44,0,0,36,12,1,0,0,0,37,38,
	5,58,0,0,38,14,1,0,0,0,39,43,7,0,0,0,40,42,7,1,0,0,41,40,1,0,0,0,42,45,
	1,0,0,0,43,41,1,0,0,0,43,44,1,0,0,0,44,16,1,0,0,0,45,43,1,0,0,0,46,83,7,
	2,0,0,47,48,5,61,0,0,48,83,5,61,0,0,49,50,5,33,0,0,50,83,5,61,0,0,51,83,
	7,3,0,0,52,53,5,60,0,0,53,83,5,61,0,0,54,55,5,62,0,0,55,83,5,61,0,0,56,
	57,5,38,0,0,57,83,5,38,0,0,58,59,5,124,0,0,59,83,5,124,0,0,60,61,5,43,0,
	0,61,83,5,43,0,0,62,63,5,45,0,0,63,83,5,45,0,0,64,65,5,45,0,0,65,83,5,61,
	0,0,66,67,5,43,0,0,67,83,5,61,0,0,68,69,5,42,0,0,69,83,5,61,0,0,70,71,5,
	47,0,0,71,83,5,61,0,0,72,73,5,37,0,0,73,83,5,61,0,0,74,75,5,62,0,0,75,83,
	5,62,0,0,76,77,5,62,0,0,77,78,5,62,0,0,78,83,5,62,0,0,79,80,5,60,0,0,80,
	83,5,60,0,0,81,83,2,40,41,0,82,46,1,0,0,0,82,47,1,0,0,0,82,49,1,0,0,0,82,
	51,1,0,0,0,82,52,1,0,0,0,82,54,1,0,0,0,82,56,1,0,0,0,82,58,1,0,0,0,82,60,
	1,0,0,0,82,62,1,0,0,0,82,64,1,0,0,0,82,66,1,0,0,0,82,68,1,0,0,0,82,70,1,
	0,0,0,82,72,1,0,0,0,82,74,1,0,0,0,82,76,1,0,0,0,82,79,1,0,0,0,82,81,1,0,
	0,0,83,18,1,0,0,0,84,85,7,4,0,0,85,20,1,0,0,0,86,88,7,5,0,0,87,86,1,0,0,
	0,88,89,1,0,0,0,89,87,1,0,0,0,89,90,1,0,0,0,90,108,1,0,0,0,91,92,5,48,0,
	0,92,94,7,6,0,0,93,95,7,7,0,0,94,93,1,0,0,0,95,96,1,0,0,0,96,94,1,0,0,0,
	96,97,1,0,0,0,97,108,1,0,0,0,98,100,5,48,0,0,99,101,7,8,0,0,100,99,1,0,
	0,0,100,101,1,0,0,0,101,103,1,0,0,0,102,104,7,9,0,0,103,102,1,0,0,0,104,
	105,1,0,0,0,105,103,1,0,0,0,105,106,1,0,0,0,106,108,1,0,0,0,107,87,1,0,
	0,0,107,91,1,0,0,0,107,98,1,0,0,0,108,22,1,0,0,0,109,111,7,10,0,0,110,109,
	1,0,0,0,111,112,1,0,0,0,112,110,1,0,0,0,112,113,1,0,0,0,113,114,1,0,0,0,
	114,115,6,11,0,0,115,24,1,0,0,0,9,0,43,82,89,96,100,105,107,112,1,6,0,0];

	private static __ATN: ATN;
	public static get _ATN(): ATN {
		if (!SpecLexer.__ATN) {
			SpecLexer.__ATN = new ATNDeserializer().deserialize(SpecLexer._serializedATN);
		}

		return SpecLexer.__ATN;
	}


	static DecisionsToDFA = SpecLexer._ATN.decisionToState.map( (ds: DecisionState, index: number) => new DFA(ds, index) );
}