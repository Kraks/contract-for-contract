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
  retType?: TypeName[] | undefined, //can be void
  returnVarname?: string[] | undefined,
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
    retType ? retType[0].typeString : 'void', //TODO fix, seems ok
    FunctionCallKind.FunctionCall,
    factory.makeIdentifier('function', originalFunName, -1),
    copyParameters(params.vParameters, factory),
  );
  // let returnValId : Identifier | undefined;
  const retTypeDecls: VariableDeclaration[] | undefined = []; // has name info
  const retValDecls: VariableDeclaration[] | undefined = []; // has type info
  let retStmt: Statement | undefined;
  if (retType && returnVarname) {
    for (let i = 0; i < retType.length; i++) {
      const retValDecl = factory.makeVariableDeclaration(
        false,
        false,
        returnVarname[i],
        scope, // scope
        false,
        DataLocation.Default,
        StateVariableVisibility.Default,
        Mutability.Mutable,
        retType[i].typeString,
      );
      retValDecls.push(retValDecl);
      const retTypeDecl = factory.makeVariableDeclaration(
        false,
        false,
        returnVarname[i],
        scope, // scope
        false,
        DataLocation.Default,
        StateVariableVisibility.Default,
        Mutability.Mutable,
        retType[i].typeString,
      );
      retTypeDecl.vType = retType[i];
      retTypeDecls.push(retTypeDecl);
    }

    if (retTypeDecls.length > 1) {
      // more than one returns
      // declare return variables first
      for (let i = 0; i < retTypeDecls.length; i++) {
        const retVarDecStmt = factory.makeVariableDeclarationStatement([null], [retTypeDecls[i]]);
        stmts.push(retVarDecStmt);
      }

      const retValTuple = factory.makeTupleExpression(
        retType[0].typeString, // TODO this should also be a tuple? seems ok
        false,
        retValDecls.map((r) => factory.makeIdentifierFor(r)),
      );
      // assignment

      const assignmentStmt = factory.makeAssignment(retType[0].typeString, '=', retValTuple, originalCall);
      stmts.push(factory.makeExpressionStatement(assignmentStmt));
      retStmt = factory.makeReturn(retValTuple.id, retValTuple);
    } else {
      // only one return
      assert(retValDecls.length == 1 && retTypeDecls.length == retValDecls.length, 'impossible');
      const assignmentStmt = factory.makeVariableDeclarationStatement([null], retTypeDecls, originalCall);
      stmts.push(assignmentStmt);
      retStmt = factory.makeReturn(retValDecls[0].id, retValDecls[0]);
    }
  } else {
    // no return value
    const originalCallStmt = factory.makeExpressionStatement(originalCall);
    stmts.push(originalCallStmt);
  }

  if (postCondFunName) {
    // Create require post-condition statement
    let postCallParamList;
    if (retTypeDecls) {
      postCallParamList = [...copyParameters(params.vParameters, factory), ...copyParameters(retTypeDecls, factory)];
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
    retTypeDecls ? new ParameterList(0, '', retTypeDecls) : new ParameterList(0, '', []),
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
  const originalFunName = funName + '_original';
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

    let returnTypes: TypeName[] | undefined;
    let returnVarNames: string[] | undefined;
    if (spec.call.rets.length > 0) {
      returnTypes = node.vReturnParameters.vParameters
        ?.map((param) => param.vType)
        .filter((vType): vType is TypeName => vType !== undefined); // filter out the undefined object
      assert(returnTypes.length === spec.call.rets.length, 'some return parameters are missing type');

      returnVarNames = spec.call.rets;
    }

    const wrapperFun = createWrapperFun(
      ctx,
      factory,
      node.id,
      funName,
      originalFunName,
      isConstructor(node) ? FunctionKind.Constructor : FunctionKind.Function,
      node.stateMutability,
      (node as FunctionDefinition).vParameters,
      returnTypes,
      returnVarNames,
      preFunName,
      postFunName,
    );
    node.vScope.appendChild(wrapperFun);
    node.visibility = FunctionVisibility.Private;
    // TODO: stateMutability: pure/payable/nonpayable ...
    if (node.isConstructor) {
      node.isConstructor = false;
      node.kind = FunctionKind.Function;
    }
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
