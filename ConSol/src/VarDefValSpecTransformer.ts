import {
  FunctionDefinition,
  ContractDefinition,
  FunctionVisibility,
  FunctionStateMutability,
  VariableDeclaration,
  ErrorDefinition,
  FunctionKind,
  FunctionCallKind,
  LiteralKind,
  FunctionCall,
  MemberAccess,
  FunctionCallOptions,
  Identifier,
} from 'solc-typed-ast';

import { ValSpec } from './spec/index.js';
import { GUARD_ADDR_TYPE, attachSpec, encodeSpecIdToUInt96, dispatchFunName } from './ConSolUtils.js';
import { ConSolFactory } from './ConSolFactory.js';

export class VarDefValSpecTransformer<T> {
  contract: ContractDefinition;
  varDef: VariableDeclaration;
  preAddrError: ErrorDefinition;
  postAddrError: ErrorDefinition;
  factory: ConSolFactory;
  spec: ValSpec<T>;
  tgtName: string;

  constructor(
    contract: ContractDefinition,
    varDef: VariableDeclaration,
    spec: ValSpec<T>,
    preAddrError: ErrorDefinition,
    postAddrError: ErrorDefinition,
    factory: ConSolFactory,
  ) {
    this.contract = contract;
    this.varDef = varDef;
    this.preAddrError = preAddrError;
    this.postAddrError = postAddrError;
    this.factory = factory;
    this.spec = spec;
    this.tgtName = '_wrap_' + varDef.name;
  }

  createWrapFun(specIds: number[]): FunctionDefinition {
    // Create the wrap_addr function
    const stmts = [];

    const param = this.factory.makeTypedVarDecl(this.factory.address, 'addr', 0);

    const wrappedAddr = this.factory.makeTypedVarDecl(this.factory.uint256, '_addr', 0);

    const retParam = this.factory.makeTypedVarDecl(this.factory.uint256, '', 0);

    const initialAssignment = this.factory.makeAssignment(
      GUARD_ADDR_TYPE,
      '=',
      wrappedAddr,
      this.factory.makeFunctionCall(GUARD_ADDR_TYPE, FunctionCallKind.TypeConversion, this.factory.uint256, [
        this.factory.makeFunctionCall('uint160', FunctionCallKind.TypeConversion, this.factory.uint160, [
          this.factory.makeIdFromVarDec(param),
        ]),
      ]),
    );

    const assignmentStmt = this.factory.makeExpressionStatement(initialAssignment);
    stmts.push(assignmentStmt);

    // attach spec ids
    specIds.forEach((specId) => {
      const id = this.factory.makeIdFromVarDec(wrappedAddr);
      const asgn = this.factory.makeAssignment(
        'void',
        '=',
        id,
        attachSpec(this.factory, id, encodeSpecIdToUInt96(this.factory, specId)),
      );
      const asgnStmt = this.factory.makeExpressionStatement(asgn);
      stmts.push(asgnStmt);
    });

    // Create the return statement
    const returnStmt = this.factory.makeReturn(0, this.factory.makeIdentifierFor(wrappedAddr));

    stmts.push(returnStmt);
    const funBody = this.factory.makeBlock(stmts);

    return this.factory.makeFunctionDefinition(
      0,
      FunctionKind.Function,
      this.tgtName,
      false,
      FunctionVisibility.Private,
      FunctionStateMutability.Pure,
      false, // isConstructor
      this.factory.makeParameterList([param]),
      this.factory.makeParameterList([retParam]),
      [],
      undefined,
      funBody,
    );
  }

  updateVarDeclaration(): void {
    let expr;
    if (this.varDef.vValue == undefined) {
      expr = this.factory.makeLiteral('uint160', LiteralKind.Number, '', '0');
    } else {
      expr = this.varDef.vValue;
    }

    const wrapFun = this.factory.makeFunctionCall(
      GUARD_ADDR_TYPE,
      FunctionCallKind.FunctionCall,
      this.factory.makeIdentifier('function', this.tgtName, 0),
      [expr],
    );

    this.varDef.vValue = wrapFun;
    this.varDef.typeString = GUARD_ADDR_TYPE;
    this.varDef.vType = this.factory.makeElementaryTypeName('', GUARD_ADDR_TYPE);
  }

  iterateFunctions(): void {
    // DX: this spec only has one target function?
    const funName = this.spec.call.tgt.func;
    const ifaceName = this.spec.call.tgt.interface;
    const addrName = this.spec.call.tgt.addr;
    for (const func of this.contract.vFunctions) {
      if (func.vBody) {
        func.vBody?.walkChildren((node) => {
          // Iface(addr).f(args, ...) -> dispatch_IFace_f(addr, 0, 0 args, ...)
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
      }
    }
  }
  process(): void {
    // console.log(this.spec);
    const wrapFun = this.createWrapFun([42, 2]); // fix: hard code spec id for now
    this.contract.appendChild(wrapFun);

    this.updateVarDeclaration();
    this.iterateFunctions();
  }
}
