#!/usr/bin/env ts-node-esm

import { CSSpecParse, CSSpecVisitor } from '../src/spec/index.js';
import * as util from 'util';

function parse(specStr: string) {
  const visitor = new CSSpecVisitor<string>((s) => s);
  console.log(specStr);
  console.log(CSSpecParse<string>(specStr, visitor));
}

function main() {
  // parse('{x | 1 + 2}');
  //parse('f(x, y, z) returns (f1) => g{value, gas, gas_}() /\\ 1 + 2');
  // parse('{ (x) | 1 + 2}');
  // parse('{ (x, y) | 1 + 2}');
  // parse('{ {value: 5} (x, y) | 1 + 2}');

  // new syntax:
  //parse('{ f(x) => g(x) }');
  //parse('{ f{value: v, dict: d}(x) => g(x) }')
  // parse('{ f{value: v, dict: d}(x) => g(x) returns y }');
  parse(
    '{foo {value:v1, gas:g} (argfun, x, argfun2) returns (retFun)requires {xxx} ensures {yyy} where {argfun() ensures{aaa}} {retFun() ensures{bbb}} {argfun2(xxx) requires{ddd}}}',
  );
}

main();
