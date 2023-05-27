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
  FunctionCall,
  Assignment,
  VariableDeclarationStatement,
  FunctionCallOptions,
} from 'solc-typed-ast';

import { ValSpec } from './spec/index.js';
import { isConstructor, extractFunName } from './utils.js';

function makeFlatCheckFun<T>(
  ctx: ASTContext,
  factory: ASTNodeFactory,
  scope: number,
  funName: string,
  condExpr: T,
  funKind: FunctionKind, // constructor/function/fallback...
  visibility: FunctionVisibility,
  stateMutability: FunctionStateMutability,
  params: ParameterList,
): FunctionDefinition {
  const retNode = factory.makePhantomExpression('bool', condExpr as string);
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

export function makeRequireStmt(
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

function makeCheckStmt(
  ctx: ASTContext,
  factory: ASTNodeFactory,
  funName: string,
  args: Expression[],
  errorMsg: string,
): ExpressionStatement {
  const call = factory.makeFunctionCall(
    'bool',
    FunctionCallKind.FunctionCall,
    factory.makeIdentifier('function', funName, -1),
    args,
  );
  return makeRequireStmt(ctx, factory, call, errorMsg);
}

function makeWrapperFun(
  ctx: ASTContext,
  factory: ASTNodeFactory,
  scope: number,
  funName: string,
  originalFunName: string,
  funKind: FunctionKind,
  funStateMutability: FunctionStateMutability, // payable/nonpayable
  params: ParameterList,
  retType: TypeName[],
  returnVarname: string[],
  preCondFunName?: string,
  postCondFunName?: string,
): FunctionDefinition {
  const stmts = [];
  const retTypeStr = retType.length > 0 ? '(' + retType.map((t) => t.typeString).toString() + ')' : 'void';
  const retTypeDecls: VariableDeclaration[] = [];
  let retStmt: Statement | undefined;

  // Create require pre-condition statement
  if (preCondFunName) {
    const errorMsg = 'Violate the precondition for function ' + funName;
    const preCondRequireStmt = makeCheckStmt(
      ctx,
      factory,
      preCondFunName,
      copyParameters(params.vParameters, factory),
      errorMsg,
    );
    stmts.push(preCondRequireStmt);
  }

  // Create original function call
  const originalCall = factory.makeFunctionCall(
    retTypeStr,
    FunctionCallKind.FunctionCall,
    factory.makeIdentifier('function', originalFunName, -1),
    copyParameters(params.vParameters, factory),
  );

  if (retType.length > 0 && returnVarname) {
    for (let i = 0; i < retType.length; i++) {
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

    const retIds = retTypeDecls.map((r) => r.id);
    const assignmentStmt = factory.makeVariableDeclarationStatement(retIds, retTypeDecls, originalCall);
    stmts.push(assignmentStmt);
    const retValTuple = factory.makeTupleExpression(
      retTypeStr,
      false,
      retTypeDecls.map((r) => factory.makeIdentifierFor(r)),
    );
    retStmt = factory.makeReturn(retValTuple.id, retValTuple);
  } else {
    // no return value
    const originalCallStmt = factory.makeExpressionStatement(originalCall);
    stmts.push(originalCallStmt);
  }

  if (postCondFunName) {
    // Create require post-condition statement
    let postCallArgs = copyParameters(params.vParameters, factory);
    if (retTypeDecls.length > 0) {
      postCallArgs = postCallArgs.concat(copyParameters(retTypeDecls, factory));
    }
    const errorMsg = 'Violate the postondition for function ' + funName;
    const postRequireStmt = makeCheckStmt(ctx, factory, postCondFunName, postCallArgs, errorMsg);
    stmts.push(postRequireStmt);
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
    new ParameterList(0, '', retTypeDecls),
    [], // modifier
    undefined,
    funBody,
  );

  return funDef;
}

function handlePreFunSpec(ctx: ASTContext, node: FunctionDefinition, factory: ASTNodeFactory, guardFunName: string) {
  // TODO: hardcode for now
  const addrArgName = '_addr';
  if (!node.vBody) {
    return;
  }
  for (const statement of node.vBody.vStatements) {
    // Find the target addr.call
    let targetCall: FunctionCall | undefined;
    if (statement instanceof VariableDeclarationStatement) {
      const initValue = statement.vInitialValue;
      // TODO: the identifier name is hardcoded.
      // Q: would there be multiple addr as argument? _addr1, addr2, ...
      if (
        initValue instanceof FunctionCall &&
        initValue.vIdentifier == addrArgName &&
        initValue.vFunctionName == 'call'
      ) {
        targetCall = initValue;
      }
    } else if (statement instanceof Assignment) {
      const rhs = statement.vRightHandSide;
      if (rhs instanceof FunctionCall && rhs.vIdentifier == addrArgName && rhs.vFunctionName == 'call') {
        targetCall = rhs;
      }
    }

    if (!targetCall) {
      continue;
    }
    // init the argument lists for the guarded call.
    let targetCallArgs: Expression[] = (targetCall.vArguments[0] as FunctionCall).vArguments;

    // add value and gas as arguments
    if (targetCall.firstChild instanceof FunctionCallOptions) {
      const optionsMap: Map<string, Expression> = targetCall.firstChild.vOptionsMap;
      const valueOption = optionsMap.get('value');
      const gasOption = optionsMap.get('gas');
      if (gasOption) {
        targetCallArgs = [gasOption, ...targetCallArgs];
      }
      if (valueOption) {
        targetCallArgs = [valueOption, ...targetCallArgs];
      }
    }
    // add addr itself
    targetCallArgs = [factory.makeIdentifier('', addrArgName, -1), ...targetCallArgs];

    const guardFun = factory.makeIdentifier('function', guardFunName, -1);
    const guardedCall = factory.makeFunctionCall(
      targetCall.typeString,
      FunctionCallKind.FunctionCall,
      guardFun,
      targetCallArgs,
    );

    // Replace the old call with the new one
    if (statement instanceof VariableDeclarationStatement) {
      statement.vInitialValue = guardedCall;
    } else if (statement instanceof Assignment) {
      statement.vRightHandSide = guardedCall;
    }
  } // end for
}

function getVarNameDecMap(
  factory: ASTNodeFactory,
  scope: number,
  retVarNames: string[],
  retParams: VariableDeclaration[],
): Map<string, VariableDeclaration> {
  assert(retVarNames.length === retParams.length, 'Return Variable length wrong');
  const varNameDecMap = new Map<string, VariableDeclaration>();

  retVarNames.forEach((name, index) => {
    const type = retParams[index].typeString;
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
    retVarDec.vType = retParams[index].vType;
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
    preFunName = '_' + funName + 'Pre';
    console.log('inserting ' + preFunName);
    const preCondFunc = makeFlatCheckFun(
      ctx,
      factory,
      node.id,
      preFunName,
      spec.preCond,
      FunctionKind.Function, // this is condFunc, always function
      FunctionVisibility.Public,
      FunctionStateMutability.NonPayable,
      (node as FunctionDefinition).vParameters,
    );
    node.vScope.appendChild(preCondFunc);
  }

  if (spec.postCond !== undefined) {
    postFunName = '_' + funName + 'Post';
    console.log('inserting ' + postFunName);
    const inputParam = (node as FunctionDefinition).vParameters.vParameters;
    const retParams = (node as FunctionDefinition).vReturnParameters.vParameters;
    const varNameDecMap = getVarNameDecMap(factory, node.id, spec.call.rets, retParams);

    const allParams = new ParameterList(0, '', [...inputParam, ...Array.from(varNameDecMap.values())]);
    const postCondFunc = makeFlatCheckFun(
      ctx,
      factory,
      node.id,
      postFunName,
      spec.postCond,
      FunctionKind.Function, // this is condFunc, always function
      FunctionVisibility.Public,
      FunctionStateMutability.NonPayable,
      allParams,
    );
    node.vScope.appendChild(postCondFunc);
  }

  if (spec.preFunSpec) {
    // only handle address for now
    // only handle first order preFunSpec
    handlePreFunSpec(ctx, node, factory, 'guardedCall');
  }
  if (spec.postFunSpec) {
    // addr: not supported
  }

  if (spec.preCond || spec.postCond) {
    console.log('inserting ValSpec wrapper function for ' + funName);

    const retTypes: TypeName[] = node.vReturnParameters.vParameters
      ?.map((param) => param.vType)
      .filter((vType): vType is TypeName => vType !== undefined); // filter out the undefined object
    assert(retTypes.length === spec.call.rets.length, 'some return parameters are missing type');
    const retVarNames: string[] = spec.call.rets;

    const wrapperFun = makeWrapperFun(
      ctx,
      factory,
      node.id,
      funName,
      originalFunName,
      isConstructor(node) ? FunctionKind.Constructor : FunctionKind.Function,
      node.stateMutability,
      (node as FunctionDefinition).vParameters,
      retTypes,
      retVarNames,
      preFunName,
      postFunName,
    );
    node.vScope.appendChild(wrapperFun);
    node.visibility = FunctionVisibility.Private;
    // TODO: stateMutability: pure/payable/nonpayable ...
    // TODO: data localtion
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
    // TODO: optional
  } else {
    console.assert(false, 'wow');
  }
}
