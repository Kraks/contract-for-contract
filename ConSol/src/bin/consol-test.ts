#!/usr/bin/env node

import { CharStream, CommonTokenStream }  from 'antlr4';
import SpecLexer from '../parser/SpecLexer.js';
import SpecParser from '../parser/SpecParser.js';
import { isNumber } from '../index';

function main() {
  const input = "3+4\n"
  console.log(input)
  const chars = new CharStream(input); // replace this with a FileStream as required
  const lexer = new SpecLexer(chars);
  const tokens = new CommonTokenStream(lexer);
  const parser = new SpecParser(tokens);
  const tree = parser.prog();
  console.log(tree);
}

main();
