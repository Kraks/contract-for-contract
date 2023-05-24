import {
  ASTContext,
  ASTNodeFactory,
  CompileFailedError,
  CompileResult,
  compileSol,
  EventDefinition,
  FunctionDefinition,
  FunctionVisibility,
  FunctionStateMutability,
  LiteralKind,
  FunctionKind,
  ParameterList,
  StructuredDocumentation,
  VariableDeclaration,
  ASTNode,
  DataLocation,
  StateVariableVisibility,
  Mutability,
  TypeName,
  FunctionCallKind,
  ExpressionStatement, 
  Expression,
  FunctionCall,
  Identifier,
  Statement
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
import { CSSpecParse, CSSpecVisitor, CSSpec, isValSpec, isTempSpec } from './spec/index.js';
import { handleValSpec } from './val-spec-transformer.js';
import { SPEC_PREFIX, isConSolSpec, isConstructor, extractFunName } from './utils.js';

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

function parseConSolSpec(doc: string): CSSpec<string> {
  const specStr = doc.substring(SPEC_PREFIX.length).trim();
  const visitor = new CSSpecVisitor<string>((s) => s);
  const spec = CSSpecParse<string>(specStr, visitor);
  return spec;
}

async function main() {
  // const args = process.argv.slice(1);
  // if (args.length !== 2) {
  //   console.error(`Usage: ${process.argv[0]} <filepath>`);
  //   process.exit(1);
  // }

  // const inputPath = args[1];
  const inputPath = "./test/Lock.sol";
  const filename = path.basename(inputPath);
  const dirname = path.dirname(inputPath);

  const outputJson = path.join(dirname, filename.split('.')[0] + '.json');
  const outputSol = path.join(dirname, filename.split('.')[0] + '_out.sol');

  const complieResult = await compileSol(inputPath, 'auto');
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

  sourceUnits[0].vContracts[0].walkChildren((astNode: ASTNode) => {
    const astNodeDoc = (astNode as ConSolCheckNodes).documentation as StructuredDocumentation;
    if (!astNodeDoc) return;
    let specStr = astNodeDoc.text;
    if (!isConSolSpec(specStr)) return;

    console.log("Processing spec: " + specStr.substring(SPEC_PREFIX.length).trim());
    
    const spec = parseConSolSpec(specStr);

    if (isValSpec(spec)) {
      handleValSpec(astNode, spec);
    } else if (isTempSpec(spec)) {
      // TODO
    } else {
      console.assert(false);
    }
  });

  // TODO: clean up the rest

  /** 
   // @custom:consol { _unlockTime | _unlockTime > 0 } for constructor
   
   // sourceUnits.forEach((su) => su.walkChildren((c_node) => {
   //   if (c_node instanceof ContractDefinition) {
   //     c_node.walkChildren((f_node: any)
   sourceUnits[0].vContracts[0].walkChildren((astNode: ASTNode) => {
   if (isConstructor(astNode) && astNode.implemented && astNode.vBody) {
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
  */

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
}

main().catch(console.error);
