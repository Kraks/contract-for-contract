import { ASTContext, ASTNodeFactory, ASTReader, Block, compileSourceString, LiteralKind } from 'solc-typed-ast';
import { genSource } from './util';
import { ConSolFactory } from '../ConSolFactory';
import { checkConSolOutput } from '../utils';

describe('end to end tests', () => {
  // TODO: mechanize more tests...
  const programs = ['PreCond.sol', 'PreCond2.sol', 'Lock.sol', 'PostCond.sol'];

  programs.forEach((program) => {
    test(program, async () => {
      const result = await checkConSolOutput(`test/${program}`);
      expect(result).toBe(true);
    });
  });
});

describe('val spec transformer', () => {
  const template = `
    pragma solidity ^0.8.0;
    contract C {
      function f() public {
      }
    }
  `;

  let nodeFactory: ASTNodeFactory;
  let scope: number;

  beforeEach(async () => {
    const result = await compileSourceString('template.sol', template, 'auto');
    const reader = new ASTReader();
    const sourceUnits = reader.read(result.data);
    const body = sourceUnits[0].vContracts[0].vFunctions[0].vBody as Block;
    const ctx = body.context as ASTContext;
    nodeFactory = new ASTNodeFactory(body.context);
    scope = sourceUnits[0].vContracts[0].scope;
  });

  it('should build an always true require statement', async () => {
    const cond = nodeFactory.makeLiteral('boolean', LiteralKind.Bool, '0x1', 'true');
    const csFactory = new ConSolFactory(nodeFactory, scope);
    const stmt = csFactory.makeRequireStmt(cond, 'error message');
    const source = genSource(stmt)[0];
    expect(source).toEqual(`require(true, "error message");`);
  });
});
