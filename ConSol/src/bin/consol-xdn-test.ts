#!/usr/bin/env node

import { ErrorListener, CharStream, CommonTokenStream, Recognizer, RecognitionException, Token, ParseTreeWalker}  from 'antlr4';
import SpecLexer from '../parser/SpecLexer.js';
import SpecParser from '../parser/SpecParser.js';

import { isNumber } from '../index.js';
import * as util from 'util'
import SpecListener from '../parser/SpecListener.js';
import {SpecContext} from '../parser/SpecParser.js';
import SpecVisitor from '../parser/SpecVisitor.js';
import {ParserRuleContext, ParseTreeVisitor, RuleNode, TerminalNode, ErrorNode} from "antlr4";

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


class MySpecListener extends SpecListener{
  enterSpec:  (ctx: SpecContext) => void  = (ctx: SpecContext) =>{
    console.log("Enter a spec: ", ctx.getText());
  };
  exitSpec: (ctx: SpecContext) => void  = (ctx: SpecContext) => {
    console.log("Exit a spec");
  };
}


class MySpecVisitor extends SpecVisitor<void> {
  visitChildren(ctx: ParserRuleContext): void {
    if (!ctx || !ctx.children) {
      return;
    }

    ctx.children.forEach((child, index) => {
      if (child instanceof ParserRuleContext) {
        if (child.children && child.children.length !== 0) {
          this.visit(child); // Use the 'visit' method of the visitor class directly
        }
      } else if (child instanceof TerminalNode) {
        console.log("Child", index, "text:", child.getText());
      }
    });
  }


}


function parse(specStr: string) {
  const myConSolErrorListener = new ConSolErrorListener();
  const walker = new MySpecListener(); 
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
    ParseTreeWalker.DEFAULT.walk(walker, tree);
    tree.accept(new MySpecVisitor());
  } catch (error) {
    if (error instanceof ConSolParseError) {
      console.error(`ConSolParseError: ${error.message}`);
    } else {
      console.error("other errors");
    }
  }
}

function main() {
  // vspec
  parse("{x | 1 + 2}");
  parse("{ (x) | 1 + 2}");
  parse("{ (x, y) | 1 + 2}");
  parse("{x | 1 + 2} -> {y | 1 + 2}");
  parse("{ {x:y, a:b} z | 1 + 2}");
  parse("{ {x:y, a:b} (x,y) | 1 + 2}");
}

main();