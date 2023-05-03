#!/usr/bin/env node

import { ErrorListener, CharStream, CommonTokenStream, Recognizer, RecognitionException, Token }  from 'antlr4';
import SpecLexer from '../parser/SpecLexer.js';
import SpecParser from '../parser/SpecParser.js';
import { isNumber } from '../index.js';
import * as util from 'util'


class ConSolParseError extends Error {
  constructor(public line: number, public charPositionInLine: number, message: string) {
    super(message);
    this.name = 'ConSolParseError';
  }
}



class ConSolErrorListener implements ErrorListener <Token> {
    syntaxError(
      recognizer: Recognizer<Token>,
      offendingSymbol: Token | undefined,
      line: number,
      charPositionInLine: number,
      msg: string,
      e: RecognitionException | undefined
    ): void {
      // console.error(`Error at line ${line}:${charPositionInLine} - ${msg}`);
      throw new ConSolParseError(line, charPositionInLine, `Error at line ${line}:${charPositionInLine} - ${msg}`);
    }
  
  }


function parse(specStr: string) {
  const myConSolErrorListener = new ConSolErrorListener();

  try {
    console.log(specStr)
    const chars = new CharStream(specStr); // replace this with a FileStream as required
    const lexer = new SpecLexer(chars);
    const tokens = new CommonTokenStream(lexer);
    const parser = new SpecParser(tokens);
    parser.addErrorListener(myConSolErrorListener);
    const tree = parser.spec();
    // console.log(util.inspect(tree, true, 4));
    // console.log(tree);
  } catch (error) {
    if (error instanceof ConSolParseError) {
      console.error(`Caught ConSolParseError: ${error.message}`);
    } else {
      console.error("other errors");
    }
  }
}

function main() {
  parse("{-=-=x | 1 + 2}");
//   parse("{ (x) | 1 + 2}");
//   parse("{ (x, y) | 1 + 2}");
//   parse("{ {value: 5} (x, y) | 1 + 2}");
}

main();