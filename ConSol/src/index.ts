import { CompileResult, compileSol, EventDefinition, FunctionDefinition, ASTNodeFactory } from 'solc-typed-ast';
import fs from 'fs/promises';
import { ASTWriter, ASTReader, DefaultASTWriterMapping, LatestCompilerVersion, PrettyFormatter } from 'solc-typed-ast';
import * as path from 'path';
import { ContractSpecTransformer } from './val-spec-transformer.js';

// AST node kinds that allow ConSol spec attachments
type ConSolCheckNodes = FunctionDefinition | EventDefinition;

function convertResultToPlainObject(result: CompileResult): Record<string, unknown> {
  return {
    ...result,
    files: Object.fromEntries(result.files),
    resolvedFileNames: Object.fromEntries(result.resolvedFileNames),
    inferredRemappings: Object.fromEntries(result.inferredRemappings),
  };
}

async function main() {
  // const args = process.argv.slice(1);
  // if (args.length !== 2) {
  //   console.error(`Usage: ${process.argv[0]} <filepath>`);
  //   process.exit(1);
  // }

  // const inputPath = args[1];
  // const inputPath = './test/testCallFoo.sol';
  const inputPath = './test/Lock.sol';
  const filename = path.basename(inputPath);
  const dirname = path.dirname(inputPath);

  const outputJson = path.join(dirname, filename.split('.')[0] + '.json');
  const outputSol = path.join(dirname, filename.split('.')[0] + '_out.sol');

  const complieResult = await compileSol(inputPath, 'auto');
  // console.log(complieResult);
  // console.log(complieResult.data.sources[`${filename}.sol`].ast.nodes[1].nodes);

  // dump to json file
  await fs.writeFile(outputJson, JSON.stringify(convertResultToPlainObject(complieResult), null, 2));

  // read the typed ast
  const reader = new ASTReader();
  const sourceUnits = reader.read(complieResult.data);

  console.log('Used compiler version: ' + complieResult.compilerVersion);
  // console.log(sourceUnits[0].print());

  const contract = sourceUnits[0].vContracts[0];
  const factory = new ASTNodeFactory(contract.context);
  const contractTransformer = new ContractSpecTransformer(factory, contract.scope, contract);
  contractTransformer.process();

  // convert ast back to source
  const formatter = new PrettyFormatter(4, 0);
  const writer = new ASTWriter(
    DefaultASTWriterMapping,
    formatter,
    complieResult.compilerVersion ? complieResult.compilerVersion : LatestCompilerVersion,
  );

  for (const sourceUnit of sourceUnits) {
    console.log('// ' + sourceUnit.absolutePath);
    const outFileContent = writer.write(sourceUnit);
    try {
      // Use the writeFile method to save the content to a file
      await fs.writeFile(outputSol, outFileContent);
      console.log(`File ${outputSol} saved successfully`);
    } catch (error) {
      console.error(`Error saving file ${outputSol}: ${error}`);
    }
  }
}

main().catch(console.error);
