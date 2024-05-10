import {
  FunctionDefinition,
  FunctionVisibility,
  FunctionStateMutability,
  LiteralKind,
  FunctionKind,
  ParameterList,
  VariableDeclaration,
  ErrorDefinition,
  FunctionCallKind,
} from 'solc-typed-ast';

import { ValSpec } from './spec/index.js';
import { ConSolFactory } from './ConSolFactory.js';
import { postCheckFunName, preCheckFunName, toBeImplemented } from './ConSolUtils.js';

export class CheckFunFactory<T> {
  spec: ValSpec<T>;
  tgtName: string;
  // Note(GW): these are parameters used for generating check functions, but they may not have correct binding names
  paramVarDecs: VariableDeclaration[];
  retVarDecs: VariableDeclaration[];
  guardedParamNames: string[];
  guardedRetParamNames: string[];
  guardedAllParamNames: string[];
  factory: ConSolFactory;

  constructor(
    spec: ValSpec<T>,
    params: VariableDeclaration[],
    retVarDecs: VariableDeclaration[],
    factory: ConSolFactory,
    tgtAddrName?: string,
  ) {
    this.factory = factory;
    this.spec = spec;
    const target = spec.call.tgt;
    this.paramVarDecs = params;
    this.retVarDecs = retVarDecs;
    this.guardedParamNames = [...this.spec.call.kwargs.map((p) => p.snd), ...this.spec.call.args];
    this.guardedRetParamNames = this.spec.call.rets;
    this.guardedAllParamNames = [...this.guardedParamNames, ...this.guardedRetParamNames];
    if (target.addr !== undefined && target.interface !== undefined && tgtAddrName !== undefined) {
      // High-level address call
      this.tgtName = target.interface + '_' + target.func + '_' + spec.id;
      this.guardedParamNames.unshift(tgtAddrName);
    } else if (target.interface !== undefined) {
      // Low-level address call
      toBeImplemented();
    } else {
      // Ordinary function call
      this.tgtName = target.func;
    }
  }

  private makeCheckFun(
    funName: string,
    condExpr: T,
    params: ParameterList,
    errorDef: ErrorDefinition,
    mutability: FunctionStateMutability,
    errorParamVal: string | number,
  ): FunctionDefinition {
    const condNode = this.factory.makePhantomExpression('bool', (('(' + condExpr) as string) + ')');
    // Make the if-condition (expression)
    const cnd = this.factory.makeNeg(condNode);

    let errorParam;
    if (typeof errorParamVal === 'number') {
      errorParam = this.factory.makeLiteral(
        'uint256',
        LiteralKind.Number,
        String(errorParamVal),
        String(errorParamVal),
      );
    } else {
      errorParam = this.factory.makeLiteral('string', LiteralKind.String, errorParamVal, errorParamVal);
    }

    // Create the function call for the error
    const errorCall = this.factory.makeFunCall(this.factory.makeIdentifierFor(errorDef), [errorParam], 'void');

    // Create the revert statement with the error call
    let revertStmt;
    if (globalThis.customError) {
      revertStmt = this.factory.makeRevertStatement(errorCall);
    } else {
      const call = this.factory.makeFunctionCall(
        'void',
        FunctionCallKind.FunctionCall,
        this.factory.makeIdentifier('this', 'revert', -1),
        [],
      );
      revertStmt = this.factory.makeExpressionStatement(call);
    }
    // Make the if-statement
    const ifStmt = this.factory.makeIfStatement(cnd, revertStmt);
    const funBody = this.factory.makeBlock([ifStmt]);
    const checkFunDef = this.factory.makeFunctionDefinition(
      this.factory.scope,
      FunctionKind.Function,
      funName,
      false, // virtual
      FunctionVisibility.Private,
      mutability,
      false, // funKind == FunctionKind.Constructor,
      params,
      this.factory.makeParameterList([]), // returnParameters
      [], //modifier
      undefined,
      funBody,
    );
    return checkFunDef;
  }

  /*
  private makeCheckStmt(funName: string, args: Expression[], errorMsg: string): ExpressionStatement {
    const f = this.makeIdentifier('function', funName, -1);
    const call = this.makeFunCall(f, args, 'bool');
    return this.makeRequireStmt(call, errorMsg);
  }
  */

  preCondCheckFun(errorDef: ErrorDefinition, mutability:FunctionStateMutability, errorParamVal: string | number): FunctionDefinition | undefined {
    if (this.spec.preCond === undefined) return undefined;
    const preFunName = preCheckFunName(this.tgtName);
    const varDecs = this.factory.makeVarDecs(this.guardedParamNames, this.paramVarDecs);
    const allParams = this.factory.makeParameterList([...varDecs]);
    const preFunDef = this.makeCheckFun(preFunName, this.spec.preCond, allParams, errorDef, mutability, errorParamVal);
    return preFunDef;
  }

  postCondCheckFun(errorDef: ErrorDefinition, mutability:FunctionStateMutability, errorParamVal: string | number): FunctionDefinition | undefined {
    if (this.spec.postCond === undefined) return undefined;
    const postFunName = postCheckFunName(this.tgtName);
    const rets = [...this.guardedParamNames, ...this.guardedRetParamNames];
    //console.log(rets);
    //console.log(this.paramVarDecs.map((v) => v.name))
    const retVarDecs = this.factory.makeVarDecs(rets, [...this.paramVarDecs, ...this.retVarDecs]);
    const allParams = this.factory.makeParameterList([...retVarDecs]);
    const postCondFunc = this.makeCheckFun(postFunName, this.spec.postCond, allParams, errorDef, mutability, errorParamVal);
    return postCondFunc;
  }
}
