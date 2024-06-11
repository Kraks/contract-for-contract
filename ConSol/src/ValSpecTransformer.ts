import {
  FunctionDefinition,
  FunctionVisibility,
  FunctionCallKind,
  Expression,
  LiteralKind,
  Statement,
  FunctionStateMutability,
  FunctionCall,
  FunctionCallOptions,
  MemberAccess,
  Identifier,
  ASTNode,
} from 'solc-typed-ast';

import { DISPATCH_PREFIX, usesAddr } from './ConSolUtils.js';

import { ConSolFactory } from './ConSolFactory.js';
import { freshName } from './Global.js';

export class ValSpecTransformer<T> {
  factory: ConSolFactory;

  constructor(factory: ConSolFactory) {
    this.factory = factory;
  }

  // uint256 -> payable(address(uint160(...)))
  unwrap(x: Expression, payable?: boolean): Expression {
    // TODO: so far only handles flat types
    const cast1 = this.factory.makeFunctionCall('uint160', FunctionCallKind.TypeConversion, this.factory.uint160, [x]);
    const cast2 = this.factory.makeFunctionCall('address', FunctionCallKind.TypeConversion, this.factory.address, [
      cast1,
    ]);
    if (payable) {
      const cast3 = this.factory.makeFunctionCall('payable', FunctionCallKind.TypeConversion, this.factory.payable, [
        cast2,
      ]);
      return cast3;
    }
    return cast2;
  }

  extractSpecId(addr: Expression): Expression {
    const width = this.factory.makeLiteral('uint256', LiteralKind.Number, (160).toString(16), '160');
    const shiftExpr = this.factory.makeBinaryOperation('uint96', '>>', addr, width);
    const castExpr = this.factory.makeFunctionCall('uint96', FunctionCallKind.TypeConversion, this.factory.uint96, [
      shiftExpr,
    ]);
    return castExpr;
  }

