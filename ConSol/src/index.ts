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
import { CSSpecParse, CSSpecVisitor, ValSpec } from './spec/index.js';

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



const createFirstOrderSpecFunc = (
  ctx: ASTContext,
  scope: number,
  funName: string,
  funKind: FunctionKind, // constructor/function/fallback...
  visibility: FunctionVisibility,
  stateMutability: FunctionStateMutability,
  parameters: ParameterList,
): FunctionDefinition => {
  const factory = new ASTNodeFactory(ctx);
  const returnValNode = factory.makeLiteral(
    'bool',
    LiteralKind.Bool,
    '1',
    'true',
  );
  const boolReturnVariable = factory.makeVariableDeclaration(
    false, // constant
    false, // indexed
    'bool', // name
    0, // scope
    false, // stateVariable
    DataLocation.Default, // storageLocation
    StateVariableVisibility.Default, // visibility
    Mutability.Constant, // mutability
    'bool', // typeString, "bool"
  );
  const returnParameters = new ParameterList(0, '', [boolReturnVariable]);
  const returnStatement = factory.makeReturn(returnValNode.id, returnValNode);
  const funBody = factory.makeBlock([returnStatement]);
  const funDef = factory.makeFunctionDefinition(
    scope,
    funKind,
    funName,
    false, // virtual
    visibility,
    stateMutability,
    funKind == FunctionKind.Constructor,
    parameters,
    returnParameters,
    [], //modifier
    undefined,
    funBody,
  );

  return funDef;
};

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


const createParametersCopy = (parameters:VariableDeclaration[], factory:ASTNodeFactory) => {
  return parameters.map((param) => factory.makeIdentifierFor(param));
};

const createWrapperFunc = (
  ctx: ASTContext,
  scope: number,   // TODO scope?
  funName: string,
  funKind: FunctionKind, 
  funStateMutability: FunctionStateMutability, // payable/nonpayable
  parameters: ParameterList,
  originalFunId: number,
  returnType?: TypeName,  //can be void
  returnVarname?: string,
  preCondFunName?: string,
  postCondFunName?: string,
): FunctionDefinition => {
  const factory = new ASTNodeFactory(ctx);
  const statements = [];
  // Create require pre-condition statement
  if (preCondFunName){
    const tmpid = factory.makeIdentifier('function', preCondFunName, -1);
    const preCondCall = factory.makeFunctionCall(
      'bool', 
      FunctionCallKind.FunctionCall,
      tmpid,
      createParametersCopy(parameters.vParameters, factory),
      );
    const preCondRequireStmt = buildRequireStmt(
      ctx,
      preCondCall,
      "Violate the preondition for function " + funName,
    );
    statements.push(preCondRequireStmt);
  }

  // Create original function call
  // factory.makeIdentifier('function', funName, originalFunId)
  const funId = factory.makeIdentifier('function', funName, -1); // buggy
  const params = createParametersCopy(parameters.vParameters, factory);
  const originalCall = factory.makeFunctionCall(
    returnType? returnType.typeString: "void",
    FunctionCallKind.FunctionCall,
    funId,
    params,  
  );
  // let returnValId : Identifier | undefined;
  let returnVarDecl: VariableDeclaration | undefined;
  let returnStatement: Statement | undefined;
  if (returnType && returnVarname){
    returnVarDecl = factory.makeVariableDeclaration(
      false,
      false,
      returnVarname,
      scope, // scope 
      false,
      DataLocation.Default,
      StateVariableVisibility.Default,
      Mutability.Constant,
      returnType.typeString,
    );
    // returnValId = factory.makeIdentifierFor(returnVarDecl);
    const assignment = factory.makeAssignment(
      returnType.typeString,
      '=',
      factory.makeIdentifierFor(returnVarDecl),
      originalCall
    );
    
    const assignmentStmt = factory.makeExpressionStatement(assignment);  
    statements.push(assignmentStmt);
    
    
    returnStatement = factory.makeReturn(returnVarDecl.id);
  }
  else {
    // no return value
    const originalCallStmt = factory.makeExpressionStatement(originalCall); 
    statements.push(originalCallStmt);
  }

  if (postCondFunName){
    // Create require post-condition statement
    let postCallParamList;
    if (returnVarDecl){
      postCallParamList = [...createParametersCopy(parameters.vParameters, factory), factory.makeIdentifierFor(returnVarDecl)];
    } else{
      postCallParamList = createParametersCopy(parameters.vParameters, factory);
    } 
    const postCondCall = factory.makeFunctionCall(
      'bool', 
      FunctionCallKind.FunctionCall,
      factory.makeIdentifier('function', postCondFunName, -1),
      postCallParamList,
    );
    const postCondRequireStmt = buildRequireStmt(
      ctx,
      postCondCall,
      "Violate the postondition for function " + funName,
    );
  }

  // Create return statement
  if (returnStatement) {
    statements.push(returnStatement);
  }


  // Build function body
  const funBody = factory.makeBlock(statements);
  const funDef = factory.makeFunctionDefinition(
    scope,
    funKind,
    funName + "_wrapper", // TODO: rename original func
    false, // virtual
    FunctionVisibility.Public,
    funStateMutability,
    funKind == FunctionKind.Constructor,
    parameters,
    returnVarDecl ? new ParameterList(0, '', [returnVarDecl]) : new ParameterList(0, '', []),
    [], // modifier
    undefined,
    funBody
  );
  
  return funDef;


};

