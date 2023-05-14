#!/usr/bin/env ts-node-esm

import { CharStream, CommonTokenStream } from 'antlr4';
import SpecLexer from '../src/spec/parser/SpecLexer.js';
import SpecParser from '../src/spec/parser/SpecParser.js';

function main() {
  const input = '{ f(addr) where { addr{value: v, gas: g}(arg) returns (res, data) requires {v > 0} ensures {res == true} } }';
  console.log(input);
  const chars = new CharStream(input); // replace this with a FileStream as required
  const lexer = new SpecLexer(chars);
  const tokens = new CommonTokenStream(lexer);
  const parser = new SpecParser(tokens);
  const tree = parser.spec();
  console.log(tree);
}

main();
