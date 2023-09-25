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

function preCheckFunName(f: string): string {
  return '_' + f + 'Pre';
}

function postCheckFunName(f: string): string {
  return '_' + f + 'Post';
}

export class ValSpecTransformer<T> extends ConSolFactory {
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

  makeFlatCheckFun(
    funName: string,
    condExpr: T,
    params: ParameterList,
    errorDef: ErrorDefinition,
    errorParamVal: string | number,
  ): FunctionDefinition {
    const condNode = this.factory.makePhantomExpression('bool', condExpr as string);

    // Make the if-condition (expression)
    const ifCondition = this.factory.makeUnaryOperation(
      'bool', // typeString
      true, // prefix
      '!', // operator
      condNode,
    );

    // Define the error
    const errorId = this.factory.makeIdentifierFor(errorDef);

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
    const errorCall = this.factory.makeFunctionCall(
      'void',
      FunctionCallKind.FunctionCall,
      errorId,
      [errorParam], // Arguments
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

  preCondCheckFun(errorDef: ErrorDefinition, errorParamVal: string | number): FunctionDefinition | undefined {
    if (this.spec.preCond === undefined) return undefined;
    const preFunName = preCheckFunName(this.tgtName);
    // TODO(GW): should use factory.makeParameterList...
    const varDecs = this.makeVarDecs(this.guardedParamNames, this.paramVarDecs);
    const allParams = new ParameterList(0, '', [...varDecs]);
    const preFunDef = this.makeFlatCheckFun(preFunName, this.spec.preCond, allParams, errorDef, errorParamVal);
    return preFunDef;
  }

  postCondCheckFun(errorDef: ErrorDefinition, errorParamVal: string | number): FunctionDefinition | undefined {
    if (this.spec.postCond === undefined) return undefined;
    const postFunName = postCheckFunName(this.tgtName);
    const rets = [...this.guardedParamNames, ...this.guardedRetParamNames];
    const retVarDecs = this.makeVarDecs(rets, [...this.paramVarDecs, ...this.retVarDecs]);
    const allParams = new ParameterList(0, '', [...retVarDecs]);
    const postCondFunc = this.makeFlatCheckFun(postFunName, this.spec.postCond, allParams, errorDef, errorParamVal);
    return postCondFunc;
  }
}
