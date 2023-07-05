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
  assert,
  TypeName,
  FunctionCall,
  FunctionCallOptions,
  MemberAccess,
  Identifier,
  Literal,
  replaceNode,
  StructuredDocumentation,
  ContractDefinition,
  ErrorDefinition,
} from 'solc-typed-ast';

import { ValSpec } from './spec/index.js';
import { attachNames, extractFunName } from './utils.js';
import { SPEC_PREFIX, isConSolSpec } from './utils.js';
import { CSSpecParse, CSSpecVisitor, CSSpec, isValSpec, isTempSpec } from './spec/index.js';

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

function needAbiEncoding(member: string): boolean {
  return member === 'call' || member === 'delegatecall' || member === 'staticcall';
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
  // FIXME(GW): parser error for the "otherwise" case
  if (spec.call.addr === undefined) return spec.call.funName;
  else return spec.call.addr;
}

function extractAddrMember<T>(spec: ValSpec<T>): string {
  if (spec.call.addr === undefined) return 'call';
  else return spec.call.funName;
}

class ConSolTransformer {
  factory: ASTNodeFactory;
  scope: number;

  constructor(factory: ASTNodeFactory, scope: number) {
    this.factory = factory;
    this.scope = scope;
  }

  strToTypeName(str: string): TypeName {
    if (str === 'bytes') return this.factory.makeElementaryTypeName('', 'bytes memory');
    if (str === 'string') return this.factory.makeElementaryTypeName('', 'string memory');
    // TODO(GW): other types with storage modifier
    return this.factory.makeElementaryTypeName('', str);
  }

  copyNodes<T extends ASTNode>(nodes: Array<T>): Array<T> {
    const newNodes: Array<T> = [];
    nodes.forEach((node, i) => {
      newNodes.push(this.factory.copy(node));
    });
    return newNodes;
  }

  makeVarDecs(names: string[], decls: VariableDeclaration[]): VariableDeclaration[] {
    const params = this.copyNodes(decls);
    attachNames(names, params);
    return params;
  }

  makeIdFromVarDec(vd: VariableDeclaration): Identifier {
    return this.factory.makeIdentifierFor(vd);
  }

  makeIdsFromVarDecs(vds: VariableDeclaration[]): Identifier[] {
    return vds.map((vd) => this.makeIdFromVarDec(vd));
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

  makeTypedIds(xs: string[], ts: TypeName[]): Identifier[] {
    // Note(GW): is it necessary to make variable declaration first???
    return this.makeIdsFromVarDecs(this.makeVarDecs(xs, this.makeNamelessTypedVarDecls(ts)));
  }
}

class ValSpecTransformer<T> extends ConSolTransformer {
  ctx: ASTContext;
  spec: ValSpec<T>;
  tgtName: string;
  // Note(GW): these are parameters used for generating check functions, but they may not have correct binding names
  paramVarDecs: VariableDeclaration[];
  retVarDecs: VariableDeclaration[];
  guardedParamNames: string[];
  guardedRetParamNames: string[];
  guardedAllParamNames: string[];

  constructor(
    ctx: ASTContext,
    scope: number,
    spec: ValSpec<T>,
    tgtName: string,
    params: VariableDeclaration[],
    retVarDecs: VariableDeclaration[],
    factory?: ASTNodeFactory,
  ) {
    if (factory === undefined) {
      super(new ASTNodeFactory(ctx), scope);
    } else {
      super(factory, scope);
    }
    this.ctx = ctx;
    this.spec = spec;
    this.tgtName = tgtName;
    this.paramVarDecs = params;
    this.retVarDecs = retVarDecs;
    this.guardedParamNames = [...this.spec.call.kwargs.map((p) => p.snd), ...this.spec.call.args];
    this.guardedRetParamNames = this.spec.call.rets;
    this.guardedAllParamNames = [...this.guardedParamNames, ...this.guardedRetParamNames];
  }

