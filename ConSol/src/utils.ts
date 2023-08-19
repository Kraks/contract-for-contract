import {
  ASTContext,
  ASTNodeFactory,
  FunctionDefinition,
  LiteralKind,
  VariableDeclaration,
  ASTNode,
  FunctionCallKind,
  ExpressionStatement,
  Expression,
  assert,
} from 'solc-typed-ast';

import { ValSpec } from './spec/index.js';
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

// Note(GW): this function changes `decls` in-place
export function attachNames(names: string[], decls: VariableDeclaration[]): VariableDeclaration[] {
  assert(names.length === decls.length, 'Return Variable length wrong');
  names.forEach((name, i) => {
    decls[i].name = name;
  });
  return decls;
}

export function preCheckFunName(f: string): string {
  return '_' + f + 'Pre';
}

export function postCheckFunName(f: string): string {
  return '_' + f + 'Post';
}

export function uncheckedFunName(f: string): string {
  return f + '_original';
}

export function properAddrName<T>(addr: string, member: string): string {
  return addr + '_' + member;
}

export function extractRawAddr<T>(spec: ValSpec<T>): string {
  // Note(GW): spec.call.addr is optional by the definition of garmmar.
  // If it is undefined, then we are handling an address spec that only has a single callee.
  // In this case, the funName field is actually the variable name for the address,
  // and we synthesis the default callable member name (i.e. call);
  // Otherwise, we are handling member access call (e.g. addr.send).
  // FIXME(GW): parser error for the "otherwise" case
  if (spec.call.addr === undefined) return spec.call.funName;
  else return spec.call.addr;
}

export function extractAddrMember<T>(spec: ValSpec<T>): string {
  if (spec.call.addr === undefined) return 'call';
  else return spec.call.funName;
}
export function needAbiEncoding(member: string): boolean {
  return member === 'call' || member === 'delegatecall' || member === 'staticcall';
}
