import {
  FunctionDefinition,
  FunctionVisibility,
  FunctionKind,
  VariableDeclaration,
  FunctionCallKind,
  assert,
  TypeName,
  ErrorDefinition,
  Expression,
  LiteralKind,
  FunctionCall,
  FunctionCallOptions,
  MemberAccess,
  Statement,
  FunctionStateMutability,
  Identifier,
} from 'solc-typed-ast';

import { ValSpec } from './spec/index.js';
import {
  GUARD_ADDR_TYPE,
  extractFunName,
  uncheckedFunName,
  guardedFunName,
  usesAddr,
  attachSpec,
  encodeSpecIdToUInt96,
  dispatchFunName,
} from './ConSolUtils.js';

import { CheckFunFactory } from './CheckFunFactory.js';
import { ConSolFactory } from './ConSolFactory.js';
import { findContract, freshName } from './Global.js';

export class FunDefValSpecTransformer<T> {
  funDef: FunctionDefinition;
  retTypes: TypeName[];
  declaredParams: VariableDeclaration[];
  declaredRetParams: VariableDeclaration[];
  preCondError: ErrorDefinition;
  postCondError: ErrorDefinition;
  preAddrError: ErrorDefinition;
  postAddrError: ErrorDefinition;
  factory: ConSolFactory;
  cfFactory: CheckFunFactory<T>;
  spec: ValSpec<T>;
  tgtName: string;

  constructor(
    funDef: FunctionDefinition,
    spec: ValSpec<T>,
    preCondError: ErrorDefinition,
    postCondError: ErrorDefinition,
    preAddrError: ErrorDefinition,
    postAddrError: ErrorDefinition,
    factory: ConSolFactory,
  ) {
    const declaredParams = (funDef as FunctionDefinition).vParameters.vParameters;
    const declaredRetParams = (funDef as FunctionDefinition).vReturnParameters.vParameters;
    this.tgtName = extractFunName(funDef);
    if (spec.call.tgt.func !== this.tgtName) {
      console.error(
        `Error: Mismatch names between the attached function (${this.tgtName}) the spec (${spec.call.tgt.func}). Abort.`,
      );
      process.exit(-1);
    }
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
    this.factory = factory;
    this.cfFactory = new CheckFunFactory(spec, declaredParams, declaredRetParams, factory);
    this.spec = spec;
  }