  makeFlatCheckFun(funName: string, condExpr: T, params: ParameterList, errorDef: ErrorDefinition, errorParamVal:string|number): FunctionDefinition {
    const condNode = this.factory.makePhantomExpression('bool', condExpr as string);

    // Make the if-condition (expression)
    const ifCondition = this.factory.makeUnaryOperation(
      'bool', // typeString
      true,  // prefix
      '!', // operator
      condNode,
    );

    // Define the error
    const errorId = this.factory.makeIdentifierFor(errorDef);
    
    let errorParam;
    if (typeof errorParamVal === 'number') {
      errorParam = this.factory.makeLiteral('uint256', LiteralKind.Number, String(errorParamVal), String(errorParamVal))
    }else{
      errorParam = this.factory.makeLiteral('string', LiteralKind.String, errorParamVal, errorParamVal)
    }
    
    // Create the function call for the error
    const errorCall = this.factory.makeFunctionCall(
      'void',
      FunctionCallKind.FunctionCall,
      errorId, 
      [errorParam] // Arguments
    );

    // Create the revert statement with the error call
    const revertStatement = this.factory.makeRevertStatement(errorCall);
    // Make the if-statement
    const ifStatement = this.factory.makeIfStatement(ifCondition, revertStatement);
    const funBody = this.factory.makeBlock([ifStatement]);
    const checkFunDef = this.factory.makeFunctionDefinition(
      this.scope,
      FunctionKind.Function,
      funName,
      false, // virtual
      FunctionVisibility.Private,
      FunctionStateMutability.NonPayable,
      false, // funKind == FunctionKind.Constructor,
      params,
      this.factory.makeParameterList([]), // returnParameters
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
    const call = this.makeFunCall(funName, args);
    return this.makeRequireStmt(call, errorMsg);
  }

  makeCallStmt(funName: string, args: Expression[]): ExpressionStatement {
    const call = this.makeFunCall(funName, args);
    return this.factory.makeExpressionStatement(call);
  }

  makeFunCall(funName: string, args: Expression[]): FunctionCall {
    const call = this.factory.makeFunctionCall(
      'bool',
      FunctionCallKind.FunctionCall,
      this.factory.makeIdentifier('function', funName, -1),
      args,
    );
    return call;
  }

  preCondCheckFun(errorDef: ErrorDefinition|undefined, errorParamVal: string|number): FunctionDefinition | undefined {
    if (this.spec.preCond === undefined) return undefined;
    assert(errorDef != undefined, 'Pre Error is undefined');
    const preFunName = preCheckFunName(this.tgtName);
    // TODO(GW): should use factory.makeParameterList...
    const varDecs = this.makeVarDecs(this.guardedParamNames, this.paramVarDecs);
    const allParams = new ParameterList(0, '', [...varDecs]);
    const preFunDef = this.makeFlatCheckFun(preFunName, this.spec.preCond, allParams, errorDef, errorParamVal);
    return preFunDef;
  }

  postCondCheckFun(errorDef: ErrorDefinition|undefined, errorParamVal: string|number): FunctionDefinition | undefined {
    if (this.spec.postCond === undefined) return undefined;
    assert(errorDef != undefined, 'post Error is undefined');
    const postFunName = postCheckFunName(this.tgtName);
    const rets = [...this.guardedParamNames, ...this.guardedRetParamNames];
    const retVarDecs = this.makeVarDecs(rets, [...this.paramVarDecs, ...this.retVarDecs]);
    const allParams = new ParameterList(0, '', [...retVarDecs]);
    const postCondFunc = this.makeFlatCheckFun(postFunName, this.spec.postCond, allParams, errorDef, errorParamVal);
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
  preAddrError: ErrorDefinition | undefined;
  postAddrError: ErrorDefinition | undefined;

  constructor(
    parent: FunctionDefinition,
    tgtAddr: VariableDeclaration,
    spec: ValSpec<T>,
    ctx: ASTContext,
    scope: number,
    factory?: ASTNodeFactory,
    preAddrError? : ErrorDefinition | undefined,
    postAddrError? : ErrorDefinition | undefined,
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
    this.paramVarDecs = this.makeNamelessTypedVarDecls([...optTypes, ...argTypes]);
    this.retVarDecs = this.makeNamelessTypedVarDecls(retTypes);
    this.preAddrError = preAddrError;
    this.postAddrError = postAddrError; 
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
      if (key === 'value') return this.strToTypeName('uint256');
      if (key === 'gas') return this.strToTypeName('uint256');
      assert(false, 'what else?');
    });
  }
  signatureArgsToTypeName(sig: string): Array<TypeName> {
    const args = sig.substring(sig.indexOf('(') + 1, sig.lastIndexOf(')'));
    return args.split(',').map((ty) => {
      if (ty === 'string') return this.strToTypeName('string');
      return this.strToTypeName(ty);
    });
  }
  extractAddrArgTypes(callsite: FunctionCall): Array<TypeName> {
    if (needAbiEncoding(this.member)) {
      const signature = this.extractSigFromCall(callsite);
      return this.signatureArgsToTypeName(signature);
    }
    if (this.member === 'balance' || this.member === 'code' || this.member === 'codehash') return [];
    if (this.member === 'transfer') return [this.strToTypeName('uint256')];
    if (this.member === 'send') return [this.strToTypeName('uint256')];
    assert(false, 'Unknown address member');
  }
  defaultAddrRetTypes(): Array<TypeName> {
    if (needAbiEncoding(this.member)) {
      return [this.strToTypeName('bool'), this.strToTypeName('bytes')];
    }
    if (this.member === 'balance') return [this.strToTypeName('uint256')];
    if (this.member === 'code') return [this.strToTypeName('bytes')];
    if (this.member === 'codehash') return [this.strToTypeName('bytes32')];
    if (this.member === 'transfer') return [];
    if (this.member === 'send') return [this.strToTypeName('bool')];
    assert(false, 'Unknown address member');
  }

