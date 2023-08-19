import {
  ASTContext,
  ASTNode,
  ASTNodeFactory,
  ASTReader,
  ASTWriter,
  Block,
  compileSourceString,
  DefaultASTWriterMapping,
  LatestCompilerVersion,
  LiteralKind,
  PrettyFormatter,
} from 'solc-typed-ast';
import { ConSolFactory } from '../ConSolFactory';

describe('val spec transformer', () => {
  const template = `
    pragma solidity ^0.8.0;
    contract C {
      function f() public {
      }
    }
  `;
  let ctx: ASTContext;
  let body: Block;
  let nodeFactory: ASTNodeFactory;
  let scope: number;
  beforeEach(async () => {
    const result = await compileSourceString('template.sol', template, 'auto');
    const reader = new ASTReader();
    const sourceUnits = reader.read(result.data);
    body = sourceUnits[0].vContracts[0].vFunctions[0].vBody as Block;
    ctx = body.context as ASTContext;
    nodeFactory = new ASTNodeFactory(body.context);
    scope = sourceUnits[0].vContracts[0].scope;
  });
  describe('makeRequireStmt', () => {
    it('should build an always true require statement', async () => {
      const cond = nodeFactory.makeLiteral('boolean', LiteralKind.Bool, '0x1', 'true');
      const csFactory = new ConSolFactory(nodeFactory, scope);
      const stmt = csFactory.makeRequireStmt(cond, 'error message');
      const source = genSource(stmt)[0];
      expect(source).toEqual(`require(true, "error message");`);
    });
  });
});

function genSource(...nodes: ASTNode[]): string[] {
  const formatter = new PrettyFormatter(4, 0);
  const writer = new ASTWriter(DefaultASTWriterMapping, formatter, LatestCompilerVersion);
  return nodes.map((node) => writer.write(node));
}