async function main() {
  let complieResult: CompileResult;

  // try
  if (true) {
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
    sourceUnits[0].vContracts[0].walkChildren((astNode: ASTNode) => {
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

          // add node
          // including function and constructor

          if (astNode instanceof FunctionDefinition) {
            let specFunName = astNodeName;
            const ctx = astNode.context as ASTContext;
            console.assert(astNode.context !== undefined);

            let preCondFunc, postCondFunc: FunctionDefinition | undefined;
            let preFunName, postFunName: string | undefined;
            if ('preCond' in spec) {
              const specStr = spec.preCond;
              preFunName = '_' + astNodeName + 'Pre';
              console.log('inserting ' + preFunName);
              preCondFunc = createFirstOrderSpecFunc(
                ctx,
                astNode.id,
                preFunName,
                // nodeIsConstructor(astNode)? FunctionKind.Constructor : FunctionKind.Function,
                FunctionKind.Function, // this is condFunc, always function
                FunctionVisibility.Public,
                FunctionStateMutability.NonPayable,
                (astNode as FunctionDefinition).vParameters,
              );
              astNode.vScope.appendChild(preCondFunc);
            }

            if ('postCond' in spec) {
              const specStr = spec.postCond;
              specFunName = '_' + astNodeName + 'Post';
              console.log('inserting ' + specFunName);
              postCondFunc = createFirstOrderSpecFunc(
                ctx,
                astNode.id,
                specFunName,
                FunctionKind.Function, // this is condFunc, always function
                FunctionVisibility.Public,
                FunctionStateMutability.NonPayable,
                (astNode as FunctionDefinition).vParameters,
              );
              astNode.vScope.appendChild(postCondFunc);
            
            }
            // TODO: add wrapper function  
            if ('call' in spec){
              console.log("inserting ValSpec wrapper function for "+astNodeName);
              const wrapperFun = createWrapperFunc(
                ctx,
                astNode.id,
                astNodeName,
                nodeIsConstructor(astNode)? FunctionKind.Constructor : FunctionKind.Function, 
                astNode.stateMutability, 
                (astNode as FunctionDefinition).vParameters,
                astNode.id,
                undefined, //TOOD
                undefined,
                preFunName,
                postFunName
              );  
              astNode.vScope.appendChild(wrapperFun);
            }
       
          }
        }
      }
    });

    /** 
    // @custom:consol { _unlockTime | _unlockTime > 0 } for constructor
  
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
  // catch (e) {
  //   if (e instanceof CompileFailedError) {
  //     console.error('Compile errors encounterd: ');
  //     for (const failure of e.failures) {
  //       console.error(`Solc ${failure.compilerVersion}:`);

  //       for (const error of failure.errors) {
  //         console.error(error);
  //       }
  //     }
  //   } else if (e instanceof Error) {
  //     console.error(e.message);
  //   }
  // }
}

main().catch(console.error);