  findAddressSignature(properAddr: string): [Array<TypeName>, Array<TypeName>, Array<TypeName>] {
    assert(this.parentFunDef.vBody !== undefined, 'Empty function body');
    this.callsites = this.parentFunDef.vBody
      .getChildrenBySelector((node: ASTNode) => {
        if (!(node instanceof FunctionCallOptions || node instanceof FunctionCall)) return false;
        if (!(node.vExpression instanceof MemberAccess)) return false;
        if (!(node.vExpression.vExpression instanceof Identifier)) return false;
        // TODO(GW): simply comparing address identifier expression is not enough,
        // consider address value flow...
        // TODO(GW): should also check if the call-site arity matches `spec`.
        const found = properAddrName(node.vExpression.vExpression.name, node.vExpression.memberName);
        console.log(found + ' and ' + properAddr);
        return found == properAddr;
      })
      .map((call: ASTNode) => {
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
        assert(false, 'dumbo type checker');
      });
    assert(this.callsites.length > 0, 'Cannot find any call site for ' + properAddr);

    // If there are mutiple call-sites, their signatures has to be the same, so let's pick a lucky one
    const callsite = this.callsites[0];
    const options = this.extractOptions(callsite);
    const optTypes = this.optionsToTypeName(options);
    const argTypes = this.extractAddrArgTypes(callsite);
    const retTypes = this.defaultAddrRetTypes();
    return [optTypes, argTypes, retTypes];
  }

  // replace address, replace value, gas, all other arguments
  makeNewAddressCall(original: FunctionCall): FunctionCall {
    const newCall = this.factory.copy(original);
    const addrId = this.factory.makeIdentifier('', this.addr, -1);
    if (newCall.vExpression instanceof FunctionCallOptions) {
      assert(newCall.vExpression.vExpression instanceof MemberAccess, 'Callee is not member access');
      newCall.vExpression.vExpression.vExpression = addrId;
      // TODO(GW): kwargs should be stored as a map at the very beginning
      const options = new Map(Array.from(this.spec.call.kwargs, (p) => [p.fst, p.snd]));
      newCall.vExpression.vOptionsMap = new Map(
        Array.from(newCall.vExpression.vOptionsMap, ([k, v]) => {
          const keyArg = options.get(k);
          assert(keyArg !== undefined, "Specification doesn't have key " + k);
          return [k, this.factory.makeIdentifier('', keyArg, -1)];
        }),
      );
    } else if (newCall.vExpression instanceof MemberAccess) {
      newCall.vExpression.vExpression = addrId;
    }
    if (needAbiEncoding(this.member)) {
      const encodeCall = newCall.vArguments[0];
      assert(encodeCall instanceof FunctionCall, 'This is the Abi.encodeWithSignature call');
      // Note(GW): assuming for `call`, the first argument is the abi.encodeWithSignature call.
      // TODO(GW): but this is not enough, consider the data can be encoded else where and passed to here.
      const sig = encodeCall.vArguments[0];
      encodeCall.vArguments = [sig, ...this.makeTypedIds(this.spec.call.args, this.argTypes)];
    } else {
      newCall.vArguments = [...this.makeTypedIds(this.spec.call.args, this.argTypes)];
    }
    return newCall;
  }

