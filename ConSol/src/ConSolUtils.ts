import {
  FunctionDefinition,
  ASTNode,
  compileSol,
  CompileResult,
  ASTReader,
  ASTNodeFactory,
  PrettyFormatter,
  ASTWriter,
  DefaultASTWriterMapping,
  LatestCompilerVersion,
  ContractDefinition,
} from 'solc-typed-ast';
import { ValSpec } from './spec/index.js';
import { CSSpecParse, CSSpecVisitor, CSSpec } from './spec/index.js';

import * as fs from 'fs';
import { ConSolTransformer } from './ConSolTransformer.js';
import { resetAddrSpecId } from './Global.js';

export const SPEC_PREFIX = '@custom:consol';

export function parseConSolSpec(doc: string): CSSpec<string> {
  resetAddrSpecId();
  const specStr = doc.substring(SPEC_PREFIX.length).trim();
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

export async function ConSolCompile(inputFile: string, outputFile: string, outputJson?: string): Promise<void> {
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

  // Note: assume there is only one source unit/file
  const sourceUnit = sourceUnits[0];
  const ifs: Array<ContractDefinition> = sourceUnit.vContracts.filter((contract) => contract.kind === 'interface');

  sourceUnit.vContracts.forEach((contract) => {
    console.log(`Discover ${contract.kind} ${contract.name}.`);
    if (contract.kind === 'interface') {
      console.log(`Skip ${contract.kind} ${contract.name}.`);
      return;
    }
    console.log(`Processing ${contract.kind} ${contract.name}.`);
    const factory = new ASTNodeFactory(contract.context);
    const contractTransformer = new ConSolTransformer(factory, contract.scope, contract, ifs);
    contractTransformer.process();
  });

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
}

export function isConSolSpec(doc: string): boolean {
  return doc.startsWith(SPEC_PREFIX);
}

export function isConstructor(node: ASTNode): node is FunctionDefinition {
  return node instanceof FunctionDefinition && (node as FunctionDefinition).isConstructor;
}

export function extractFunName(node: ASTNode): string {
  if (isConstructor(node)) return 'constructor';
  return node.raw.name;
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
