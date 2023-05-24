import {
  ASTContext,
  ASTNodeFactory,
  EventDefinition,
  FunctionDefinition,
  FunctionVisibility,
  FunctionStateMutability,
  LiteralKind,
  FunctionKind,
  ParameterList,
  VariableDeclaration,
  ASTNode,
  DataLocation,
  StateVariableVisibility,
  Mutability,
  FunctionCallKind,
  ExpressionStatement,
  Expression,
  Statement,
  assert,
  TypeName,
} from 'solc-typed-ast';

import { ValSpec } from './spec/index.js';
import { isConstructor, extractFunName } from './utils.js';

function makeFlatCheckFun(
  ctx: ASTContext,
  factory: ASTNodeFactory,
  scope: number,
  funName: string,
  funKind: FunctionKind, // constructor/function/fallback...
  visibility: FunctionVisibility,
  stateMutability: FunctionStateMutability,
  params: ParameterList,
): FunctionDefinition {
  const retNode = factory.makeLiteral('bool', LiteralKind.Bool, '1', 'true');
  const boolRetVar = factory.makeVariableDeclaration(
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
  const retParams = new ParameterList(0, '', [boolRetVar]);
  const retStmt = factory.makeReturn(retNode.id, retNode);
  const funBody = factory.makeBlock([retStmt]);
  const funDef = factory.makeFunctionDefinition(
    scope,
    funKind,
    funName,
    false, // virtual
    visibility,
    stateMutability,
    funKind == FunctionKind.Constructor,
    params,
    retParams,
    [], //modifier
    undefined,
    funBody,
  );

  return funDef;
}

function buildRequireStmt(
  ctx: ASTContext,
  factory: ASTNodeFactory,
  constraint: Expression,
  msg: string,
): ExpressionStatement {
  const callArgs = [
    constraint,
    factory.makeLiteral('string', LiteralKind.String, Buffer.from(msg, 'utf8').toString('hex'), msg),
  ];
  const requireFn = factory.makeIdentifier('function (bool,string memory) pure', 'require', -1);
  const requireCall = factory.makeFunctionCall('bool', FunctionCallKind.FunctionCall, requireFn, callArgs);
  return factory.makeExpressionStatement(requireCall);
}

function copyParameters(params: VariableDeclaration[], factory: ASTNodeFactory) {
  return params.map((param) => factory.makeIdentifierFor(param));
}

function createWrapperFun(
  ctx: ASTContext,
  factory: ASTNodeFactory,
  scope: number,
  funName: string,
  originalFunName: string,
  funKind: FunctionKind,
  funStateMutability: FunctionStateMutability, // payable/nonpayable
  params: ParameterList,
  originalFunId: number,
  retType?: TypeName, //can be void
  returnVarname?: string,
  preCondFunName?: string,
  postCondFunName?: string,
): FunctionDefinition {
  const stmts = [];

  // Create require pre-condition statement
  if (preCondFunName) {
    const tmpid = factory.makeIdentifier('function', preCondFunName, -1);
    const preCondCall = factory.makeFunctionCall(
      'bool',
      FunctionCallKind.FunctionCall,
      tmpid,
      copyParameters(params.vParameters, factory),
    );
    const preCondRequireStmt = buildRequireStmt(
      ctx,
      factory,
      preCondCall,
      'Violate the preondition for function ' + funName,
    );
    stmts.push(preCondRequireStmt);
  }

  // Create original function call
  const originalCall = factory.makeFunctionCall(
    retType ? retType.typeString : 'void',
    FunctionCallKind.FunctionCall,
    factory.makeIdentifier('function', originalFunName, -1),
    copyParameters(params.vParameters, factory),
  );
  // let returnValId : Identifier | undefined;
  let retValDecl: VariableDeclaration | undefined; // has name info
  let retTypeDecl: VariableDeclaration | undefined; // has type info
  let retStmt: Statement | undefined;
  if (retType && returnVarname) {
    retTypeDecl = factory.makeVariableDeclaration(
      false,
      false,
      returnVarname,
      scope, // scope
      false,
      DataLocation.Default,
      StateVariableVisibility.Default,
      Mutability.Mutable,
      retType.typeString,
    );
    retTypeDecl.vType = retType;

    retValDecl = factory.makeVariableDeclaration(
      false,
      false,
      returnVarname,
      scope, // scope
      false,
      DataLocation.Default,
      StateVariableVisibility.Default,
      Mutability.Mutable,
      retType.typeString,
    );

    // assignment
    const varDeclStmt = factory.makeVariableDeclarationStatement([null], [retTypeDecl], originalCall);
    stmts.push(varDeclStmt);

    retStmt = factory.makeReturn(retValDecl.id, retValDecl);
  } else {
    // no return value
    const originalCallStmt = factory.makeExpressionStatement(originalCall);
    stmts.push(originalCallStmt);
  }

  if (postCondFunName) {
    // Create require post-condition statement
    let postCallParamList;
    if (retTypeDecl) {
      postCallParamList = [...copyParameters(params.vParameters, factory), factory.makeIdentifierFor(retTypeDecl)];
    } else {
      postCallParamList = copyParameters(params.vParameters, factory);
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
      'Violate the postondition for function ' + funName,
    );
    stmts.push(postCondRequireStmt);
  }

  // Create return statement
  if (retStmt) {
    stmts.push(retStmt);
  }

  // Build function body
  const funBody = factory.makeBlock(stmts);
  const funDef = factory.makeFunctionDefinition(
    scope,
    funKind,
    funName,
    false, // virtual
    FunctionVisibility.Public,
    funStateMutability,
    funKind == FunctionKind.Constructor,
    params,
    retTypeDecl ? new ParameterList(0, '', [retTypeDecl]) : new ParameterList(0, '', []),
    [], // modifier
    undefined,
    funBody,
  );

  return funDef;
}

function getVarNameDecMap(
  factory: ASTNodeFactory,
  scope: number,
  returnVarNames: string[],
  returnParams: VariableDeclaration[],
): Map<string, VariableDeclaration> {
  assert(returnVarNames.length === returnParams.length, 'Return Variable length wrong');
  const varNameDecMap = new Map<string, VariableDeclaration>();

  returnVarNames.forEach((name, index) => {
    const type = returnParams[index].typeString;
    const retVarDec = factory.makeVariableDeclaration(
      false,
      false,
      name,
      scope,
      false,
      DataLocation.Default,
      StateVariableVisibility.Internal,
      Mutability.Mutable,
      type,
    );
    retVarDec.vType = returnParams[index].vType;
    varNameDecMap.set(name, retVarDec);
  });
  return varNameDecMap;
}

function handleValSpecFunDef<T>(node: FunctionDefinition, spec: ValSpec<T>) {
  const funName = extractFunName(node);
  const originalFunName = node.name + '_original';
  node.name = originalFunName;
  console.log('Handling FunctionDefinition: ' + funName);
  const ctx = node.context as ASTContext;
  console.assert(node.context !== undefined);
  const factory = new ASTNodeFactory(ctx);

  let preFunName, postFunName: string | undefined;

  if (spec.preCond !== undefined) {
    const specStr = spec.preCond;
    preFunName = '_' + funName + 'Pre';
    console.log('inserting ' + preFunName);
    const preCondFunc = makeFlatCheckFun(
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
    const inputParam = (node as FunctionDefinition).vParameters.vParameters;
    const returnParams = (node as FunctionDefinition).vReturnParameters.vParameters;
    const varNameDecMap = getVarNameDecMap(factory, node.id, spec.call.rets, returnParams);

    const allParams = new ParameterList(0, '', [...inputParam, ...Array.from(varNameDecMap.values())]);
    const postCondFunc = makeFlatCheckFun(
      ctx,
      factory,
      node.id,
      postFunName,
      FunctionKind.Function, // this is condFunc, always function
      FunctionVisibility.Public,
      FunctionStateMutability.NonPayable,
      allParams,
    );
    node.vScope.appendChild(postCondFunc);
  }

  if (spec.call !== undefined) {
    console.log('inserting ValSpec wrapper function for ' + funName);

    // TODO: only consider the first ret for now
    const returnType = node.vReturnParameters.vParameters[0]?.vType;
    const returnVarName = spec.call.rets[0];
    const wrapperFun = createWrapperFun(
      ctx,
      factory,
      node.id,
      funName,
      originalFunName,
      isConstructor(node) ? FunctionKind.Constructor : FunctionKind.Function,
      node.stateMutability,
      (node as FunctionDefinition).vParameters,
      node.id,
      returnType, //TOOD : retType
      returnVarName, // retVarName
      preFunName,
      postFunName,
    );
    node.vScope.appendChild(wrapperFun);
    node.visibility = FunctionVisibility.Private;
  }
}

export function handleValSpec<T>(node: ASTNode, spec: ValSpec<T>) {
  console.log('Parsed spec AST:');
  console.log(spec);
  console.log(spec.tag);

  if (node instanceof FunctionDefinition) {
    handleValSpecFunDef(node, spec);
  } else if (node instanceof EventDefinition) {
    // TODO
  } else {
    console.assert(false, 'wow');
  }
}
