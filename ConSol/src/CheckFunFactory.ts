import {
  ASTContext,
  ASTNodeFactory,
  FunctionDefinition,
  FunctionVisibility,
  FunctionStateMutability,
  LiteralKind,
  FunctionKind,
  ParameterList,
  VariableDeclaration,
  DataLocation,
  StateVariableVisibility,
  Mutability,
  FunctionCallKind,
  ExpressionStatement,
  Expression,
  assert,
  TypeName,
  FunctionCall,
  ErrorDefinition,
} from 'solc-typed-ast';

import { ValSpec } from './spec/index.js';
import { ConSolFactory } from './ConSolFactory.js';
import { postCheckFunName, preCheckFunName, toBeImplemented } from './ConSolUtils.js';

export class CheckFunFactory<T> extends ConSolFactory {
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
    const target = spec.call.tgt;
    if (target.addr !== undefined && target.interface !== undefined) {
      // High-level address call
      this.tgtName = target.interface + '_' + target.func + '_' + spec.id;
    } else if (target.interface !== undefined) {
      // Low-level address call
      toBeImplemented();
    } else {
      // Ordinary function call
      this.tgtName = target.func;
    }
    this.paramVarDecs = params;
    this.retVarDecs = retVarDecs;
    this.guardedParamNames = [...this.spec.call.kwargs.map((p) => p.snd), ...this.spec.call.args];
    this.guardedRetParamNames = this.spec.call.rets;
    this.guardedAllParamNames = [...this.guardedParamNames, ...this.guardedRetParamNames];
  }

  private makeCheckFun(
    funName: string,
    condExpr: T,
    params: ParameterList,
    errorDef: ErrorDefinition,
    errorParamVal: string | number,
  ): FunctionDefinition {
    const condNode = this.factory.makePhantomExpression('bool', (('(' + condExpr) as string) + ')');
    // Make the if-condition (expression)
    const cnd = this.makeNeg(condNode);

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
    const errorCall = this.makeFunCall(this.factory.makeIdentifierFor(errorDef), [errorParam], 'void');

    // Create the revert statement with the error call
    const revertStmt = this.factory.makeRevertStatement(errorCall);
    // Make the if-statement
    const ifStmt = this.factory.makeIfStatement(cnd, revertStmt);
    const funBody = this.factory.makeBlock([ifStmt]);
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

  private makeCheckStmt(funName: string, args: Expression[], errorMsg: string): ExpressionStatement {
    const f = this.factory.makeIdentifier('function', funName, -1);
    const call = this.makeFunCall(f, args, 'bool');
    return this.makeRequireStmt(call, errorMsg);
  }

  preCondCheckFun(errorDef: ErrorDefinition, errorParamVal: string | number): FunctionDefinition | undefined {
    if (this.spec.preCond === undefined) return undefined;
    const preFunName = preCheckFunName(this.tgtName);
    const varDecs = this.makeVarDecs(this.guardedParamNames, this.paramVarDecs);
    const allParams = this.factory.makeParameterList([...varDecs]);
    const preFunDef = this.makeCheckFun(preFunName, this.spec.preCond, allParams, errorDef, errorParamVal);
    return preFunDef;
  }

  postCondCheckFun(errorDef: ErrorDefinition, errorParamVal: string | number): FunctionDefinition | undefined {
    if (this.spec.postCond === undefined) return undefined;
    const postFunName = postCheckFunName(this.tgtName);
    const rets = [...this.guardedParamNames, ...this.guardedRetParamNames];
    const retVarDecs = this.makeVarDecs(rets, [...this.paramVarDecs, ...this.retVarDecs]);
    const allParams = this.factory.makeParameterList([...retVarDecs]);
    const postCondFunc = this.makeCheckFun(postFunName, this.spec.postCond, allParams, errorDef, errorParamVal);
    return postCondFunc;
  }
}
