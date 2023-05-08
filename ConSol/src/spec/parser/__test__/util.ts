import SpecParser from '../SpecParser.js';
import {
  CharStream,
  CommonTokenStream,
  ErrorListener,
  Recognizer,
  Token,
} from 'antlr4';
import SpecLexer from '../SpecLexer.js';

export const createParser = (specStr: string): SpecParser => {
  const chars = new CharStream(specStr);
  const lexer = new SpecLexer(chars);
  const tokens = new CommonTokenStream(lexer);
  return new SpecParser(tokens);
};

export class TestErrorListener implements ErrorListener<Token> {
  constructor(private readonly handler: (msg: string) => void) {}

  syntaxError(
    recognizer: Recognizer<Token>,
    offendingSymbol: Token,
    line: number,
    charPositionInLine: number,
    msg: string,
  ) {
    this.handler(msg);
  }
}