  dispatchingFunction(
    rawSpecId: number,
    ifaceName: string,
    funName: string,
    tgtFun: FunctionDefinition,
    preCheckFun: FunctionDefinition | undefined,
    postCheckFun: FunctionDefinition | undefined,
  ): FunctionDefinition {
    const newFun = this.factory.copy(tgtFun);
    newFun.documentation = undefined;
    newFun.visibility = FunctionVisibility.Private;
    newFun.stateMutability = tgtFun.stateMutability; //FunctionStateMutability.NonPayable;
    newFun.name = this.dispatchFunName(ifaceName, funName);

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
    const binAnd = this.factory.makeBinaryOperation('uint', '&', specId, this.encodeSpecIdToUInt96(rawSpecId));
    const cond = this.factory.makeBinaryOperation(
      'uint',
      '!=',
      binAnd,
      this.factory.makeLiteral('uint', LiteralKind.Number, '0', '0'),
    );
    const args = [this.unwrap(addrId), valueId, gasId].concat(
      this.factory.makeIdsFromVarDecs(tgtFun.vParameters.vParameters),
    );
    if (preCheckFun != undefined) {
      const preCheck = this.factory.makeFunctionCall(
        'void',
        FunctionCallKind.FunctionCall,
        this.factory.makeIdentifier('function', `_${ifaceName}_${funName}_${rawSpecId}_pre`, -1),
        args,
      );
      const ifPreCheck = this.factory.makeIfStatement(cond, this.factory.makeExpressionStatement(preCheck));
      bodyStmts.push(ifPreCheck);
    }

    // Generate addr call
    // type freshVar = interface(unwrap(addr)).f{value: value, gas: gas}(args ...);
    const castedAddr = this.factory.makeFunctionCall(
      ifaceName,
      FunctionCallKind.TypeConversion,
      this.factory.makeElementaryTypeNameExpression(ifaceName, ifaceName),
      [this.unwrap(addrId, tgtFun.stateMutability == FunctionStateMutability.Payable)],
    );

    const options = new Map<string, Expression>();
    if (tgtFun.stateMutability == FunctionStateMutability.Payable) {
      options.set('value', this.factory.makeIdentifierFor(valueVarDec));
    }
    options.set('gas', this.factory.makeIdentifierFor(gasVarDec));

    const f = this.factory.makeMemberAccess('function', castedAddr, funName, -1);
    const callOpt = this.factory.makeFunctionCallOptions(tgtFun.vReturnParameters.type, f, options);
    const call = this.factory.makeFunctionCall(
      tgtFun.vReturnParameters.type,
      FunctionCallKind.FunctionCall,
      callOpt,
      this.factory.makeIdsFromVarDecs(tgtFun.vParameters.vParameters),
    );
    let retTypeStr = 'void';
    let retVars: Expression[] = [];
    if (tgtFun.vReturnParameters.vParameters.length > 0) {
      const retTypes = tgtFun.vReturnParameters.vParameters.map((p) =>
        this.factory.makeElementaryTypeName(p.typeString, p.typeString),
      );
      retTypeStr = '(' + retTypes.toString() + ')';
      const retTypeDecls = this.factory.makeTypedVarDecls(
        retTypes,
        retTypes.map((x) => freshName()),
        tgtFun.scope,
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
    if (postCheckFun != undefined) {
      const postCheck = this.factory.makeFunctionCall(
        'void',
        FunctionCallKind.FunctionCall,
        this.factory.makeIdentifier('function', `_${ifaceName}_${funName}_${rawSpecId}_post`, -1),
        argsWithRet,
      );
      const ifPostCheck = this.factory.makeIfStatement(cond, this.factory.makeExpressionStatement(postCheck));
      bodyStmts.push(ifPostCheck);
    }

    newFun.vBody = this.factory.makeBlock(bodyStmts.concat(lastStmts));
    return newFun;
  }

  rewriteAddrCallsInFunBody(
    node: ASTNode,
    tgtFun: string,
    tgtInterface: string | undefined,
    tgtAddr: string | undefined,
  ) {
    const gasLeft = this.factory.makeFunctionCall(
      'uint256',
      FunctionCallKind.FunctionCall,
      this.factory.makeIdentifier('msg', 'gasleft', -1),
      [],
    );

    if (
      node instanceof FunctionCall &&
      node.vFunctionName === tgtFun &&
      node.vExpression instanceof MemberAccess &&
      node.vFunctionName == tgtFun &&
      node.vIdentifier == tgtAddr &&
      node.vExpression.vExpression instanceof Identifier
    ) {
      // addr.fun(args, ...) -> dispatch_IFace_f(addr, 0, gasleft(), args, ...)
      // DX: what if tgtInterface/tgtAddr is undefined?
      if (tgtInterface == undefined) {
        console.error('Address interface undefined. Skip.');
        return;
      }
      console.log('HEEE');
      node.vArguments.unshift(gasLeft);
      node.vArguments.unshift(this.factory.makeLiteral('uint256', LiteralKind.Number, '0', '0'));
      node.vArguments.unshift(node.vExpression.vExpression);
      node.vExpression = this.factory.makeIdentifier('function', this.dispatchFunName(tgtInterface, tgtFun), -1);
    } else if (
      node instanceof FunctionCall &&
      node.vFunctionName === tgtFun &&
      node.vExpression instanceof MemberAccess &&
      node.vExpression.vExpression instanceof FunctionCall &&
      node.vExpression.vExpression.kind == FunctionCallKind.TypeConversion &&
      node.vExpression.vExpression.vFunctionName === tgtInterface &&
      node.vExpression.vExpression.vArguments[0] instanceof Identifier &&
      node.vExpression.vExpression.vArguments[0].name == tgtAddr
    ) {
      // Iface(addr).f(args, ...) -> dispatch_IFace_f(addr, 0, gasleft(), args, ...)
      node.vArguments.unshift(gasLeft);
      node.vArguments.unshift(this.factory.makeLiteral('uint256', LiteralKind.Number, '0', '0'));
      node.vArguments.unshift(node.vExpression.vExpression.vArguments[0]);
      node.vExpression = this.factory.makeIdentifier('function', this.dispatchFunName(tgtInterface, tgtFun), -1);
    } else if (
      node instanceof FunctionCall &&
      node.vFunctionName === tgtFun &&
      node.vExpression instanceof FunctionCallOptions &&
      node.vExpression.vExpression instanceof MemberAccess &&
      node.vExpression.vExpression.vExpression instanceof FunctionCall &&
      node.vExpression.vExpression.vExpression.kind == FunctionCallKind.TypeConversion &&
      node.vExpression.vExpression.vExpression.vFunctionName === tgtInterface &&
      node.vExpression.vExpression.vExpression.vArguments[0] instanceof Identifier &&
      node.vExpression.vExpression.vExpression.vArguments[0].name == tgtAddr
    ) {
      // Iface(addr).f{value: v, gas: g}(args, ...) -> dispatch_IFace_f(addr, v, g, args, ...)
      // Let's assume there is only one value and one gas
      const g = node.vExpression.vOptionsMap.get('gas');
      if (g) node.vArguments.unshift(g);
      const v = node.vExpression.vOptionsMap.get('value');
      if (v) node.vArguments.unshift(v);
      node.vArguments.unshift(node.vExpression.vExpression.vExpression.vArguments[0]);
      node.vExpression = this.factory.makeIdentifier('function', this.dispatchFunName(tgtInterface, tgtFun), -1);
    }
  }

  dispatchFunName(ifaceName: string, funName: string): string {
    const dispatchFunName = DISPATCH_PREFIX + '_' + ifaceName + '_' + funName;
    return dispatchFunName;
  }

  // specId starts 0, but its encoded value starts from 1
  encodeSpecIdToUInt96(specId: number): Expression {
    // uint96(1 << specId);
    const specIdExpr = this.factory.makeLiteral('uint96', LiteralKind.Number, specId.toString(16), specId.toString());
    const one = this.factory.makeLiteral('uint256', LiteralKind.Number, (1).toString(16), '1');
    const shiftExpr = this.factory.makeBinaryOperation('uint256', '<<', one, specIdExpr);
    return this.factory.makeFunctionCall('uint96', FunctionCallKind.TypeConversion, this.factory.uint96, [shiftExpr]);
  }

  attachSpec(addr: Expression, specId: Expression): Expression {
    // addr | (specId << 160);
    const width = this.factory.makeLiteral('uint256', LiteralKind.Number, (160).toString(16), '160');
    const rhs = this.factory.makeBinaryOperation('uint256', '<<', specId, width);
    return this.factory.makeBinaryOperation('uint256', '|', addr, rhs);
  }
}
