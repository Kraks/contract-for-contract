import { ErrorListener, Recognizer, Token } from 'antlr4';
import { ASTNode, PrettyFormatter, ASTWriter, DefaultASTWriterMapping, LatestCompilerVersion } from 'solc-typed-ast';

export function genSource(...nodes: ASTNode[]): string[] {
  const formatter = new PrettyFormatter(4, 0);
  const writer = new ASTWriter(DefaultASTWriterMapping, formatter, LatestCompilerVersion);
  return nodes.map((node) => writer.write(node));
}

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
