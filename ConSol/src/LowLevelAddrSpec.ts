/*
export class HighLevelAddrSpecTransformer<T> extends CheckFunFactory<T> {
  parentFunDef: FunctionDefinition;
  tgtAddr: VariableDeclaration;
  callsites: FunctionCall[] = [];
  optTypes: TypeName[];
  argTypes: TypeName[];
  retTypes: TypeName[];
  preAddrError: ErrorDefinition;
  postAddrError: ErrorDefinition;

  constructor(
    parent: FunctionDefinition,
    tgtAddr: VariableDeclaration,
    spec: ValSpec<T>,
    ctx: ASTContext,
    scope: number,
    preAddrError: ErrorDefinition,
    postAddrError: ErrorDefinition,
    factory?: ASTNodeFactory
  ) {
    super(ctx, scope, spec, [], [], factory);
    this.tgtAddr = tgtAddr;
    this.parentFunDef = parent;
    const [optTypes, argTypes, retTypes] = findAddrSignature(spec);
    this.optTypes = optTypes;
    this.argTypes = argTypes;
    this.retTypes = retTypes;
    this.paramVarDecs = this.makeNamelessTypedVarDecls([...optTypes, ...argTypes]);
    this.retVarDecs = this.makeNamelessTypedVarDecls(retTypes);
    this.preAddrError = preAddrError;
    this.postAddrError = postAddrError;
  }

  apply(): void {
    const preFun = this.preCondCheckFun(this.preAddrError, 0);
    if (preFun) this.parentFunDef.vScope.appendChild(preFun);
    const postFun = this.postCondCheckFun(this.postAddrError, 0);
    if (postFun) this.parentFunDef.vScope.appendChild(postFun);
  }
}
*/

/*
export class LowLevelAddrSpecTransformer<T> {
  parentFunDef: FunctionDefinition;
  addr: string;
  member: string;
  tgtAddr: VariableDeclaration;
  callsites: FunctionCall[] = [];
  optTypes: TypeName[];
  argTypes: TypeName[];
  retTypes: TypeName[];
  preAddrError: ErrorDefinition;
  postAddrError: ErrorDefinition;
  factory: CheckFunFactory<T>;

  constructor(
    parent: FunctionDefinition,
    tgtAddr: VariableDeclaration,
    spec: ValSpec<T>,
    ctx: ASTContext,
    scope: number,
    preAddrError: ErrorDefinition,
    postAddrError: ErrorDefinition,
    factory: CheckFunFactory<T>,
  ) {
    const addr = extractRawAddr(spec);
    const member = extractAddrMember(spec);
    this.factory = factory;
    this.addr = addr;
    this.member = member;
    this.tgtAddr = tgtAddr;
    this.parentFunDef = parent;
    const [optTypes, argTypes, retTypes] = this.findAddressSignature(properAddrName(tgtAddr.name, this.member));
    this.optTypes = optTypes;
    this.argTypes = argTypes;
    this.retTypes = retTypes;
    this.paramVarDecs = this.factory.makeNamelessTypedVarDecls([...optTypes, ...argTypes]);
    this.retVarDecs = this.factory.makeNamelessTypedVarDecls(retTypes);
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
      'guarded_' + this.parentFunDef.name + '_' + this.tgtName + '_' + uncheckedCall.vFunctionName,
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
*/
