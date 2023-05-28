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
import { extractFunName, makeIdsFromVarDecls, makeNewParams } from './utils.js';

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

// TODO: need refactor
function makeGuardedCallFun<T>(
  ctx: ASTContext,
  factory: ASTNodeFactory,
  addrSpec: ValSpec<T>,
  scope: number,
  funName: string,
  params: ParameterList,
  retType: TypeName[],
  returnVarname: string[],
): FunctionDefinition {
  const stmts = [];
  const retTypeStr = retType.length > 0 ? '(' + retType.map((t) => t.typeString).toString() + ')' : 'void';
  const retTypeDecls: VariableDeclaration[] = [];
  let retStmt: Statement | undefined;
  // add check for pre condition
  if (addrSpec.preCond) {
    const errorMsg = 'Violate the precondition';
    const preCondRequireStmt = makeRequireStmt(
      ctx,
      factory,
      factory.makePhantomExpression('bool', addrSpec.preCond as string),
      errorMsg,
    );
    stmts.push(preCondRequireStmt);
  }
  // create original addr call
  // add check for post condition
  if (addrSpec.postCond) {
    const errorMsg = 'Violate the postcondition';
    const postCondRequireStmt = makeRequireStmt(
      ctx,
      factory,
      factory.makePhantomExpression('bool', addrSpec.postCond as string),
      errorMsg,
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
    FunctionKind.Function,
    funName,
    false, // virtual
    FunctionVisibility.Public,
    FunctionStateMutability.Constant,
    false,
    params,
    new ParameterList(0, '', retTypeDecls),
    [], // modifier
    undefined,
    funBody,
  );
  return funDef;
}

// TODO: need refactor
function handlePreFunSpec<T>(
  ctx: ASTContext,
  node: FunctionDefinition,
  factory: ASTNodeFactory,
  preFunSpecs: Array<ValSpec<T>>,
  guardFunName: string,
) {
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
    // TODO: make guardCallFun
    const targetCallArgsDecl: VariableDeclaration[] = targetCallArgs.map((arg) =>
      // TODO: literal and var
      factory.makeVariableDeclaration(
        false,
        false,
        '',
        node.id,
        false,
        DataLocation.Default,
        StateVariableVisibility.Default,
        Mutability.Mutable,
        arg.typeString,
      ),
    );
    const retType: TypeName[] = [
      factory.makeElementaryTypeName('', 'bool'),
      factory.makeElementaryTypeName('', 'bytes memory'),
    ];
    const retVarName: string[] = ['flag', 'data'];
    const guardedCallFun = makeGuardedCallFun(
      ctx,
      factory,
      preFunSpecs[0],
      node.id,
      guardFunName,
      factory.makeParameterList(targetCallArgsDecl),
      retType,
      retVarName,
    );
    node.vScope.appendChild(guardedCallFun);
  } // end for
}

function preCheckFunName(f: string): string {
  return '_' + f + 'Pre';
}

function postCheckFunName(f: string): string {
  return '_' + f + 'Post';
}

function uncheckedFunName(f: string): string {
  return f + '_original';
}

class ValSpecTransformer<T> {
  ctx: ASTContext;
  factory: ASTNodeFactory;
  funDef: FunctionDefinition;
  funName: string;
  spec: ValSpec<T>;
  params: ParameterList;
  retParams: ParameterList;

  constructor(funDef: FunctionDefinition, spec: ValSpec<T>) {
    this.funDef = funDef;
    this.funName = extractFunName(funDef);
    this.spec = spec;
    this.ctx = funDef.context as ASTContext;
    this.factory = new ASTNodeFactory(this.ctx);
    this.params = (this.funDef as FunctionDefinition).vParameters;
    this.retParams = (this.funDef as FunctionDefinition).vReturnParameters;
  }