  makeWrapperCallArgs(f: FunctionDefinition, addrCall: FunctionCall): Expression[] {
    const args: Expression[] = [];
    if (addrCall.vExpression instanceof FunctionCallOptions) {
      // Caveat(GW): values() is an iterator over keys of map; the order may not be the same as in the program
      const ma = addrCall.vExpression.vExpression as MemberAccess;
      args.push(ma.vExpression);
      args.push(...addrCall.vExpression.vOptionsMap.values());
    } else {
      // Without call options
      const ma = addrCall.vExpression as MemberAccess;
      args.push(ma.vExpression);
    }
    if (needAbiEncoding(this.member)) {
      const encodeCall = addrCall.vArguments[0];
      assert(encodeCall instanceof FunctionCall, 'This is the Abi.encodeWithSignature call');
      // Note(GW): assuming for `call`, the first argument is the abi.encodeWithSignature call.
      // TODO(GW): but this is not enough, consider the data can be encoded else where and passed to here.
      args.push(...encodeCall.vArguments.slice(1));
    } else {
      args.push(...this.copyNodes(addrCall.vArguments));
    }
    return args;
  }

  makeWrapperCall(f: FunctionDefinition, addrCall: FunctionCall): FunctionCall {
    const callee = this.factory.makeIdentifier('function', f.name, -1);
    const args = this.makeWrapperCallArgs(f, addrCall);
    return this.factory.makeFunctionCall(addrCall.typeString, FunctionCallKind.FunctionCall, callee, args);
  }

  guardedFun(
    preCondFun: FunctionDefinition | undefined,
    postCondFun: FunctionDefinition | undefined,
  ): FunctionDefinition | undefined {
    if (preCondFun === undefined && postCondFun === undefined) return undefined;

    const retTypeStr = '(' + this.retTypes.map((t) => t.typeString).toString() + ')';
    const retTypeDecls = this.makeTypedVarDecls(this.retTypes, this.spec.call.rets);

    const params = this.makeVarDecs(this.guardedParamNames, this.paramVarDecs);
    const retVarDecs = this.makeVarDecs(this.guardedAllParamNames, [...this.paramVarDecs, ...this.retVarDecs]);

    const stmts = [];

    // Generate function call to check pre-condition (if any)
    if (preCondFun) {
      const preCondStmt = this.makeCallStmt(preCondFun.name, this.makeIdsFromVarDecs(params));
      stmts.push(preCondStmt);
    }

    // Generate address call to the address, replace arguments
    const uncheckedCall = this.makeNewAddressCall(this.callsites[0]);
    assert(uncheckedCall !== undefined, 'what');
    const retIds = retTypeDecls.map((r) => r.id);
    const callAndAssignStmt = this.factory.makeVariableDeclarationStatement(retIds, retTypeDecls, uncheckedCall);
    stmts.push(callAndAssignStmt);

    // Generate function call to check post-condition (if any)
    if (postCondFun) {
      const postCallArgs = this.makeIdsFromVarDecs(retVarDecs);
      const postCondStmt = this.makeCallStmt(postCondFun.name, postCallArgs);
      stmts.push(postCondStmt);
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
    const addrParam = this.makeNamelessTypedVarDecls([this.strToTypeName('address')]);
    const guardedVars = this.makeVarDecs([this.addr, ...this.guardedParamNames], [addrParam[0], ...this.paramVarDecs]);
    const guardedRetVars = this.makeVarDecs(
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
      new ParameterList(0, '', guardedVars),
      new ParameterList(0, '', guardedRetVars),
      [], // modifier
      undefined,
      funBody,
    );

    return funDef;
  }

  apply(): void {
    const preFun = this.preCondCheckFun(this.preAddrError, 0);
    if (preFun) this.parentFunDef.vScope.appendChild(preFun);
    const postFun = this.postCondCheckFun(this.postAddrError, 0);
    if (postFun) this.parentFunDef.vScope.appendChild(postFun);

    // step 1: generate guarded address call function
    const wrapper = this.guardedFun(preFun, postFun);
    if (wrapper) {
      this.parentFunDef.vScope.appendChild(wrapper);
      // step 2: replace old address call with the new wrapper call
      this.callsites.forEach((addrCall) => {
        const wrapperCall = this.makeWrapperCall(wrapper, addrCall);
        replaceNode(addrCall, wrapperCall);
      });
    }
  }
}

class FunDefValSpecTransformer<T> extends ValSpecTransformer<T> {
  funDef: FunctionDefinition;
  retTypes: TypeName[];
  declaredParams: VariableDeclaration[];
  declaredRetParams: VariableDeclaration[];
  preCondError: ErrorDefinition | undefined;
  postCondError: ErrorDefinition | undefined;
  preAddrError: ErrorDefinition | undefined;
  postAddrError: ErrorDefinition | undefined;

