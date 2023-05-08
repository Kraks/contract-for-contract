#!/usr/bin/env ts-node-esm

import { CharStream, CommonTokenStream } from 'antlr4';
import SpecLexer from '../src/spec/parser/SpecLexer.js';
import SpecParser from '../src/spec/parser/SpecParser.js';

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
