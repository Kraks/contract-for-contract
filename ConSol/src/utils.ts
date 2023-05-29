import {
  ASTNodeFactory,
  FunctionDefinition,
  VariableDeclaration,
  Identifier,
  ASTNode,
  TypeName,
  assert,
} from 'solc-typed-ast';

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
  return node instanceof FunctionDefinition && (node as FunctionDefinition).isConstructor;
}

export function extractFunName(node: ASTNode): string {
  if (isConstructor(node)) return 'constructor';
  return node.raw.name;
}

export function copyNodes<T extends ASTNode>(factory: ASTNodeFactory, nodes: Array<T>): Array<T> {
  const newNodes: Array<T> = [];
  nodes.forEach((node, i) => {
    newNodes.push(factory.copy(node));
  });
  return newNodes;
}

// Note(GW): this function changes `decls` in-place
export function attachNames(names: string[], decls: VariableDeclaration[]): VariableDeclaration[] {
  assert(names.length === decls.length, 'Return Variable length wrong');
  names.forEach((name, i) => {
    decls[i].name = name;
  });
  return decls;
}

export function makeIdFromVarDecl(factory: ASTNodeFactory, vd: VariableDeclaration): Identifier {
  return factory.makeIdentifierFor(vd);
}

export function makeIdsFromVarDecls(factory: ASTNodeFactory, vds: VariableDeclaration[]): Identifier[] {
  return vds.map((vd) => makeIdFromVarDecl(factory, vd));
}

export function makeNewParams(
  factory: ASTNodeFactory,
  names: string[],
  decls: VariableDeclaration[],
): VariableDeclaration[] {
  const params = copyNodes(factory, decls);
  attachNames(names, params);
  return params;
}

export function strToTypeName(factory: ASTNodeFactory, str: string): TypeName {
  if (str === 'bytes') return factory.makeElementaryTypeName('', 'bytes memory');
  if (str === 'string') return factory.makeElementaryTypeName('', 'string memory');
  // TODO(GW): other types with storage modifier
  return factory.makeElementaryTypeName('', str);
}
