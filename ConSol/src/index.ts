import * as path from 'path';
import { ConSolCompile } from './ConSolUtils.js';
import { parse } from 'ts-command-line-args';

interface Args {
  filepath: string;
  useDev: boolean;
  useCustomError: boolean;
}

async function main() {
  //const args = process.argv.slice(1);
  const args = parse<Args>({
    filepath: String,
    useDev: Boolean,
    useCustomError: Boolean,
  })
  //console.log(args)

  const inputFile = args.filepath;
  const filename = path.basename(inputFile);
  const dirname = path.dirname(inputFile);

  const outputJson = path.join(dirname, filename.split('.')[0] + '_ast.json');
  const outputFile = path.join(dirname, filename.split('.')[0] + '_out.sol');

  await ConSolCompile(inputFile, outputFile, outputJson, args.useDev, args.useCustomError);
}

main().catch(console.error);
