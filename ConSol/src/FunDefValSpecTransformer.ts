import {
  ASTContext,
  ASTNodeFactory,
  FunctionDefinition,
  FunctionVisibility,
  FunctionKind,
  VariableDeclaration,
  FunctionCallKind,
  assert,
  TypeName,
  ErrorDefinition,
} from 'solc-typed-ast';

import { ValSpec } from './spec/index.js';
import { extractFunName, uncheckedFunName, extractRawAddr } from './ConSolUtils.js';

import { CheckFunFactory } from './CheckFunFactory.js';
import { LowLevelAddrSpecTransformer } from './LowLevelAddrSpec.js';

export class FunDefValSpecTransformer<T> extends CheckFunFactory<T> {
  funDef: FunctionDefinition;
  retTypes: TypeName[];
  declaredParams: VariableDeclaration[];
  declaredRetParams: VariableDeclaration[];
  preCondError: ErrorDefinition;
  postCondError: ErrorDefinition;
  preAddrError: ErrorDefinition;
  postAddrError: ErrorDefinition;

  constructor(
    funDef: FunctionDefinition,
    spec: ValSpec<T>,
    preCondError: ErrorDefinition,
    postCondError: ErrorDefinition,
    preAddrError: ErrorDefinition,
    postAddrError: ErrorDefinition,
    factory: ASTNodeFactory,
  ) {
    const declaredParams = (funDef as FunctionDefinition).vParameters.vParameters;
    const declaredRetParams = (funDef as FunctionDefinition).vReturnParameters.vParameters;
    const tgtName = extractFunName(funDef);
    if (spec.call.tgt.func !== tgtName) {
      console.error(
        `Error: Mismatch names between the attached function (${tgtName}) the spec (${spec.call.tgt.func}). Abort.`,
      );
      process.exit(-1);
    }
    super(funDef.context as ASTContext, funDef.scope, spec, declaredParams, declaredRetParams, factory);
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
      const preCondStmt = this.makeCallStmt(preCondFun.name, this.makeIdsFromVarDecs(this.declaredParams));
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

  usesAddr(type: string): boolean {
    if (type === 'address') return true;
    if (type === 'address payable') return true;
    if (globalThis.structMap.has(type)) {
      let members = (globalThis.structMap.get(type)?.vMembers || []);
      for (var m of members) {
        if (this.usesAddr(m.typeString)) return true;
      }
    }
    return false;
  }

  process(): void {
    const preFun = this.preCondCheckFun(this.preCondError, this.tgtName);
    if (preFun) this.funDef.vScope.appendChild(preFun);
    const postFun = this.postCondCheckFun(this.postCondError, this.tgtName);
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
