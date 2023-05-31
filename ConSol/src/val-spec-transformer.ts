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
import { attachNames, extractFunName, strToTypeName } from './utils.js';

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

class ConSolTransformer {
  factory: ASTNodeFactory

  constructor(factory: ASTNodeFactory) {
    this.factory = factory;
  }

  copyNodes<T extends ASTNode>(nodes: Array<T>): Array<T> {
    const newNodes: Array<T> = [];
    nodes.forEach((node, i) => {
      newNodes.push(this.factory.copy(node));
    });
    return newNodes;
  }

  makeNewParams(names: string[], decls: VariableDeclaration[]): VariableDeclaration[] {
    const params = this.copyNodes(decls);
    attachNames(names, params);
    return params;
  }

  makeIdFromVarDecl(vd: VariableDeclaration): Identifier {
    return this.factory.makeIdentifierFor(vd);
  }

  makeIdsFromVarDecls(vds: VariableDeclaration[]): Identifier[] {
    return vds.map((vd) => this.makeIdFromVarDecl(vd));
  }
}

class ValSpecTransformer<T> extends ConSolTransformer {
  ctx: ASTContext;
  scope: number;
  spec: ValSpec<T>;
  tgtName: string;
  // Note(GW): these are parameters used for generating check functions, but they may not have correct binding names
  params: VariableDeclaration[];
  retParams: VariableDeclaration[];
  guardedParamNames: string[];
  guardedRetParamNames: string[];
  guardedAllParamNames: string[];

  constructor(
    ctx: ASTContext,
    scope: number,
    spec: ValSpec<T>,
    tgtName: string,
    params: VariableDeclaration[],
    retParams: VariableDeclaration[],
    factory?: ASTNodeFactory,
  ) {
    if (factory === undefined) {
      super(new ASTNodeFactory(ctx));
    } else {
      super(factory);
    }
    this.ctx = ctx;
    this.scope = scope;
    this.spec = spec;
    this.tgtName = tgtName;
    this.params = params;
    this.retParams = retParams;
    this.guardedParamNames = [...this.spec.call.kwargs.map((p) => p.snd), ...this.spec.call.args];
    this.guardedRetParamNames = this.spec.call.rets;
    this.guardedAllParamNames = [...this.guardedParamNames, ...this.guardedRetParamNames];
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
    assert(types.length == names.length, 'The number of types should equal to the number of names');
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
    const params = this.makeNewParams(this.guardedParamNames, this.params);
    const allParams = new ParameterList(0, '', [...params]);
    const preFunDef = this.makeFlatCheckFun(preFunName, this.spec.preCond, allParams);
    return preFunDef;
  }

  postCondCheckFun(): FunctionDefinition | undefined {
    if (this.spec.postCond === undefined) return undefined;
    const postFunName = postCheckFunName(this.tgtName);
    const rets = [...this.guardedParamNames, ...this.guardedRetParamNames];
    const retParams = this.makeNewParams(rets, [...this.params, ...this.retParams]);
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
  callsites: FunctionCall[] = [];
  optTypes: TypeName[];
  argTypes: TypeName[];
  retTypes: TypeName[];

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
    const [optTypes, argTypes, retTypes] = this.findAddressSignature(properAddrName(tgtAddr.name, this.member));
    this.optTypes = optTypes;
    this.argTypes = argTypes;
    this.retTypes = retTypes;
    this.params = this.makeNamelessTypedVarDecls([...optTypes, ...argTypes]);
    this.retParams = this.makeNamelessTypedVarDecls(retTypes);
  }

  extractSigFromFuncCallOptions(call: FunctionCallOptions): string {
    const parentCall = call.parent;
    assert(parentCall instanceof FunctionCall, 'Must have a parent');
    assert(
      parentCall.vExpression instanceof FunctionCallOptions,
      'This is the callee w/ options (ie the current call itself)',
    );
    return this.extractSigFromCall(parentCall);
  }
  extractSigFromCall(call: FunctionCall): string {
    const encodeCall = call.vArguments[0];
    // TODO(GW): this is not enough, consider the data can be encoded else where and passed to here.
    assert(encodeCall instanceof FunctionCall, 'This is the abi.encodeWithSignature call');
    // TODO(GW): again, this is not enough, consider the signature
    // string could be an aribrary expression instead of literal string.
    // Note(GW): for those cases that we cannot infer cheaply, we should ask user to provide more precise signature...
    return (encodeCall.vArguments[0] as Literal).value;
  }
  extractOptions(call: FunctionCall): Array<string> {
    if (call.vExpression instanceof FunctionCallOptions) {
      // Caveat(GW): call.names is an iterator over keys of map; the order may not be the same as in the program
      return [...call.vExpression.names];
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

  findAddressSignature(properAddr: string): [Array<TypeName>, Array<TypeName>, Array<TypeName>] {
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
    }).map((call: ASTNode) => {
      if (call instanceof FunctionCallOptions) {
	const parentCall = call.parent;
	assert(parentCall instanceof FunctionCall, 'Must have a parent');
	assert(
	  parentCall.vExpression instanceof FunctionCallOptions,
	  'This is the callee w/ options (ie the current call itself)',
	);
	return parentCall;
      }
      if (call instanceof FunctionCall) {
	return call;
      }
      assert(false, "dumbo type checker");
    });
    assert(this.callsites.length > 0, 'Cannot find any call site for ' + properAddr);

    // If there are mutiple call-sites, their signatures has to be the same, so let's pick a lucky one
    const callsite = this.callsites[0];
    const options = this.extractOptions(callsite);
    const signature = this.extractSigFromCall(callsite);
    const optTypes = this.optionsToTypeName(options);
    const argTypes = this.signatureArgsToTypeName(signature);
    const retTypes = this.defaultAddrRetTypes();
    return [optTypes, argTypes, retTypes];
  }

