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
  TypeName,
  FunctionCallKind,
  ExpressionStatement,
  Expression,
  Statement,
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
  const retNode = factory.makeLiteral(
    'bool',
    LiteralKind.Bool,
    '1',
    'true',
  );
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

function copyParameters(params: VariableDeclaration[], factory: ASTNodeFactory) {
  return params.map((param) => factory.makeIdentifierFor(param));
}

function createWrapperFun(
  ctx: ASTContext,
  factory: ASTNodeFactory,
  scope: number, // TODO scope?
  funName: string,
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
  // factory.makeIdentifier('function', funName, originalFunId)
  const funId = factory.makeIdentifier('function', funName, -1); // buggy
  const originalCall = factory.makeFunctionCall(
    retType ? retType.typeString : 'void',
    FunctionCallKind.FunctionCall,
    funId,
    copyParameters(params.vParameters, factory),
  );
  // let returnValId : Identifier | undefined;
  let retValDecl: VariableDeclaration | undefined;
  let retStmt: Statement | undefined;
  if (retType && returnVarname) {
    retValDecl = factory.makeVariableDeclaration(
      false,
      false,
      returnVarname,
      scope, // scope
      false,
      DataLocation.Default,
      StateVariableVisibility.Default,
      Mutability.Constant,
      retType.typeString,
    );
    // returnValId = factory.makeIdentifierFor(retVarDecl);
    const asnmt = factory.makeAssignment(
      retType.typeString,
      '=',
      factory.makeIdentifierFor(retValDecl),
      originalCall,
    );

    const asnmtStmt = factory.makeExpressionStatement(asnmt);
    stmts.push(asnmtStmt);

    retStmt = factory.makeReturn(retValDecl.id);
  } else {
    // no return value
    const originalCallStmt = factory.makeExpressionStatement(originalCall);
    stmts.push(originalCallStmt);
  }

  if (postCondFunName) {
    // Create require post-condition statement
    let postCallParamList;
    if (retValDecl) {
      postCallParamList = [
        ...copyParameters(params.vParameters, factory),
        factory.makeIdentifierFor(retValDecl),
      ];
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
    funName + '_wrapper', // TODO: rename original func
    false, // virtual
    FunctionVisibility.Public,
    funStateMutability,
    funKind == FunctionKind.Constructor,
    params,
    retValDecl
      ? new ParameterList(0, '', [retValDecl])
      : new ParameterList(0, '', []),
    [], // modifier
    undefined,
    funBody,
  );

  return funDef;
}

function handleValSpecFunDef<T>(node: FunctionDefinition, spec: ValSpec<T>) {
  const funName = extractFunName(node);
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
    const postCondFunc = makeFlatCheckFun(
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
  if (spec.call !== undefined) {
    console.log('inserting ValSpec wrapper function for ' + funName);
    const wrapperFun = createWrapperFun(
      ctx,
      factory,
      node.id,
      funName,
      isConstructor(node) ? FunctionKind.Constructor : FunctionKind.Function,
      node.stateMutability,
      (node as FunctionDefinition).vParameters,
      node.id,
      undefined, //TOOD
      undefined,
      preFunName,
      postFunName,
    );
    node.vScope.appendChild(wrapperFun);
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
