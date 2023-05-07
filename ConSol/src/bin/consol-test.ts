#!/usr/bin/env node

import { CharStream, CommonTokenStream } from 'antlr4';
import SpecLexer from '../lib/spec-parser/SpecLexer.js';
import SpecParser from '../lib/spec-parser/SpecParser.js';
import { isNumber } from '../index';

function main() {
  const input = '3+4\n';
  console.log(input);
  const chars = new CharStream(input); // replace this with a FileStream as required
  const lexer = new SpecLexer(chars);
  const tokens = new CommonTokenStream(lexer);
  const parser = new SpecParser(tokens);
  const tree = parser.spec();
  console.log(tree);
}

main();
