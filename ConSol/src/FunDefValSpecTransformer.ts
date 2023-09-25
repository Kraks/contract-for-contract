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
import { extractFunName, uncheckedFunName, extractRawAddr } from './utils.js';

import { ValSpecTransformer } from './ValSpecTransformer.js';
import { AddrValSpecTransformer } from './AddrValSpecTransformer.js';

export class FunDefValSpecTransformer<T> extends ValSpecTransformer<T> {
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

  findTargetAddr(def: FunctionDefinition, parentSpec: ValSpec<T>, addr: string): VariableDeclaration {
    return def.vParameters.vParameters[parentSpec.call.args.findIndex((a) => a === addr)];
  }

  addrTransformers(addrSpec: ValSpec<T>): AddrValSpecTransformer<T> {
    const tgtAddr = this.findTargetAddr(this.funDef, this.spec, extractRawAddr(addrSpec));
    return new AddrValSpecTransformer(
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
    // TODO(DX): data location
  }
}
