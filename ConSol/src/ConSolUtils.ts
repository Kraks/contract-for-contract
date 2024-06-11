import {
  FunctionDefinition,
  ASTNode,
  compileSol,
  CompileResult,
  ASTReader,
  PrettyFormatter,
  ASTWriter,
  DefaultASTWriterMapping,
  LatestCompilerVersion,
  ContractDefinition,
  ASTContext,
} from 'solc-typed-ast';
import { ValSpec } from './spec/index.js';
import { CSSpecParse, CSSpecVisitor, CSSpec } from './spec/index.js';

import * as fs from 'fs';
import { ConSolTransformer } from './ConSolTransformer.js';
import { ConSolFactory } from './ConSolFactory.js';
import {
  setCustomError,
  disableCustomError,
  setSourceUnits,
  setIncludeDevSpec,
  disableIncludeDevSpec,
} from './Global.js';

export const SPEC_PREFIX = '@custom:consol';
const DEV_PREFIX = '@dev';
export const GUARD_ADDR_TYPE = 'uint256';
export const PRE_CHECK_FUN = '_pre';
export const POST_CHECK_FUN = '_post';
export const ORG_CHECK_FUN = '_original';
export const DISPATCH_PREFIX = "_dispatch";

export function toBeImplemented(): never {
  console.error('To be implemented');
  process.exit(-1);
}

export function trimSpec(doc: string): string {
  if (doc.startsWith(SPEC_PREFIX)) {
    return doc.substring(SPEC_PREFIX.length).trim();
  } else if (doc.startsWith(DEV_PREFIX)) {
    return doc.substring(DEV_PREFIX.length).trim();
  } else {
    return '';
  }
}

export function parseConSolSpec(doc: string): CSSpec<string> {
  const specStr = trimSpec(doc);
  const visitor = new CSSpecVisitor<string>((s) => s);
  const spec = CSSpecParse<string>(specStr, visitor);
  return spec;
}

export function compareFiles(file1Path: string, file2Path: string): boolean {
  try {
    const content1 = fs.readFileSync(file1Path, 'utf-8').replace(/[\s\r\n]+$/, '');
    const content2 = fs.readFileSync(file2Path, 'utf-8').replace(/[\s\r\n]+$/, '');
    return content1 === content2;
  } catch (error) {
    console.error('Error reading files:', error);
    return false;
  }
}

export async function checkConSolOutput(file: string): Promise<boolean> {
  const expected = file.replace('.sol', '_expected.sol');
  const output = file.replace('.sol', '_out.sol');
  await ConSolCompile(file, output);
  return compareFiles(expected, output);
}

function convertResultToPlainObject(result: CompileResult): Record<string, unknown> {
  return {
    ...result,
    files: Object.fromEntries(result.files),
    resolvedFileNames: Object.fromEntries(result.resolvedFileNames),
    inferredRemappings: Object.fromEntries(result.inferredRemappings),
  };
}

