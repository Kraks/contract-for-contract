import {
  FunctionDefinition,
  FunctionVisibility,
  FunctionKind,
  VariableDeclaration,
  FunctionCallKind,
  assert,
  TypeName,
  ErrorDefinition,
  Identifier,
  Expression,
} from 'solc-typed-ast';

import { ValSpec } from './spec/index.js';
import { GUARD_ADDR_TYPE, extractFunName, uncheckedFunName } from './ConSolUtils.js';

import { CheckFunFactory } from './CheckFunFactory.js';
import { ConSolFactory } from './ConSolFactory.js';
import { freshName } from './Global.js';

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

  // Note: argument takes no prefix such as `struct`
  usesAddr(type: string): boolean {
    if (type === 'address') return true;
    if (type === 'address payable') return true;
    if (globalThis.structMap.has(type)) {
      const b = globalThis.structMap.get(type)?.vMembers.some((m) => this.usesAddr(m.typeString));
      if (b) return true;
    }
    // TODO: handle mappings and arrays
    return false;
  }

  // Note: argument takes no prefix such as `struct`
  wrapType(type: string): string {
    if (type === 'address') return GUARD_ADDR_TYPE;
    if (type === 'address payable') return GUARD_ADDR_TYPE;
    // XXX (GW): we have directly changed the struct definition, would also need
    // to provide accessors the unwrap?
    if (globalThis.structMap.has(type)) {
      const struct = globalThis.structMap.get(type);
      const members = struct?.vMembers || [];
      // FIXME: It seems we cannot just change the existing struct type, but need to
      // create a new struct type with a different name but changed member types...
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

  // x -> uint256(uint160(address(x)))
  wrap(x: Identifier): Expression {
    if (this.usesAddr(x.typeString)) {
      // TODO: only handles flat types so far, need to handle struct, array, mapping, etc.
      // How should we do that?
      // Note that (1) the struct type definition has been changed, (2) may need to recreate a value
      // of the new struct type.
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

  process(): void {
    const preFun = this.cfFactory.preCondCheckFun(this.preCondError, this.tgtName);
    if (preFun) this.funDef.vScope.appendChild(preFun);
    const postFun = this.cfFactory.postCondCheckFun(this.postCondError, this.tgtName);
    if (postFun) this.funDef.vScope.appendChild(postFun);

    /*
    const addrTrans = this.spec.preFunSpec.map((s) => this.addrTransformers(s));
    addrTrans.forEach((tr) => tr.apply());
    */

    /**
     * Given an input function `f`, we will have `f`, `f`_guard, and `f`_original.
     * - If `f` takes/returns values with addresses, we need to generate a new function
     *   that preserves `f`'s name and signature. The body of the new function calls
     *   `f`_guard with `wrapped` arguments.
     *   If not, we should be able to directly insert the pre/post check function into `f`.
     * - The `f`_guard function guards the call of `f`_original with pre/post condition check.
     *   Importantly, `f`_guard will also take/return values with guarded address representation (i.e. uint256).
     * - The `f`_original function is the original function body, whose body might have been
     *   rewritten with dispatched address calls.
     */

    const paramUseAddr = this.funDef.vParameters.vParameters
      .map((p) => this.factory.normalize(p.typeString))
      .some((t) => this.usesAddr(t));
    const retUseAddr = this.funDef.vReturnParameters.vParameters
      .map((p) => this.factory.normalize(p.typeString))
      .some((t) => this.usesAddr(t));

    if (paramUseAddr || retUseAddr) {
      const newFun = this.factory.copy(this.funDef);
      newFun.documentation = undefined;
      const callee = this.factory.makeIdentifier('function', this.tgtName + '_guard', -1);
      const args = this.funDef.vParameters.vParameters.map((p) => {
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
        // TODO: unwrap
        const retTypeDecls = this.factory.makeTypedVarDecls(
          retTypes,
          retTypes.map((x) => freshName()),
          this.funDef.scope,
        );
        const retIds = retTypeDecls.map((r) => r.id);
        const callAndAssignStmt = this.factory.makeVariableDeclarationStatement(retIds, retTypeDecls, callsite);
        const retValTuple = this.factory.makeTupleExpression(
          guardRetTy,
          false,
          retTypeDecls.map((r) => this.factory.makeIdentifierFor(r)),
        );
        const retStmt = this.factory.makeReturn(retValTuple.id, retValTuple);
        newFun.vBody = this.factory.makeBlock([callAndAssignStmt, retStmt]);
      } else {
        newFun.vBody = this.factory.makeBlock([callsite]);
      }
      this.funDef.vScope.appendChild(newFun);
    }

    const wrapper = this.guardedFun(preFun, postFun);
    if (wrapper) {
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
    // TODO(DX): stateMutability: pure/payable/nonpayable ...
    // TODO(DX): data location
  }
}
