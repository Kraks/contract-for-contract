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
import { CSSpec, isValSpec, isTempSpec, ValSpec } from './spec/index.js';
import { SPEC_PREFIX, isConSolSpec, isConstructor, extractFunName } from './utils.js';

function makeFlatCheckFun(
  ctx: ASTContext,
  factory: ASTNodeFactory,
  scope: number,
  funName: string,
  funKind: FunctionKind, // constructor/function/fallback...
  visibility: FunctionVisibility,
  stateMutability: FunctionStateMutability,
  parameters: ParameterList,
): FunctionDefinition {
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
}

function buildRequireStmt(ctx: ASTContext, factory: ASTNodeFactory, constraint: Expression, msg: string): ExpressionStatement {
  const callArgs = [
    constraint,
    factory.makeLiteral(
      'string',
      LiteralKind.String,
      Buffer.from(msg, 'utf8').toString('hex'),
      msg,
    ),
  ];
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
}

function copyParameters(parameters: VariableDeclaration[], factory: ASTNodeFactory) {
  return parameters.map((param) => factory.makeIdentifierFor(param));
}

function createWrapperFun(
  ctx: ASTContext,
  factory: ASTNodeFactory,
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
): FunctionDefinition {
  const statements = [];

  // Create require pre-condition statement
  if (preCondFunName){
    const tmpid = factory.makeIdentifier('function', preCondFunName, -1);
    const preCondCall = factory.makeFunctionCall(
      'bool', 
      FunctionCallKind.FunctionCall,
      tmpid,
      copyParameters(parameters.vParameters, factory),
      );
    const preCondRequireStmt = buildRequireStmt(
      ctx,
      factory,
      preCondCall,
      "Violate the preondition for function " + funName,
    );
    statements.push(preCondRequireStmt);
  }

  // Create original function call
  // factory.makeIdentifier('function', funName, originalFunId)
  const funId = factory.makeIdentifier('function', funName, -1); // buggy
  const params = copyParameters(parameters.vParameters, factory);
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
  } else {
    // no return value
    const originalCallStmt = factory.makeExpressionStatement(originalCall); 
    statements.push(originalCallStmt);
  }

  if (postCondFunName){
    // Create require post-condition statement
    let postCallParamList;
    if (returnVarDecl){
      postCallParamList = [...copyParameters(parameters.vParameters, factory), factory.makeIdentifierFor(returnVarDecl)];
    } else{
      postCallParamList = copyParameters(parameters.vParameters, factory);
    } 
    const postCondCall = factory.makeFunctionCall(
      'bool', 
      FunctionCallKind.FunctionCall,
      factory.makeIdentifier('function', postCondFunName, -1),
      postCallParamList,
    );
    const postCondRequireStmt = buildRequireStmt(
      ctx,
      factory,
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
}

function handleValSpecFunDef<T>(node: FunctionDefinition, spec: ValSpec<T>) {
  const funName = extractFunName(node);
  console.log("Handling FunctionDefinition: " + funName);
  const ctx = node.context as ASTContext;
  console.assert(node.context !== undefined);
  const factory = new ASTNodeFactory(ctx);

  let preFunName, postFunName: string | undefined;

  if (spec.preCond !== undefined) {
    const specStr = spec.preCond;
    preFunName = '_' + funName + 'Pre';
    console.log('inserting ' + preFunName);
    let preCondFunc = makeFlatCheckFun(
      ctx,
      factory,
      node.id,
      preFunName,
      // isConstructor(node)? FunctionKind.Constructor : FunctionKind.Function,
      FunctionKind.Function, // this is condFunc, always function
      FunctionVisibility.Public,
      FunctionStateMutability.NonPayable,
      (node as FunctionDefinition).vParameters,
    );
    node.vScope.appendChild(preCondFunc);
  }

  if (spec.postCond !== undefined) {
    const specStr = spec.postCond;
    postFunName = '_' + funName + 'Post';
    console.log('inserting ' + postFunName);
    let postCondFunc = makeFlatCheckFun(
      ctx,
      factory,
      node.id,
      postFunName,
      FunctionKind.Function, // this is condFunc, always function
      FunctionVisibility.Public,
      FunctionStateMutability.NonPayable,
      (node as FunctionDefinition).vParameters,
    );
    node.vScope.appendChild(postCondFunc);
  }

  // TODO: add wrapper function  
  if (spec.call !== undefined){
    console.log("inserting ValSpec wrapper function for " + funName);
    const wrapperFun = createWrapperFun(
      ctx,
      factory,
      node.id,
      funName,
      isConstructor(node)? FunctionKind.Constructor : FunctionKind.Function, 
      node.stateMutability, 
      (node as FunctionDefinition).vParameters,
      node.id,
      undefined, //TOOD
      undefined,
      preFunName,
      postFunName
    );  
    node.vScope.appendChild(wrapperFun);
  }
}

export function handleValSpec<T>(node: ASTNode, spec: ValSpec<T>) {
  console.log("Parsed spec AST:");
  console.log(spec);
  console.log(spec.tag);

  if (node instanceof FunctionDefinition) {
    handleValSpecFunDef(node, spec);
  } else if (node instanceof EventDefinition) {
    // TODO
  } else {
    console.assert(false, "wow");
  }
}
