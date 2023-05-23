import {
  ASTContext,
  ASTNodeFactory,
  CompileFailedError,
  CompileResult,
  compileSol,
  EventDefinition,
  Expression,
  ExpressionStatement,
  FunctionCallKind,
  FunctionDefinition,
  LiteralKind,
  StructuredDocumentation,
  VariableDeclaration,
  ASTNode,
} from 'solc-typed-ast';
import fs from 'fs/promises';
import {
  ASTWriter,
  ASTReader,
  DefaultASTWriterMapping,
  LatestCompilerVersion,
  PrettyFormatter,
} from 'solc-typed-ast';
import * as path from 'path';
import { CSSpecParse, CSSpecVisitor } from './spec/index.js';

const SPEC_PREFIX = '@custom:consol';

function convertResultToPlainObject(
  result: CompileResult,
): Record<string, unknown> {
  return {
    ...result,
    files: Object.fromEntries(result.files),
    resolvedFileNames: Object.fromEntries(result.resolvedFileNames),
    inferredRemappings: Object.fromEntries(result.inferredRemappings),
  };
}

// Util functions

function nodeIsConstructor(node: ASTNode): node is FunctionDefinition {
  return (
    node instanceof FunctionDefinition &&
    (node as FunctionDefinition).isConstructor
  );
}

async function main() {
  let complieResult: CompileResult;

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

    complieResult = await compileSol(inputPath, 'auto');
    // console.log(complieResult);
    // console.log(complieResult.data.sources[`${filename}.sol`].ast.nodes[1].nodes);

    // dump to json file
    await fs.writeFile(
      outputJson,
      JSON.stringify(convertResultToPlainObject(complieResult), null, 2),
    );

    // read the typed ast
    const reader = new ASTReader();
    const sourceUnits = reader.read(complieResult.data);

    console.log('Used compiler version: ' + complieResult.compilerVersion);
    console.log(sourceUnits[0].print());

    // Step1: get spec from comment
    sourceUnits[0].vContracts[0].walkChildren((astNode) => {
      const astNodeDoc = (
        astNode as FunctionDefinition | EventDefinition | VariableDeclaration
      ).documentation as StructuredDocumentation;
      if (astNodeDoc) {
        let astNodeName = astNode.raw.name;
        if (nodeIsConstructor(astNode)) {
          astNodeName = 'constructor';
        }

        let specStr = astNodeDoc.text;
        if (specStr.startsWith(SPEC_PREFIX)) {
          console.log(astNode.type);
          console.log(astNodeName);
          specStr = specStr.substring(SPEC_PREFIX.length).trim();
          console.log(specStr);
          console.log('\n');

          const visitor = new CSSpecVisitor<string>((s) => s);
          const spec = CSSpecParse<string>(specStr, visitor);
          console.log(spec);
        }
      }
    });

    // TODO: spec ast parser

    // @custom:consol { _unlockTime | _unlockTime > 0 } for constructor
    const buildRequireStmt = (
      ctx: ASTContext,
      constraint: Expression,
      msg?: string,
    ): ExpressionStatement => {
      const factory = new ASTNodeFactory(ctx);
      const callArgs = msg
        ? [
            constraint,
            factory.makeLiteral(
              'string',
              LiteralKind.String,
              Buffer.from(msg, 'utf8').toString('hex'),
              msg,
            ),
          ]
        : [constraint];
      const requireFn = factory.makeIdentifier(
        'function (bool,string memory) pure',
        'require',
        -1,
      );
      const requireCall = factory.makeFunctionCall(
        'bool',
        FunctionCallKind.FunctionCall,
        requireFn,
        callArgs,
      );
      return factory.makeExpressionStatement(requireCall);
    };

    // sourceUnits.forEach((su) => su.walkChildren((c_node) => {
    //   if (c_node instanceof ContractDefinition) {
    //     c_node.walkChildren((f_node: any)
    sourceUnits[0].vContracts[0].walkChildren((astNode: ASTNode) => {
      if (nodeIsConstructor(astNode) && astNode.implemented && astNode.vBody) {
        const body = astNode.vBody;
        console.assert(body.context !== undefined);
        const ctx = body.context as ASTContext;
        const factory = new ASTNodeFactory(ctx);
        const zeroLiteral = factory.makeLiteral(
          'uint256',
          LiteralKind.Number,
          '0',
          '0',
        );
        const params = astNode.vParameters;
        const unlockTimeDecl = params.vParameters[0];
        const unlockTime = factory.makeIdentifierFor(unlockTimeDecl);
        // const unlockTimeDecl = su.getChildrenBySelector((node) => node instanceof VariableDeclaration && node.name === '_unlockTime')[0];

        // const unlockTime = factory.makeIdentifier('uint256', '_unlockTime', unlockTimeDecl.id);
        const constraintExpr = factory.makeBinaryOperation(
          'bool',
          '>',
          unlockTime,
          zeroLiteral,
        );
        const requireStmt = buildRequireStmt(
          ctx,
          constraintExpr,
          'unlockTime must be greater than 0',
        );
        body.insertAtBeginning(requireStmt);
      }
    });

    // convert ast back to source
    const formatter = new PrettyFormatter(4, 0);
    const writer = new ASTWriter(
      DefaultASTWriterMapping,
      formatter,
      complieResult.compilerVersion
        ? complieResult.compilerVersion
        : LatestCompilerVersion,
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
  } catch (e) {
    if (e instanceof CompileFailedError) {
      console.error('Compile errors encounterd: ');
      for (const failure of e.failures) {
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

main().catch(console.error);
