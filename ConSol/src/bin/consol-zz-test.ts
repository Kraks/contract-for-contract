#!/usr/bin/env node

import { ErrorListener, CharStream, CommonTokenStream } from "antlr4";
import SpecLexer from "../lib/spec-parser/SpecLexer.js";
import SpecParser from "../lib/spec-parser/SpecParser.js";
import { isNumber } from "../index.js";
import * as util from "util";

function parse(specStr: string) {
  console.log(specStr);
  const chars = new CharStream(specStr); // replace this with a FileStream as required
  const lexer = new SpecLexer(chars);
  const tokens = new CommonTokenStream(lexer);
  const parser = new SpecParser(tokens);
  const tree = parser.spec();
  // console.log(util.inspect(tree, true, 4));
  console.log(tree);
}

function main() {
  parse("{x | 1 + 2}");
  parse("{ (x) | 1 + 2}");
  parse("{ (x, y) | 1 + 2}");
  parse("{ {value: 5} (x, y) | 1 + 2}");
}

main();
