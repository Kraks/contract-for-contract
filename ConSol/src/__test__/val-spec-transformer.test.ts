import { ASTContext, ASTReader, compileSourceString, LiteralKind } from 'solc-typed-ast';
import { genSource } from './util';
import { ConSolFactory } from '../ConSolFactory';
import { checkConSolOutput } from '../ConSolUtils';

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

  let factory: ConSolFactory;
  let scope: number;

  beforeEach(async () => {
    const result = await compileSourceString('template.sol', template, 'auto');
    const reader = new ASTReader();
    const sourceUnits = reader.read(result.data);
    const contract = sourceUnits[0].vContracts[0];
    const ctx = (contract.context as ASTContext) || new ASTContext();
    factory = new ConSolFactory(ctx, contract.scope);
    scope = sourceUnits[0].vContracts[0].scope;
  });

  it('should build an always true require statement', async () => {
    const cond = factory.makeLiteral('boolean', LiteralKind.Bool, '0x1', 'true');
    const stmt = factory.makeRequireStmt(cond, 'error message');
    const source = genSource(stmt)[0];
    expect(source).toEqual(`require(true, "error message");`);
  });
});
