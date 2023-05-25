import { ErrorListener, Recognizer, Token } from 'antlr4';

export class TestErrorListener extends ErrorListener<Token> {
  constructor(private readonly handler: (msg: string) => void) {
    super();
  }

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
