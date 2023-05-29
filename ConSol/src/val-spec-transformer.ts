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
  MemberAccess,
  Identifier,
  Literal,
} from 'solc-typed-ast';

import { ValSpec } from './spec/index.js';
import { extractFunName, makeIdsFromVarDecls, makeNewParams, strToTypeName } from './utils.js';

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
    const retType: TypeName[] = [strToTypeName(factory, 'bool'), strToTypeName(factory, 'bytes memory')];
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

/////////////////////////////////////////////////////////////////////

function preCheckFunName(f: string): string {
  return '_' + f + 'Pre';
}

function postCheckFunName(f: string): string {
  return '_' + f + 'Post';
}

function uncheckedFunName(f: string): string {
  return f + '_original';
}

function properAddrName<T>(addr: string, member: string): string {
  return addr + '_' + member;
}

function extractRawAddr<T>(spec: ValSpec<T>): string {
  // Note(GW): spec.call.addr is optional by the definition of garmmar.
  // If it is undefined, then we are handling an address spec that only has a single callee.
  // In this case, the funName field is actually the variable name for the address,
  // and we synthesis the default callable member name (i.e. call);
  // Otherwise, we are handling member access call (e.g. addr.send).
  // TODO(GW): need test the "oterhwise" case.
  if (spec.call.addr === undefined) return spec.call.funName;
  else return spec.call.addr;
}

function extractAddrMember<T>(spec: ValSpec<T>): string {
  if (spec.call.addr === undefined) return 'call';
  else return spec.call.funName;
}

class ValSpecTransformer<T> {
  ctx: ASTContext;
  factory: ASTNodeFactory;
  scope: number;
  spec: ValSpec<T>;
  tgtName: string
  // Note(GW): these are parameters used for generating check functions, but they may not have correct binding names
  params: VariableDeclaration[];
  retParams: VariableDeclaration[];

  constructor(
    ctx: ASTContext,
    scope: number,
    spec: ValSpec<T>,
    tgtName: string,
    params: VariableDeclaration[],
    retParams: VariableDeclaration[],
    factory?: ASTNodeFactory,
  ) {
    this.ctx = ctx;
    this.scope = scope;
    this.spec = spec;
    this.tgtName = tgtName;
    if (factory === undefined) {
      this.factory = new ASTNodeFactory(this.ctx);
    } else {
      this.factory = factory;
    }
    this.params = params;
    this.retParams = retParams;
  }

