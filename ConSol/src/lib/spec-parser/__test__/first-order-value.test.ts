import {
  CharStream,
  CommonTokenStream,
  ErrorListener,
  Recognizer,
  Token,
} from 'antlr4';
import SpecLexer from '../SpecLexer.js';
import SpecParser from '../SpecParser.js';
import { jest } from '@jest/globals';

class TestErrorListener implements ErrorListener<Token> {
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

describe('first-order value spec', () => {
  describe('Parser', () => {
    const specs = [
      '{x | 1 + 2}',
      '{ (x) | 1 + 2}',
      '{ (x, y) | 1 + 2}',
      // '{ {value: 5} (x, y) | 1 + 2}', // syntax error: mismatched input '5' expecting IDENT
    ];
    specs.forEach((specStr) =>
      it(`should parse ${specStr}`, () => {
        const chars = new CharStream(specStr); // replace this with a FileStream as required
        const lexer = new SpecLexer(chars);
        const tokens = new CommonTokenStream(lexer);
        const parser = new SpecParser(tokens);
        const syntaxError = jest.fn();
        parser.addErrorListener(new TestErrorListener(syntaxError));
        const tree = parser.spec();
        expect(syntaxError).not.toHaveBeenCalled();
        expect(tree).toBeDefined();
      }),
    );
  });
});