export async function ConSolCompile(
  inputFile: string,
  outputFile: string,
  outputJson?: string,
  useDev?: boolean,
  useCustomError?: boolean,
): Promise<void> {
  console.log(`inputFile: ${inputFile}`);
  const compileResult = await compileSol(inputFile, 'auto');
  // console.log(compileResult);
  // console.log(compileResult.data.sources[`${filename}.sol`].ast.nodes[1].nodes);
  console.log('Used compiler version: ' + compileResult.compilerVersion);

  // dump ast to json file
  if (outputJson) {
    fs.writeFileSync(outputJson, JSON.stringify(convertResultToPlainObject(compileResult), null, 2));
  }

  // convert to typed ast
  const reader = new ASTReader();
  const sourceUnits = reader.read(compileResult.data);
  setSourceUnits(sourceUnits);

  // Not generating custom error message (must used for Solidity <= 0.8.4)
  if (useCustomError) setCustomError();
  else disableCustomError();

  // Allowing using @dev prefix for specifications since some legacy Solidity code does not support custom doc string.
  // For the following attacks spec, we disable the @dev prefix:
  //   invalid-signature-verification-AzukiDAO-69K
  //   arbitrary-external-call-dexible-1.5M
  //   lack-of-validation-Miner-466K
  if (useDev) setIncludeDevSpec();
  else disableIncludeDevSpec();

  sourceUnits.forEach((sourceUnit) => {
    const ifs: Array<ContractDefinition> = sourceUnit.vContracts.filter((contract) => contract.kind === 'interface');

    let hasConSolSpec = false;
    sourceUnit.vContracts.forEach((contract) => {
      if (contract.kind === 'interface') return;
      console.log(`Processing ${contract.kind} ${contract.name}.`);
      const factory = new ConSolFactory(contract.context || new ASTContext(), contract.scope);
      const contractTransformer = new ConSolTransformer(factory, contract, ifs);
      hasConSolSpec = contractTransformer.process() || hasConSolSpec;
    });

    if (!hasConSolSpec) {
      console.log(`No ConSol spec found in current file ${sourceUnit.raw.absolutePath}. Skip.`);
      return;
    }

    // reify the ast back to source code
    const formatter = new PrettyFormatter(4, 0);
    const writer = new ASTWriter(
      DefaultASTWriterMapping,
      formatter,
      compileResult.compilerVersion ? compileResult.compilerVersion : LatestCompilerVersion,
    );

    console.log('Processed ' + sourceUnit.absolutePath);
    const outFileContent = writer.write(sourceUnit);
    try {
      // Use the writeFile method to save the content to a file
      fs.writeFileSync(outputFile, outFileContent);
      console.log(`Compiled to ${outputFile} successfully`);
    } catch (error) {
      console.error(`Error saving file ${outputFile}: ${error}`);
    }
  });
}

export function isConSolSpec(doc: string): boolean {
  if (typeof doc !== 'string') {
    return false;
  }
  return doc.startsWith(SPEC_PREFIX) || (INCLUDE_DEV_SPEC && doc.startsWith(DEV_PREFIX));
}

export function isConstructor(node: ASTNode): node is FunctionDefinition {
  return node instanceof FunctionDefinition && (node as FunctionDefinition).isConstructor;
}

export function extractFunName(node: ASTNode): string {
  if (isConstructor(node)) return 'constructor';
  return node.raw.name;
}

export function preCheckFunName(f: string): string {
  return '_' + f + PRE_CHECK_FUN;
}

export function postCheckFunName(f: string): string {
  return '_' + f + POST_CHECK_FUN;
}

export function uncheckedFunName(f: string): string {
  return f + ORG_CHECK_FUN;
}

export function guardedFunName(f: string): string {
  return f + '_guard';
}

export function properAddrName(addr: string, member: string): string {
  return addr + '_' + member;
}

export function extractRawAddr<T>(spec: ValSpec<T>): string {
  // Note(GW): spec.call.addr is optional by the definition of garmmar.
  // If it is undefined, then we are handling an address spec that only has a single callee.
  // In this case, the funName field is actually the variable name for the address,
  // and we synthesis the default callable member name (i.e. call);
  // Otherwise, we are handling member access call (e.g. addr.send).
  // FIXME(GW): parser error for the "otherwise" case
  if (spec.call.tgt.addr === undefined) return spec.call.tgt.func;
  else return spec.call.tgt.addr;
}

export function extractAddrMember<T>(spec: ValSpec<T>): string {
  if (spec.call.tgt.addr === undefined) return 'call';
  else return spec.call.tgt.func;
}
export function needAbiEncoding(member: string): boolean {
  return member === 'call' || member === 'delegatecall' || member === 'staticcall';
}

// usesAddr checks if a type has address, if so it is subject to wrap/unwrap
// Note: argument type takes no prefix such as `struct`
export function usesAddr(type: string): boolean {
  if (type === 'address') return true;
  if (type === 'address payable') return true;
  if (type.startsWith('contract ')) return true; // DX: not sure if it is always correct
  if (globalThis.structMap.has(type)) {
    const b = globalThis.structMap.get(type)?.vMembers.some((m) => usesAddr(m.typeString));
    if (b) return true;
  }
  // TODO: handle mappings and arrays
  return false;
}