  constructor(funDef: FunctionDefinition, spec: ValSpec<T>, factory: ASTNodeFactory,
    preCondError? : ErrorDefinition | undefined,
    postCondError? : ErrorDefinition | undefined,
    preAddrError? : ErrorDefinition | undefined,
    postAddrError? : ErrorDefinition | undefined,
    ) {
    const declaredParams = (funDef as FunctionDefinition).vParameters.vParameters;
    const declaredRetParams = (funDef as FunctionDefinition).vReturnParameters.vParameters;
    super(
      funDef.context as ASTContext,
      funDef.scope,
      spec,
      extractFunName(funDef),
      declaredParams,
      declaredRetParams,
      factory,
    );
    this.declaredParams = declaredParams;
    this.declaredRetParams = declaredRetParams;
    this.funDef = funDef;
    this.retTypes = this.declaredRetParams
      .map((param) => param.vType)
      .filter((vType): vType is TypeName => vType !== undefined); // filter out the undefined object
    this.preCondError = preCondError;
    this.postCondError = postCondError;
    this.preAddrError = preAddrError;
    this.postAddrError = postAddrError; 
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
      const preCondStmt = this.makeCallStmt(
        preCondFun.name,
        this.makeIdsFromVarDecs(this.declaredParams),
      );
      stmts.push(preCondStmt);
    }

    // Generate function call to the original function
    const uncheckedCall = this.factory.makeFunctionCall(
      retTypeStr,
      FunctionCallKind.FunctionCall,
      this.factory.makeIdentifier('function', uncheckedFunName(this.tgtName), -1),
      this.makeIdsFromVarDecs(this.declaredParams),
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
      let postCallArgs = this.makeIdsFromVarDecs(this.declaredParams);
      if (this.retTypes.length > 0) {
        postCallArgs = postCallArgs.concat(this.makeIdsFromVarDecs(retTypeDecls));
      }
      const postCondStmt = this.makeCallStmt(postCondFun.name, postCallArgs);
      stmts.push(postCondStmt);
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
    return new AddrValSpecTransformer(this.funDef, tgtAddr, addrSpec, this.ctx, this.scope, this.factory, this.preAddrError, this.postAddrError);
  }

