import { FunctionDefinition, ASTNode } from 'solc-typed-ast';

import { CSSpecParse, CSSpecVisitor, CSSpec } from './spec/index.js';

export const SPEC_PREFIX = '@custom:consol';

export function isConSolSpec(doc: string): boolean {
  return doc.startsWith(SPEC_PREFIX);
}

export function parseConSolSpec(doc: string): CSSpec<string> {
  const specStr = doc.substring(SPEC_PREFIX.length).trim();
  const visitor = new CSSpecVisitor<string>((s) => s);
  const spec = CSSpecParse<string>(specStr, visitor);
  return spec;
}

export function isConstructor(node: ASTNode): node is FunctionDefinition {
  return (
    node instanceof FunctionDefinition &&
    (node as FunctionDefinition).isConstructor
  );
}

export function extractFunName(node: ASTNode): string {
  if (isConstructor(node)) return 'constructor';
  return node.raw.name;
}
