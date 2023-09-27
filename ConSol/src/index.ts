import * as path from 'path';
import { ConSolCompile } from './ConSolUtils.js';

async function main() {
  const args = process.argv.slice(1);
  if (args.length !== 2) {
    console.error(`Usage: ${process.argv[1]} <filepath>`);
    process.exit(1);
  }

  const inputFile = args[1];
  // const inputPath = './test/testCallFoo.sol';
  // const inputPath = './test/Lock.sol';
  const filename = path.basename(inputFile);
  const dirname = path.dirname(inputFile);

  const outputJson = path.join(dirname, filename.split('.')[0] + '_ast.json');
  const outputFile = path.join(dirname, filename.split('.')[0] + '_out.sol');

  await ConSolCompile(inputFile, outputFile, outputJson);
}

main().catch(console.error);