  apply(): void {
    const preFun = this.preCondCheckFun(this.preCondError, this.tgtName);
    if (preFun) this.funDef.vScope.appendChild(preFun);
    const postFun = this.postCondCheckFun(this.postCondError, this.tgtName);
    if (postFun) this.funDef.vScope.appendChild(postFun);

    const addrTrans = this.spec.preFunSpec.map((s) => this.addrTransformers(s));
    addrTrans.forEach((tr) => {
      tr.apply();
    });

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

export class ContractSpecTransformer<T> extends ConSolTransformer {
  contract: ContractDefinition;
  preCondError: ErrorDefinition | undefined;
  postCondError: ErrorDefinition | undefined;
  preAddrError: ErrorDefinition | undefined;
  postAddrError: ErrorDefinition | undefined;
  specToId: Map <CSSpec<T>, number>;


  constructor(factory: ASTNodeFactory, scope: number, contract: ContractDefinition) {
    super(factory, scope);
    this.contract = contract;
    this.specToId = new Map<CSSpec<T>, number>();
  }

  parseConSolSpec(doc: string): CSSpec<string> {
    const specStr = doc.substring(SPEC_PREFIX.length).trim();
    const visitor = new CSSpecVisitor<string>((s) => s);
    const spec = CSSpecParse<string>(specStr, visitor);
    return spec;
  }

  handleValSpec<T>(node: ASTNode, spec: ValSpec<T>) {
    console.log('Parsed spec AST:');
    console.log(spec);
    console.log(spec.tag);
    if (node instanceof FunctionDefinition) {
      const trans = new FunDefValSpecTransformer(node, spec, this.factory, this.preCondError, this.postCondError, this.preAddrError, this.postAddrError);
      trans.apply();
    } else if (node instanceof EventDefinition) {
      // TODO: optional
    } else {
      console.assert(false, 'wow');
    }
  }

  makeError(eventName: string, paramName: string, paraTypeName: string): ErrorDefinition {
    const param: VariableDeclaration = this.factory.makeVariableDeclaration(
      false,
      false,
      paramName,
      // this.scope, // -> error, why???
      0,
      false,
      DataLocation.Default,
      StateVariableVisibility.Default,
      Mutability.Mutable,
      paraTypeName,
    );
    param.vType = this.strToTypeName(paraTypeName);

    const errorDef = this.factory.makeErrorDefinition(eventName, this.factory.makeParameterList([param]));

    return errorDef;
  }

  process(): void {
    // AST node kinds that allow ConSol spec attachments
    type ConSolCheckNodes = FunctionDefinition | EventDefinition;
    // TODO: traverse twice, spec as key
    this.preCondError = this.makeError('preViolation', 'funcName', 'string');
    this.contract.appendChild(this.preCondError);
    this.postCondError = this.makeError('postViolation', 'funcName', 'string');
    this.contract.appendChild(this.postCondError);
    this.preAddrError = this.makeError('PreViolationAddr', 'specId', 'uint256');
    this.contract.appendChild(this.preAddrError);
    this.postAddrError = this.makeError('PostViolationAddr', 'specId', 'uint256');
    this.contract.appendChild(this.postAddrError);


    let id = 0;
    this.contract.walkChildren((astNode: ASTNode) => {
      const astNodeDoc = (astNode as ConSolCheckNodes).documentation as StructuredDocumentation;
      if (!astNodeDoc) return;
      const specStr = astNodeDoc.text;
      if (!isConSolSpec(specStr)) return;
      // console.log('Processing spec: ' + specStr.substring(SPEC_PREFIX.length).trim());
      const spec = this.parseConSolSpec(specStr);

      this.specToId.set(spec as CSSpec<T>, id);
      id += 1;

      
  
    });

    console.log(this.specToId);

    this.contract.walkChildren((astNode: ASTNode) => {
      const astNodeDoc = (astNode as ConSolCheckNodes).documentation as StructuredDocumentation;
      if (!astNodeDoc) return;
      const specStr = astNodeDoc.text;
      if (!isConSolSpec(specStr)) return;
      // console.log('Processing spec: ' + specStr.substring(SPEC_PREFIX.length).trim());
      const spec = this.parseConSolSpec(specStr);
      const specId = this.specToId.get(spec as CSSpec<T>);
      console.log('Processing spec ' + specId + ':  ' +specStr.substring(SPEC_PREFIX.length).trim());
      if (isValSpec(spec)) {
       
        this.handleValSpec(astNode, spec);
      } else if (isTempSpec(spec)) {
        // TODO
      } else {
        console.assert(false);
      }
    });
  }
}