  makeFlatCheckFun(funName: string, condExpr: T, params: ParameterList): FunctionDefinition {
    const retNode = this.factory.makePhantomExpression('bool', condExpr as string);
    const boolRetVar = this.factory.makeVariableDeclaration(
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
    const retStmt = this.factory.makeReturn(retNode.id, retNode);
    const funBody = this.factory.makeBlock([retStmt]);
    const funDef = this.factory.makeFunctionDefinition(
      this.funDef.scope, // XXX(GW): why?
      FunctionKind.Function,
      funName,
      false, // virtual
      FunctionVisibility.Private,
      FunctionStateMutability.NonPayable,
      false, // funKind == FunctionKind.Constructor,
      params,
      retParams,
      [], //modifier
      undefined,
      funBody,
    );
    return funDef;
  }

  makeTypeDecls(types: TypeName[], names: string[]): VariableDeclaration[] {
    return types.map((ty, i) => {
      const retTypeDecl = this.factory.makeVariableDeclaration(
        false,
        false,
        names[i],
        this.funDef.scope,
        false,
        DataLocation.Default,
        StateVariableVisibility.Default,
        Mutability.Mutable,
        types[i].typeString,
      );
      retTypeDecl.vType = ty;
      return retTypeDecl;
    });
  }

  makeRequireStmt(constraint: Expression, msg: string): ExpressionStatement {
    const callArgs = [
      constraint,
      this.factory.makeLiteral('string', LiteralKind.String, Buffer.from(msg, 'utf8').toString('hex'), msg),
    ];
    const requireFn = this.factory.makeIdentifier('function (bool,string memory) pure', 'require', -1);
    const requireCall = this.factory.makeFunctionCall('bool', FunctionCallKind.FunctionCall, requireFn, callArgs);
    return this.factory.makeExpressionStatement(requireCall);
  }

  makeCheckStmt(funName: string, args: Expression[], errorMsg: string): ExpressionStatement {
    const call = this.factory.makeFunctionCall(
      'bool',
      FunctionCallKind.FunctionCall,
      this.factory.makeIdentifier('function', funName, -1),
      args,
    );
    return this.makeRequireStmt(call, errorMsg);
  }

  preCondCheckFun(): FunctionDefinition | undefined {
    if (this.spec.preCond === undefined) return undefined;
    const preFunName = preCheckFunName(this.funName);
    const inputParams = makeNewParams(this.factory, this.spec.call.args, this.params.vParameters);
    const allParams = new ParameterList(0, '', [...inputParams]);
    const preFunDef = this.makeFlatCheckFun(preFunName, this.spec.preCond, allParams);
    return preFunDef;
  }

  postCondCheckFun(): FunctionDefinition | undefined {
    if (this.spec.postCond === undefined) return undefined;
    const postFunName = postCheckFunName(this.funName);
    const inputParams = makeNewParams(this.factory, this.spec.call.args, this.params.vParameters);
    const retParams = makeNewParams(this.factory, this.spec.call.rets, this.retParams.vParameters);
    const allParams = new ParameterList(0, '', [...inputParams, ...retParams]);
    const postCondFunc = this.makeFlatCheckFun(postFunName, this.spec.postCond, allParams);
    return postCondFunc;
  }

  wrapperFun(
    preCondFun: FunctionDefinition | undefined,
    postCondFun: FunctionDefinition | undefined,
  ): FunctionDefinition | undefined {
    if (preCondFun === undefined && postCondFun === undefined) return undefined;

    const retTypes: TypeName[] = this.retParams.vParameters
      ?.map((param) => param.vType)
      .filter((vType): vType is TypeName => vType !== undefined); // filter out the undefined object
    assert(retTypes.length === this.spec.call.rets.length, 'some return parameters are missing type');

    const retTypeStr = retTypes.length > 0 ? '(' + retTypes.map((t) => t.typeString).toString() + ')' : 'void';
    const retTypeDecls = this.makeTypeDecls(retTypes, this.spec.call.rets);
    const stmts = [];

    // Generate function call to check pre-condition (if any)
    if (preCondFun) {
      const errorMsg = 'Violate the precondition for function ' + this.funName;
      const preCondRequireStmt = this.makeCheckStmt(
        preCondFun.name,
        makeIdsFromVarDecls(this.factory, this.params.vParameters),
        errorMsg,
      );
      stmts.push(preCondRequireStmt);
    }

    // Generate function call to the original function
    const uncheckedCall = this.factory.makeFunctionCall(
      retTypeStr,
      FunctionCallKind.FunctionCall,
      this.factory.makeIdentifier('function', uncheckedFunName(this.funName), -1),
      makeIdsFromVarDecls(this.factory, this.params.vParameters),
    );
    if (retTypeDecls.length > 0) {
      const retIds = retTypeDecls.map((r) => r.id);
      const callAndAssignStmt = this.factory.makeVariableDeclarationStatement(retIds, retTypeDecls, uncheckedCall);
      stmts.push(callAndAssignStmt);
    } else {
      const uncheckedCallStmt = this.factory.makeExpressionStatement(uncheckedCall);
      stmts.push(uncheckedCallStmt);
    }

    // Generate function call to check post-condition (if any)
    if (postCondFun) {
      let postCallArgs = makeIdsFromVarDecls(this.factory, this.params.vParameters);
      if (retTypes.length > 0) {
        postCallArgs = postCallArgs.concat(makeIdsFromVarDecls(this.factory, retTypeDecls));
      }
      const errorMsg = 'Violate the postondition for function ' + this.funName;
      const postRequireStmt = this.makeCheckStmt(postCondFun.name, postCallArgs, errorMsg);
      stmts.push(postRequireStmt);
    }

    // Create the return statement (if any)
    if (retTypeDecls.length > 0) {
      const retValTuple = this.factory.makeTupleExpression(
        retTypeStr,
        false,
        retTypeDecls.map((r) => this.factory.makeIdentifierFor(r)),
      );
      const retStmt = this.factory.makeReturn(retValTuple.id, retValTuple);
      stmts.push(retStmt);
    }

    // Build function body
    const funBody = this.factory.makeBlock(stmts);
    const funDef = this.factory.makeFunctionDefinition(
      this.funDef.scope,
      this.funDef.kind,
      this.funName,
      this.funDef.virtual,
      this.funDef.visibility,
      this.funDef.stateMutability,
      this.funDef.kind == FunctionKind.Constructor,
      this.params,
      new ParameterList(0, '', retTypeDecls),
      [], // modifier
      undefined,
      funBody,
    );

    return funDef;
  }

  apply() {
    const preFun = this.preCondCheckFun();
    if (preFun) this.funDef.vScope.appendChild(preFun);
    const postFun = this.postCondCheckFun();
    if (postFun) this.funDef.vScope.appendChild(postFun);

    const wrapper = this.wrapperFun(preFun, postFun);
    if (wrapper) {
      this.funDef.vScope.appendChild(wrapper);
      this.funDef.name = uncheckedFunName(this.funName);
      this.funDef.visibility = FunctionVisibility.Private;
      if (this.funDef.isConstructor) {
        // If the spec is attached on a constructor, we generate a new constructo,
        // and the original constructor becoems an ordinary function.
        this.funDef.isConstructor = false;
        this.funDef.kind = FunctionKind.Function;
      }
    }
    // TODO(DX): stateMutability: pure/payable/nonpayable ...
    // TODO(DX): data localtion
  }
}

export function handleValSpec<T>(node: ASTNode, spec: ValSpec<T>) {
  console.log('Parsed spec AST:');
  console.log(spec);
  console.log(spec.tag);
  if (node instanceof FunctionDefinition) {
    const trans = new ValSpecTransformer(node, spec);
    trans.apply();
  } else if (node instanceof EventDefinition) {
    // TODO: optional
  } else {
    console.assert(false, 'wow');
  }
}