  // replace address, replace value, gas, all other arguments
  makeNewAddressCall(original: FunctionCall): FunctionCall {
    const newCall = this.factory.copy(original);
    const callee = this.factory.makeIdentifier('', this.addr, -1);
    if (newCall.vExpression instanceof FunctionCallOptions) {
      newCall.vExpression.vExpression = callee
      // TODO(GW): kwargs should be stored as a map at the very beginning
      const options = new Map(Array.from(this.spec.call.kwargs, (p) => [p.fst, p.snd]));
      newCall.vExpression.vOptionsMap = new Map(Array.from(newCall.vExpression.vOptionsMap, ([k, v]) => {
	const keyArg = options.get(k);
	assert(keyArg !== undefined, "Specification doesn't have key " + k);
	return [k, this.factory.makeIdentifier('', keyArg, -1)];
      }));
    } else if (newCall.vExpression instanceof Identifier) {
      newCall.vExpression = callee
    }
    const newArgs = this.makeIdsFromVarDecls(this.makeNewParams(this.spec.call.args, this.makeNamelessTypedVarDecls(this.argTypes)));
    newCall.vArguments = newArgs;
    return newCall;
  }

  guardedFun(
    preCondFun: FunctionDefinition | undefined,
    postCondFun: FunctionDefinition | undefined,
  ): FunctionDefinition | undefined {
    if (preCondFun === undefined && postCondFun === undefined) return undefined;

    const retTypeStr = '(' + this.retTypes.map((t) => t.typeString).toString() + ')';
    const retTypeDecls = this.makeTypedVarDecls(this.retTypes, this.spec.call.rets);

    const params = this.makeNewParams(this.guardedParamNames, this.params);
    const retParams = this.makeNewParams(this.guardedAllParamNames, [...this.params, ...this.retParams]);

    const stmts = [];

    // Generate function call to check pre-condition (if any)
    if (preCondFun) {
      const errorMsg = 'Violate the precondition for address ' + this.tgtName;
      const preCondRequireStmt = this.makeCheckStmt(
        preCondFun.name,
        this.makeIdsFromVarDecls(params),
        errorMsg,
      );
      stmts.push(preCondRequireStmt);
    }

    // Generate address call to the address, replace arguments
    const uncheckedCall = this.makeNewAddressCall(this.callsites[0]);
    assert(uncheckedCall !== undefined, "what");
    console.log(uncheckedCall)
    const retIds = retTypeDecls.map((r) => r.id);
    const callAndAssignStmt = this.factory.makeVariableDeclarationStatement(retIds, retTypeDecls, uncheckedCall);
    stmts.push(callAndAssignStmt);

    // Generate function call to check post-condition (if any)
    if (postCondFun) {
      const postCallArgs = this.makeIdsFromVarDecls(retParams);
      const errorMsg = 'Violate the postondition for address ' + this.tgtName;
      const postRequireStmt = this.makeCheckStmt(postCondFun.name, postCallArgs, errorMsg);
      stmts.push(postRequireStmt);
    }

    // Create the return statement (if any)
    const retValTuple = this.factory.makeTupleExpression(
      retTypeStr,
      false,
      retTypeDecls.map((r) => this.factory.makeIdentifierFor(r)),
    );
    const retStmt = this.factory.makeReturn(retValTuple.id, retValTuple);
    stmts.push(retStmt);

    // Build function body
    const funBody = this.factory.makeBlock(stmts);
    const addrParam = this.makeNamelessTypedVarDecls([strToTypeName(this.factory, 'address')]);
    const guardedParams = this.makeNewParams([this.addr, ...this.guardedParamNames], [addrParam[0], ...this.params]);
    const guardedRetParams = this.makeNewParams(
      this.spec.call.rets,
      this.makeNamelessTypedVarDecls(this.defaultAddrRetTypes()),
    );
    // TODO: double check following arguments
    const funDef = this.factory.makeFunctionDefinition(
      this.parentFunDef.scope,
      FunctionKind.Function,
      'guarded_' + this.parentFunDef.name + '_' + this.tgtName,
      this.parentFunDef.virtual,
      this.parentFunDef.visibility,
      this.parentFunDef.stateMutability,
      false,
      new ParameterList(0, '', guardedParams),
      new ParameterList(0, '', guardedRetParams),
      [], // modifier
      undefined,
      funBody,
    );

    return funDef;
  }

  apply(): void {
    const preFun = this.preCondCheckFun();
    if (preFun) this.parentFunDef.vScope.appendChild(preFun);
    const postFun = this.postCondCheckFun();
    if (postFun) this.parentFunDef.vScope.appendChild(postFun);

    // step 1: generate guarded address call function
    const wrapper = this.guardedFun(preFun, postFun);
    if (wrapper) {
      this.parentFunDef.vScope.appendChild(wrapper);

      // step 2: replace all address call with the guarded address call
      // TODO
    }
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
        this.makeIdsFromVarDecls(this.declaredParams),
        errorMsg,
      );
      stmts.push(preCondRequireStmt);
    }

    // Generate function call to the original function
    const uncheckedCall = this.factory.makeFunctionCall(
      retTypeStr,
      FunctionCallKind.FunctionCall,
      this.factory.makeIdentifier('function', uncheckedFunName(this.tgtName), -1),
      this.makeIdsFromVarDecls(this.declaredParams),
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
      let postCallArgs = this.makeIdsFromVarDecls(this.declaredParams);
      if (this.retTypes.length > 0) {
        postCallArgs = postCallArgs.concat(this.makeIdsFromVarDecls(retTypeDecls));
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

    if (this.spec.preFunSpec !== undefined) {
      // XXX(GW): this seems unnecessary; preFunSpepc is an array
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