  guardedFun(
    preCondFun: FunctionDefinition | undefined,
    postCondFun: FunctionDefinition | undefined,
  ): FunctionDefinition | undefined {
    if (preCondFun === undefined && postCondFun === undefined) return undefined;

    assert(this.retTypes.length === this.spec.call.rets.length, 'some return parameters are missing type');

    const retTypeStr =
      this.retTypes.length > 0 ? '(' + this.retTypes.map((t) => t.typeString).toString() + ')' : 'void';
    const retTypeDecls = this.factory.makeTypedVarDecls(this.retTypes, this.spec.call.rets, this.funDef.scope);
    const stmts = [];

    // Generate function call to check pre-condition (if any)
    if (preCondFun) {
      const preCondStmt = this.factory.makeCallStmt(
        preCondFun.name,
        this.factory.makeIdsFromVarDecs(this.declaredParams),
      );
      stmts.push(preCondStmt);
    }

    // Generate function call to the original function
    const uncheckedCall = this.factory.makeFunctionCall(
      retTypeStr,
      FunctionCallKind.FunctionCall,
      this.factory.makeIdentifier('function', uncheckedFunName(this.tgtName), -1),
      this.factory.makeIdsFromVarDecs(this.declaredParams),
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
      let postCallArgs = this.factory.makeIdsFromVarDecs(this.declaredParams);
      if (this.retTypes.length > 0) {
        postCallArgs = postCallArgs.concat(this.factory.makeIdsFromVarDecs(retTypeDecls));
      }
      const postCondStmt = this.factory.makeCallStmt(postCondFun.name, postCallArgs);
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

  /*
  findTargetAddr(def: FunctionDefinition, parentSpec: ValSpec<T>, addr: string): VariableDeclaration {
    return def.vParameters.vParameters[parentSpec.call.args.findIndex((a) => a === addr)];
  }

  addrTransformers(addrSpec: ValSpec<T>): LowLevelAddrSpecTransformer<T> {
    const tgtAddr = this.findTargetAddr(this.funDef, this.spec, extractRawAddr(addrSpec));
    return new LowLevelAddrSpecTransformer(
      this.funDef,
      tgtAddr,
      addrSpec,
      this.ctx,
      this.scope,
      this.preAddrError,
      this.postAddrError,
      this.factory,
    );
  }
  */

  // Note: argument type takes no prefix such as `struct`
  wrapType(type: string): string {
    if (type === 'address') return GUARD_ADDR_TYPE;
    if (type === 'address payable') return GUARD_ADDR_TYPE;
    // XXX (GW): we have directly changed the struct definition, would also need
    // to provide accessors the unwrap?
    if (globalThis.structMap.has(type)) {
      const struct = globalThis.structMap.get(type);
      const members = struct?.vMembers || [];
      // FIXME: It seems we cannot just change the existing struct type, but need to
      // create a new struct type with a different name and changed member types...
      for (const m of members) {
        const newType = this.wrapType(m.typeString);
        if (newType !== m.typeString) {
          // Note(GW): not sure if this enough, because there is some
          // inconsistency between typeString and vType
          m.typeString = newType;
        }
      }
    }
    // TODO: handle mappings and arrays
    return type;
  }

  // address -> uint256(uint160(address(...)))
  wrap(x: Expression): Expression {
    if (usesAddr(x.typeString)) {
      // TODO: only handles flat types so far, need to handle struct, array, mapping, etc.
      // How should we do that?
      //   Note that (1) the struct type definition has been changed,
      //   (2) we may need to recreate a value of the new struct type.
      const cast1 = this.factory.makeFunctionCall('address', FunctionCallKind.TypeConversion, this.factory.address, [
        x,
      ]);
      const cast2 = this.factory.makeFunctionCall('uint160', FunctionCallKind.TypeConversion, this.factory.uint160, [
        cast1,
      ]);
      const cast3 = this.factory.makeFunctionCall('uint256', FunctionCallKind.TypeConversion, this.factory.uint256, [
        cast2,
      ]);
      return cast3;
    }
    return x;
  }

  // uint256 -> payable(address(uint160(...)))
  unwrap(x: Expression): Expression {
    // TODO: so far only handles flat types
    const cast1 = this.factory.makeFunctionCall('uint160', FunctionCallKind.TypeConversion, this.factory.uint160, [x]);
    const cast2 = this.factory.makeFunctionCall('address', FunctionCallKind.TypeConversion, this.factory.address, [
      cast1,
    ]);
    const cast3 = this.factory.makeFunctionCall('payable', FunctionCallKind.TypeConversion, this.factory.payable, [
      cast2,
    ]);
    return cast3;
  }

  extractSpecId(addr: Expression): Expression {
    const width = this.factory.makeLiteral('uint256', LiteralKind.Number, (160).toString(16), '160');
    const shiftExpr = this.factory.makeBinaryOperation('uint96', '>>', addr, width);
    const castExpr = this.factory.makeFunctionCall('uint96', FunctionCallKind.TypeConversion, this.factory.uint96, [
      shiftExpr,
    ]);
    return castExpr;
  }

  unwrapType(type: string): string {
    if (type === 'uint256') return 'address payable';
    // TODO: handle mappings and arrays
    return type;
  }

  wrapParameterList(params: VariableDeclaration[]): VariableDeclaration[] {
    // TODO: struct/mapping/array type
    return params.map((p) => {
      const q = this.factory.copy(p);
      q.typeString = this.wrapType(q.typeString);
      q.vType = this.factory.makeElementaryTypeName(q.typeString, q.typeString);
      return q;
    });
  }

  unwrapArgumentList(args: VariableDeclaration[], types: string[]): Expression[] {
    return args.map((p, idx) => {
      const id = this.factory.makeIdFromVarDec(p);
      if (usesAddr(types[idx])) {
        return this.unwrap(id);
      } else {
        return id;
      }
    });
  }

  dispatchingFunction(
    rawSpecId: number,
    ifaceName: string,
    funName: string,
    oldFun: FunctionDefinition,
  ): FunctionDefinition {
    const newFun = this.factory.copy(oldFun);
    newFun.documentation = undefined;
    newFun.visibility = FunctionVisibility.Private;
    newFun.stateMutability = FunctionStateMutability.NonPayable;
    newFun.name = dispatchFunName(ifaceName, funName);

    const bodyStmts: Array<Statement> = [];
    const lastStmts: Array<Statement> = [];

    // prepend uint256 addr, uint256 value, uint256 gas parameters
    const addrVarDec = this.factory.makeTypedVarDecl(this.factory.uint256, 'addr', newFun.scope);
    const valueVarDec = this.factory.makeTypedVarDecl(this.factory.uint256, 'value', newFun.scope);
    const gasVarDec = this.factory.makeTypedVarDecl(this.factory.uint256, 'gas', newFun.scope);
    newFun.vParameters.vParameters.unshift(addrVarDec, valueVarDec, gasVarDec);
    // extract specId, generate:
    // uint96 specId = uint96(addr >> 160);
    const specId = this.factory.makeIdentifier('uint96', 'specId', -1);
    const addrId = this.factory.makeIdFromVarDec(addrVarDec);
    const valueId = this.factory.makeIdFromVarDec(valueVarDec);
    const gasId = this.factory.makeIdFromVarDec(gasVarDec);

    const castExpr = this.extractSpecId(addrId);
    const specIdStmt = this.factory.makeVariableDeclarationStatement(
      [specId.id],
      this.factory.makeTypedVarDecls([this.factory.uint96], ['specId'], newFun.scope),
      castExpr,
    );
    bodyStmts.push(specIdStmt);

    // Generate pre-check for addr call
    // TODO: put it into a loop, but only for ifaceName and funName)
    const binAnd = this.factory.makeBinaryOperation('uint', '&', specId, encodeSpecIdToUInt96(this.factory, rawSpecId));
    const cond = this.factory.makeBinaryOperation(
      'uint',
      '!=',
      binAnd,
      this.factory.makeLiteral('uint', LiteralKind.Number, '0', '0'),
    );
    const args = [this.unwrap(addrId), valueId, gasId].concat(
      this.factory.makeIdsFromVarDecs(oldFun.vParameters.vParameters),
    );
    const preCheck = this.factory.makeFunctionCall(
      'void',
      FunctionCallKind.FunctionCall,
      this.factory.makeIdentifier('function', `_${ifaceName}_${funName}_${rawSpecId}_pre`, -1),
      args,
    );
    const ifPreCheck = this.factory.makeIfStatement(cond, this.factory.makeExpressionStatement(preCheck));
    bodyStmts.push(ifPreCheck);

    // Generate addr call
    // type freshVar = interface(unwrap(addr)).f{value: value, gas: gas}(args ...);
    const castedAddr = this.factory.makeFunctionCall(
      ifaceName,
      FunctionCallKind.TypeConversion,
      this.factory.makeElementaryTypeNameExpression(ifaceName, ifaceName),
      [this.unwrap(addrId)],
    );
    const options = new Map<string, Expression>([
      ['value', this.factory.makeIdentifierFor(valueVarDec)],
      ['gas', this.factory.makeIdentifierFor(gasVarDec)],
    ]);
    const f = this.factory.makeMemberAccess('function', castedAddr, funName, -1);
    const callOpt = this.factory.makeFunctionCallOptions(oldFun.vReturnParameters.type, f, options);
    const call = this.factory.makeFunctionCall(
      oldFun.vReturnParameters.type,
      FunctionCallKind.FunctionCall,
      callOpt,
      this.factory.makeIdsFromVarDecs(oldFun.vParameters.vParameters),
    );
    let retTypeStr = 'void';
    let retVars: Expression[] = [];
    if (oldFun.vReturnParameters.vParameters.length > 0) {
      const retTypes = oldFun.vReturnParameters.vParameters.map((p) =>
        this.factory.makeElementaryTypeName(p.typeString, p.typeString),
      );
      retTypeStr = '(' + retTypes.toString() + ')';
      const retTypeDecls = this.factory.makeTypedVarDecls(
        retTypes,
        retTypes.map((x) => freshName()),
        oldFun.scope,
      );
      const retIds = retTypeDecls.map((r) => r.id);
      const callAndAssignStmt = this.factory.makeVariableDeclarationStatement(retIds, retTypeDecls, call);
      bodyStmts.push(callAndAssignStmt);

      retVars = retTypeDecls.map((r, i) => {
        if (usesAddr(newFun.vReturnParameters.vParameters[i].typeString)) {
          return this.unwrap(this.factory.makeIdentifierFor(r));
        }
        return this.factory.makeIdentifierFor(r);
      });
      const retValTuple = this.factory.makeTupleExpression(retTypeStr, false, retVars);
      const retStmt = this.factory.makeReturn(retValTuple.id, retValTuple);
      lastStmts.push(retStmt);
    } else {
      const callStmt = this.factory.makeExpressionStatement(call);
      bodyStmts.push(callStmt);
    }

    // Generate post-check for addr call
    // TODO: put it into a loop, but only for ifaceName and funName)
    const argsWithRet = [...args];
    if (retVars.length > 0) {
      argsWithRet.push(...retVars);
    }
    const postCheck = this.factory.makeFunctionCall(
      'void',
      FunctionCallKind.FunctionCall,
      this.factory.makeIdentifier('function', `_${ifaceName}_${funName}_${rawSpecId}_post`, -1),
      argsWithRet,
    );
    const ifPostCheck = this.factory.makeIfStatement(cond, this.factory.makeExpressionStatement(postCheck));
    bodyStmts.push(ifPostCheck);

    newFun.vBody = this.factory.makeBlock(bodyStmts.concat(lastStmts));
    return newFun;
  }

  wrappingAddrForFunction(oldFun: FunctionDefinition): FunctionDefinition {
    const newFun = this.factory.copy(oldFun);
    newFun.documentation = undefined;
    const callee = this.factory.makeIdentifier('function', guardedFunName(this.tgtName), -1);
    const args = oldFun.vParameters.vParameters.map((p) => {
      const id = this.factory.makeIdFromVarDec(p);
      return this.wrap(id);
    });
    let guardRetTy = 'void';
    const retTypes = newFun.vReturnParameters.vParameters.map((p) => {
      const t = this.wrapType(p.typeString);
      return this.factory.makeElementaryTypeName(t, t);
    });
    if (newFun.vReturnParameters.vParameters.length > 0) {
      guardRetTy = '(' + retTypes.toString() + ')';
    }
    const callsite = this.factory.makeFunCall(callee, args, guardRetTy);

    if (newFun.vReturnParameters.vParameters.length > 0) {
      const retTypeDecls = this.factory.makeTypedVarDecls(
        retTypes,
        retTypes.map((x) => freshName()),
        oldFun.scope,
      );
      const retIds = retTypeDecls.map((r) => r.id);
      const callAndAssignStmt = this.factory.makeVariableDeclarationStatement(retIds, retTypeDecls, callsite);
      const retValTuple = this.factory.makeTupleExpression(
        guardRetTy, // XXX: ths is not consistent but seems not relevant in generated code
        false,
        retTypeDecls.map((r, i) => {
          if (usesAddr(newFun.vReturnParameters.vParameters[i].typeString)) {
            return this.unwrap(this.factory.makeIdentifierFor(r));
          }
          return this.factory.makeIdentifierFor(r);
        }),
      );
      const retStmt = this.factory.makeReturn(retValTuple.id, retValTuple);
      newFun.vBody = this.factory.makeBlock([callAndAssignStmt, retStmt]);
    } else {
      const callsiteStatement = this.factory.makeExpressionStatement(callsite);
      newFun.vBody = this.factory.makeBlock([callsiteStatement]);
    }
    return newFun;
  }

  // XXX: later we should refactor this with function guardedFun (which currently only
  // hanldes non-address values).
  guardedFunAddr(
    specIds: Map<string, Array<number>>,
    oldFun: FunctionDefinition,
    preCondFun: FunctionDefinition | undefined,
    postCondFun: FunctionDefinition | undefined,
  ): FunctionDefinition | undefined {
    if (preCondFun === undefined && postCondFun === undefined) return undefined;
    const guard = this.factory.copy(oldFun);
    guard.documentation = undefined;
    guard.visibility = FunctionVisibility.Private;
    guard.stateMutability = FunctionStateMutability.NonPayable;
    guard.name = guardedFunName(this.tgtName);
    guard.vParameters = this.factory.makeParameterList(this.wrapParameterList(oldFun.vParameters.vParameters));
    // TODO: change return types if necessary
    // guard.vReturnParameters = ...

    const stmts = [];

    // Generate function call to check pre-condition (if any)
    if (preCondFun) {
      // TODO: extract this
      const unwrappedArgs = this.unwrapArgumentList(
        guard.vParameters.vParameters,
        preCondFun.vParameters.vParameters.map((p) => p.typeString),
      );
      const preCondStmt = this.factory.makeCallStmt(preCondFun.name, unwrappedArgs);
      stmts.push(preCondStmt);
    }

    // Generate statements that attach spec ids to the address arguments
    oldFun.vParameters.vParameters.forEach((p) => {
      if (usesAddr(p.typeString)) {
        const id = this.factory.makeIdFromVarDec(p);
        specIds.get(p.name)?.forEach((specId) => {
          const asgn = this.factory.makeAssignment(
            'void',
            '=',
            id,
            attachSpec(this.factory, id, encodeSpecIdToUInt96(this.factory, specId)),
          );
          const asgnStmt = this.factory.makeExpressionStatement(asgn);
          stmts.push(asgnStmt);
        });
      }
    });

    const retTypeStr =
      this.retTypes.length > 0 ? '(' + this.retTypes.map((t) => t.typeString).toString() + ')' : 'void';
    const retTypeDecls = this.factory.makeTypedVarDecls(this.retTypes, this.spec.call.rets, this.funDef.scope);
    // Generate function call to the original function
    const uncheckedCall = this.factory.makeFunctionCall(
      retTypeStr,
      FunctionCallKind.FunctionCall,
      this.factory.makeIdentifier('function', uncheckedFunName(this.tgtName), -1),
      this.factory.makeIdsFromVarDecs(this.declaredParams),
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
      let unwrappedArgs = this.unwrapArgumentList(
        guard.vParameters.vParameters,
        postCondFun.vParameters.vParameters.map((p) => p.typeString),
      );
      // let postCallArgs = this.factory.makeIdsFromVarDecs(this.declaredParams);
      if (this.retTypes.length > 0) {
        unwrappedArgs = unwrappedArgs.concat(this.factory.makeIdsFromVarDecs(retTypeDecls));
      }
      const postCondStmt = this.factory.makeCallStmt(postCondFun.name, unwrappedArgs);
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

    guard.vBody = this.factory.makeBlock(stmts);
    return guard;
  }

  process(): void {
    /*
    const addrTrans = this.spec.preFunSpec.map((s) => this.addrTransformers(s));
    addrTrans.forEach((tr) => tr.apply());
    */
    const preFun = this.cfFactory.preCondCheckFun(this.preCondError, this.tgtName);
    if (preFun) this.funDef.vScope.appendChild(preFun);
    const postFun = this.cfFactory.postCondCheckFun(this.postCondError, this.tgtName);
    if (postFun) this.funDef.vScope.appendChild(postFun);

    /**
     * Given an input function `f`, we will at least generate `f` and `f`_original,
     * and possible `f`_guard.
     * - The `f`_original function is the original function body, whose body might have been
     *   rewritten with dispatched address calls.
     */

    const paramUseAddr = this.funDef.vParameters.vParameters
      .map((p) => this.factory.normalize(p.typeString))
      .some((t) => usesAddr(t));
    const retUseAddr = this.funDef.vReturnParameters.vParameters
      .map((p) => this.factory.normalize(p.typeString))
      .some((t) => usesAddr(t));

    /* - If `f` takes/returns values with addresses, we need to generate a new function
     *   that preserves `f`'s name and signature. The body of the new function calls
     *   `f`_guard with `wrapped` arguments.
     * - The `f`_guard function guards the call of `f`_original with pre/post condition check.
     *   Importantly, `f`_guard will also take/return values with guarded address representation
     *   (i.e. uint256).
     */
    if (paramUseAddr || retUseAddr) {
      // generate the signature-preserved function
      // TODO: if there is no spec, should we generate this new function? seems yes
      const newFun = this.wrappingAddrForFunction(this.funDef);
      // generate the f_guard function, which attaches address spec meta data

      const argSpecIdMaps = new Map<string, Array<number>>();
      this.spec.preFunSpec.forEach((s) => {
        if (s.call.tgt.addr != undefined && s.id != undefined) {
          const idx = this.spec.call.args.findIndex((a) => a === s.call.tgt.addr);
          const arg = this.funDef.vParameters.vParameters[idx].name;
          if (argSpecIdMaps.has(arg)) {
            argSpecIdMaps.get(arg)?.push(s.id);
          } else {
            argSpecIdMaps.set(arg, [s.id]);
          }
        }
      });
      console.log(argSpecIdMaps);

      const guard = this.guardedFunAddr(argSpecIdMaps, this.funDef, preFun, postFun);
      if (guard) this.funDef.vScope.appendChild(guard);

      // add the signature-preserved function
      this.funDef.vScope.appendChild(newFun);
      // rename the original function `f` to `f`_original
      this.funDef.name = uncheckedFunName(this.tgtName);
      // change the argument type of f_original to wrapped types
      this.funDef.vParameters = this.factory.makeParameterList(
        this.wrapParameterList(this.funDef.vParameters.vParameters),
      );
      // TODO: change the return types of `f`_original (DX, can you take care of this?)

      // For each spec-attached argument, change the body of `f`_original with "address call dispatch"
      // identify the call that cast address to interface, and the associated
      // function call on the interface:
      // XXX (GW): performance of this nesting can be bad...
      this.spec.preFunSpec.forEach((s, idx) => {
        console.log('Target: ' + JSON.stringify(s));
        if (s.id === undefined) {
          console.log('Error: address spec id missing (parsing error). Abort.');
          process.exit(-1);
        }

        const realTgtVar = this.funDef.vParameters.vParameters[idx].name;
        const tgtVarNameInSpec = this.spec.call.args[idx];
        const ifaceName = s.call.tgt.interface;
        const funName = s.call.tgt.func;
        const addrName = s.call.tgt.addr;
        if (ifaceName == undefined || funName == undefined) {
          console.log('Warning: no interface or function name in the spec. Abort.');
          process.exit(-1);
        }

        // Generate the pre/post condition check function for each spec
        // i.e., Iface_f_spec_id_pre, Iface_f_spec_id_post
        const iface = findContract(ifaceName);
        if (iface == undefined) {
          console.error(`Error: interface ${ifaceName} not found. Abort.`);
          process.exit(-1);
        }
        const tgtFunc = iface.vFunctions.find((f) => f.name === funName);
        if (tgtFunc == undefined) {
          console.error(`Error: function ${funName} not found in ${ifaceName}. Abort.`);
          process.exit(-1);
        }

        const addrParam = this.factory.makeTypedVarDecls(
          [this.factory.address],
          ['seems doesnt matter'],
          tgtFunc.scope,
        );
        const tgtFuncParams = tgtFunc.vParameters.vParameters;
        const valGasParams = this.factory.makeTypedVarDecls(
          [this.factory.uint256, this.factory.uint256],
          ['value', 'gas'],
          tgtFunc.scope,
        );
        const allFuncParams = addrParam.concat(valGasParams.concat(tgtFuncParams));
        const tgtFuncRetParams = tgtFunc.vReturnParameters.vParameters;
        const factory = new CheckFunFactory(s, allFuncParams, tgtFuncRetParams, this.factory, tgtVarNameInSpec);
        const addrCallPreFun = factory.preCondCheckFun(this.preAddrError, s.id);
        if (addrCallPreFun) this.funDef.vScope.appendChild(addrCallPreFun);
        const postFun = factory.postCondCheckFun(this.postAddrError, s.id);
        if (postFun) this.funDef.vScope.appendChild(postFun);

        // Generate dispatch_Iface_f
        const dispatchingFun = this.dispatchingFunction(s.id, ifaceName, funName, tgtFunc);
        this.funDef.vScope.appendChild(dispatchingFun);

        // Rewrite the address calls in the function body
        this.funDef.vBody?.walkChildren((node) => {
          // Iface(addr).f(args, ...) -> dispatch_IFace_f(addr, 0, 0 args, ...)
          // we insert dummy value for "msg.value" and "gas", i.e. 0
          if (
            node instanceof FunctionCall &&
            node.vFunctionName === funName &&
            node.vExpression instanceof MemberAccess &&
            node.vExpression.vExpression instanceof FunctionCall &&
            node.vExpression.vExpression.kind == FunctionCallKind.TypeConversion &&
            node.vExpression.vExpression.vFunctionName === ifaceName &&
            node.vExpression.vExpression.vArguments[0] instanceof Identifier &&
            node.vExpression.vExpression.vArguments[0].name == addrName
          ) {
            node.vArguments.unshift(this.factory.makeLiteral('uint256', LiteralKind.Number, '0', '0'));
            node.vArguments.unshift(this.factory.makeLiteral('uint256', LiteralKind.Number, '0', '0'));
            node.vArguments.unshift(node.vExpression.vExpression.vArguments[0]);
            node.vExpression = this.factory.makeIdentifier('function', dispatchFunName(ifaceName, funName), -1);
          }
          // Iface(addr).f{value: v, gas: g}(args, ...) -> dispatch_IFace_f(addr, v, g, args, ...)
          if (
            node instanceof FunctionCall &&
            node.vFunctionName === funName &&
            node.vExpression instanceof FunctionCallOptions &&
            node.vExpression.vExpression instanceof MemberAccess &&
            node.vExpression.vExpression.vExpression instanceof FunctionCall &&
            node.vExpression.vExpression.vExpression.kind == FunctionCallKind.TypeConversion &&
            node.vExpression.vExpression.vExpression.vFunctionName === ifaceName &&
            node.vExpression.vExpression.vExpression.vArguments[0] instanceof Identifier &&
            node.vExpression.vExpression.vExpression.vArguments[0].name == addrName
          ) {
            // Let's assume there is only one value and one gas
            const g = node.vExpression.vOptionsMap.get('gas');
            if (g) node.vArguments.unshift(g);
            const v = node.vExpression.vOptionsMap.get('value');
            if (v) node.vArguments.unshift(v);
            node.vArguments.unshift(node.vExpression.vExpression.vExpression.vArguments[0]);
            node.vExpression = this.factory.makeIdentifier('function', 'dispatch_' + ifaceName + '_' + funName, -1);
          }
        });
      });
    } else {
      /* If not, we should be able to directly insert the pre/post check function into `f`,
       * and not generating `f`_guard.
       * We rename the original function `f` to `f`_original.
       */
      const wrapper = this.guardedFun(preFun, postFun);
      if (wrapper) {
        // if wrapper/guarded function is added, then
        // rename the original function `f` to `f`_original.
        this.funDef.vScope.appendChild(wrapper);
        this.funDef.name = uncheckedFunName(this.tgtName);
        this.funDef.visibility = FunctionVisibility.Private;
        if (this.funDef.isConstructor) {
          // If the spec is attached on a constructor, we generate a new constructor,
          // and the original constructor becomes an ordinary function.
          this.funDef.isConstructor = false;
          this.funDef.kind = FunctionKind.Function;
        }
      }
    }
    // TODO(DX): stateMutability: pure/payable/nonpayable ...
    // TODO(DX): data location
  }
}