  makeFlatCheckFun(funName: string, condExpr: T, params: ParameterList): FunctionDefinition {
    const retNode = this.factory.makePhantomExpression('bool', condExpr as string);
    const boolRetVar = this.factory.makeVariableDeclaration(
      false, // constant
      false, // indexed
      'bool', // name // FIME(GW): this doesn't look right
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
    const checkFunDef = this.factory.makeFunctionDefinition(
      this.scope,
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
    return checkFunDef;
  }

  makeTypedVarDecls(types: TypeName[], names: string[]): VariableDeclaration[] {
    assert(types.length == names.length, "The number of types should equal to the number of names");
    return types.map((ty, i) => {
      const retTypeDecl = this.factory.makeVariableDeclaration(
        false,
        false,
        names[i],
        this.scope,
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

  makeNamelessTypedVarDecls(types: TypeName[]): VariableDeclaration[] {
    return types.map((ty, i) => {
      const retTypeDecl = this.factory.makeVariableDeclaration(
        false,
        false,
	'',
        this.scope,
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
    const preFunName = preCheckFunName(this.tgtName);
    // FIXME(GW): should use factory.makeParameterList...
    const args = [...this.spec.call.kwargs.map((p) => p.fst), ...this.spec.call.args];
    const params = makeNewParams(this.factory, args, this.params);
    const allParams = new ParameterList(0, '', [...params]);
    const preFunDef = this.makeFlatCheckFun(preFunName, this.spec.preCond, allParams);
    return preFunDef;
  }

  postCondCheckFun(): FunctionDefinition | undefined {
    if (this.spec.postCond === undefined) return undefined;
    const postFunName = postCheckFunName(this.tgtName);
    const args = [...this.spec.call.kwargs.map((p) => p.fst), ...this.spec.call.args];
    const rets = [...args, ...this.spec.call.rets];
    const retParams = makeNewParams(this.factory, rets, [...this.params, ...this.retParams]);
    const allParams = new ParameterList(0, '', [...retParams]);
    const postCondFunc = this.makeFlatCheckFun(postFunName, this.spec.postCond, allParams);
    return postCondFunc;
  }
}

class AddrValSpecTransformer<T> extends ValSpecTransformer<T> {
  parentFunDef: FunctionDefinition;
  addr: string;
  member: string;
  tgtAddr: VariableDeclaration;
  callsites: (FunctionCallOptions | FunctionCall)[] = [];

  constructor(
    parent: FunctionDefinition,
    tgtAddr: VariableDeclaration,
    spec: ValSpec<T>,
    ctx: ASTContext,
    scope: number,
    factory?: ASTNodeFactory,
  ) {
    const addr = extractRawAddr(spec);
    const member = extractAddrMember(spec);
    super(ctx, scope, spec, addr, [], [], factory);
    this.addr = addr;
    this.member = member;
    this.tgtAddr = tgtAddr;
    this.parentFunDef = parent;
    const [argTypes, retTypes] = this.findAddressSignature(properAddrName(tgtAddr.name, this.member));
    this.params = this.makeNamelessTypedVarDecls(argTypes);
    this.retParams = this.makeNamelessTypedVarDecls(retTypes);
  }

  extractSigFromFuncCallOptions(call: FunctionCallOptions): string {
    const parentCall = call.parent;
    assert(parentCall instanceof FunctionCall, 'Must have a parent');
    assert(
      parentCall.vExpression instanceof FunctionCallOptions,
      'This is the callee w/ options (ie the current call itself)',
    );
    return this.extractSigFromFuncCall(parentCall);
  }
  extractSigFromFuncCall(call: FunctionCall): string {
    const encodeCall = call.vArguments[0];
    // TODO(GW): this is not enough, consider the data can be encoded else where and passed to here.
    assert(encodeCall instanceof FunctionCall, 'This is the abi.encodeWithSignature call');
    // TODO(GW): again, this is not enough, consider the signature
    // string could be an aribrary expression instead of literal string.
    // Note(GW): for those cases that we cannot infer cheaply, we should ask user to provide more precise signature...
    return (encodeCall.vArguments[0] as Literal).value;
  }
  extractSigFromCall(call: FunctionCallOptions | FunctionCall): string {
    if (call instanceof FunctionCallOptions) {
      return this.extractSigFromFuncCallOptions(call);
    }
    if (call instanceof FunctionCall) {
      return this.extractSigFromFuncCall(call);
    }
    assert(false, 'dumbo type checker');
  }
  extractOptions(call: FunctionCallOptions | FunctionCall): Array<string> {
    if (call instanceof FunctionCallOptions) {
      // Caveat(GW): call.names is an iterator over keys of map; the order may not be the same as in the program
      return [...call.names];
    }
    return [];
  }
  optionsToTypeName(keys: Array<string>): Array<TypeName> {
    return keys.map((key) => {
      if (key === 'value') return strToTypeName(this.factory, 'uint256');
      if (key === 'gas') return strToTypeName(this.factory, 'uint256');
      assert(false, 'what else?');
    });
  }
  signatureArgsToTypeName(sig: string): Array<TypeName> {
    const args = sig.substring(sig.indexOf('(') + 1, sig.lastIndexOf(')'));
    return args.split(',').map((ty) => {
      if (ty === 'string') return strToTypeName(this.factory, 'string');
      return strToTypeName(this.factory, ty);
    });
  }
  defaultAddrRetTypes(): Array<TypeName> {
    return [strToTypeName(this.factory, 'bool'), strToTypeName(this.factory, 'bytes')];
  }

  findAddressSignature(properAddr: string): [Array<TypeName>, Array<TypeName>] {
    assert(this.parentFunDef.vBody !== undefined, 'Empty function body');
    this.callsites = this.parentFunDef.vBody.getChildrenBySelector((node: ASTNode) => {
      if (!(node instanceof FunctionCallOptions || node instanceof FunctionCall)) return false;
      if (!(node.vExpression instanceof MemberAccess)) return false;
      if (!(node.vExpression.vExpression instanceof Identifier)) return false;
      // TODO(GW): simply comparing address identifier expression is not enough,
      // consider address value flow...
      // TODO(GW): should also check if the call-site arity matches `spec`.
      const found = properAddrName(node.vExpression.vExpression.name, node.vExpression.memberName);
      console.log(found + ' and ' + properAddr);
      return found == properAddr;
    });
    assert(this.callsites.length > 0, 'Cannot find any call site for ' + properAddr);

    // If there are mutiple call-sites, their signatures has to be the same, so let's pick a lucky one
    const callsite = this.callsites[0];
    const options = this.extractOptions(callsite);
    const signature = this.extractSigFromCall(callsite);
    const argTypes = this.optionsToTypeName(options);
    argTypes.push(...this.signatureArgsToTypeName(signature));
    const retTypes = this.defaultAddrRetTypes();
    return [argTypes, retTypes];
  }

  guardedFun(): FunctionDefinition {
    return this.factory.makeFunctionDefinition(
      this.scope,
      FunctionKind.Function,
      'dummy',
      false,
      FunctionVisibility.Private,
      FunctionStateMutability.NonPayable,
      false,
      new ParameterList(0, '', []),
      new ParameterList(0, '', []),
      [],
      undefined,
      this.factory.makeBlock([]),
    );
  }

  apply(): void {
    const preFun = this.preCondCheckFun();
    if (preFun) this.parentFunDef.vScope.appendChild(preFun);
    const postFun = this.postCondCheckFun();
    if (postFun) this.parentFunDef.vScope.appendChild(postFun);

    this.parentFunDef.vScope.appendChild(this.guardedFun());
  }
}

class FunDefValSpecTransformer<T> extends ValSpecTransformer<T> {
  funDef: FunctionDefinition;
  retTypes: TypeName[];
  declaredParams: VariableDeclaration[];
  declaredRetParams: VariableDeclaration[];

  constructor(funDef: FunctionDefinition, spec: ValSpec<T>) {
    const declaredParams = (funDef as FunctionDefinition).vParameters.vParameters;
    const declaredRetParams = (funDef as FunctionDefinition).vReturnParameters.vParameters;
    super(funDef.context as ASTContext, funDef.scope, spec, extractFunName(funDef), declaredParams, declaredRetParams);
    this.declaredParams = declaredParams;
    this.declaredRetParams = declaredRetParams;
    this.funDef = funDef;
    this.retTypes = this.declaredRetParams
      .map((param) => param.vType)
      .filter((vType): vType is TypeName => vType !== undefined); // filter out the undefined object
  }

  guardedFun(
    preCondFun: FunctionDefinition | undefined,
    postCondFun: FunctionDefinition | undefined,
  ): FunctionDefinition | undefined {
    if (preCondFun === undefined && postCondFun === undefined) return undefined;

    assert(this.retTypes.length === this.spec.call.rets.length, 'some return parameters are missing type');

    const retTypeStr =
      this.retTypes.length > 0 ? '(' + this.retTypes.map((t) => t.typeString).toString() + ')' : 'void';
    const retTypeDecls = this.makeTypedVarDecls(this.retTypes, this.spec.call.rets);
    const stmts = [];

    // Generate function call to check pre-condition (if any)
    if (preCondFun) {
      const errorMsg = 'Violate the precondition for function ' + this.tgtName;
      const preCondRequireStmt = this.makeCheckStmt(
        preCondFun.name,
        makeIdsFromVarDecls(this.factory, this.declaredParams),
        errorMsg,
      );
      stmts.push(preCondRequireStmt);
    }

    // Generate function call to the original function
    const uncheckedCall = this.factory.makeFunctionCall(
      retTypeStr,
      FunctionCallKind.FunctionCall,
      this.factory.makeIdentifier('function', uncheckedFunName(this.tgtName), -1),
      makeIdsFromVarDecls(this.factory, this.declaredParams),
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
      let postCallArgs = makeIdsFromVarDecls(this.factory, this.declaredParams);
      if (this.retTypes.length > 0) {
        postCallArgs = postCallArgs.concat(makeIdsFromVarDecls(this.factory, retTypeDecls));
      }
      const errorMsg = 'Violate the postondition for function ' + this.tgtName;
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
      this.tgtName,
      this.funDef.virtual,
      this.funDef.visibility,
      this.funDef.stateMutability,
      this.funDef.kind == FunctionKind.Constructor,
      this.funDef.vParameters,
      this.funDef.vReturnParameters,
      [], // modifier
      undefined,
      funBody,
    );

    return funDef;
  }

  findTargetAddr(def: FunctionDefinition, parentSpec: ValSpec<T>, addr: string): VariableDeclaration {
    return def.vParameters.vParameters[parentSpec.call.args.findIndex((a) => a === addr)];
  }

  addrTransformers(addrSpec: ValSpec<T>): AddrValSpecTransformer<T> {
    const tgtAddr = this.findTargetAddr(this.funDef, this.spec, extractRawAddr(addrSpec));
    return new AddrValSpecTransformer(this.funDef, tgtAddr, addrSpec, this.ctx, this.scope, this.factory);
  }

  apply(): void {
    const preFun = this.preCondCheckFun();
    if (preFun) this.funDef.vScope.appendChild(preFun);
    const postFun = this.postCondCheckFun();
    if (postFun) this.funDef.vScope.appendChild(postFun);

    // step 1: generate guarded address call function
    // step 2: replace all address call with the guarded address call
    if (this.spec.preFunSpec !== undefined) { // XXX(GW): this seems unnecessary; preFunSpepc is an array
      const addrTrans = this.spec.preFunSpec.map((s) => this.addrTransformers(s));
      addrTrans.forEach((tr) => {
	tr.apply();
      });
    }

    const wrapper = this.guardedFun(preFun, postFun);
    if (wrapper) {
      this.funDef.vScope.appendChild(wrapper);
      this.funDef.name = uncheckedFunName(this.tgtName);
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
    const trans = new FunDefValSpecTransformer(node, spec);
    trans.apply();
  } else if (node instanceof EventDefinition) {
    // TODO: optional
  } else {
    console.assert(false, 'wow');
  }
}
