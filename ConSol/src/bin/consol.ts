#!/usr/bin/env node

import { CompileFailedError, CompileResult, compileSol } from 'solc-typed-ast';
import fs from 'fs/promises';
import {
  ASTWriter,
  ASTReader,
  DefaultASTWriterMapping,
  LatestCompilerVersion,
  PrettyFormatter,
} from 'solc-typed-ast';
import * as path from 'path';

function convertResultToPlainObject(result: CompileResult): Record<string, any> {
  return {
    ...result,
    files: Object.fromEntries(result.files),
    resolvedFileNames: Object.fromEntries(result.resolvedFileNames),
    inferredRemappings: Object.fromEntries(result.inferredRemappings),
  };
}


async function main() {
  let result: CompileResult;

  try {
    const args = process.argv.slice(1);
    if (args.length !== 2) {
      console.error(`Usage: ${process.argv[0]} <filepath>`);
      process.exit(1);
    }

    const inputPath = args[1];
    const filename = path.basename(inputPath);
    const dirname = path.dirname(inputPath);

    const outputJson = path.join(dirname, filename.split('.')[0] + '.json');
    const outputSol = path.join(dirname, filename.split('.')[0] + '_out.sol');

    result = await compileSol(inputPath, 'auto');
    // console.log(result);
    // console.log(result.data.sources[`${filename}.sol`].ast.nodes[1].nodes);

    // dump to json file
    await fs.writeFile(outputJson, JSON.stringify(convertResultToPlainObject(result), null, 2));

    // read the typed ast
    const reader = new ASTReader();
    const sourceUnits = reader.read(result.data);
        
    console.log('Used compiler version: ' + result.compilerVersion);
    console.log(sourceUnits[0].print());
        
    // TODO: conduct transformation

    // convert ast back to source
    const formatter = new PrettyFormatter(4, 0);
    const writer = new ASTWriter(
      DefaultASTWriterMapping,
      formatter,
      result.compilerVersion ? result.compilerVersion : LatestCompilerVersion,
    );

    for (const sourceUnit of sourceUnits) {
      console.log('// ' + sourceUnit.absolutePath);
      const outFileContent =  writer.write(sourceUnit);
      try {
        // Use the writeFile method to save the content to a file
        await fs.writeFile(outputSol, outFileContent); 
        console.log(`File ${outputSol} saved successfully`);
      } catch (error) {
        console.error(`Error saving file ${outputSol}: ${error}`);
      }
    }

        
  } catch (e) {
    if (e instanceof CompileFailedError) {
      console.error('Compile errors encounterd: ');
      for (const failure of e.failures)  {
        console.error(`Solc ${failure.compilerVersion}:`);

        for (const error of failure.errors) {
          console.error(error);
        }
      }
    } else if (e instanceof Error) {
      console.error(e.message);
    }
  }


}

main();
