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
} from 'solc-typed-ast';

import { ValSpec } from './spec/index.js';
import { GUARD_ADDR_TYPE } from './ConSolUtils.js';
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

  createWrapFun(): FunctionDefinition {
    // Create the wrap_fun function

    const param = this.factory.makeTypedVarDecl(this.factory.address, 'addr', 0);

    const retParam = this.factory.makeTypedVarDecl(this.factory.uint256, '', 0);

    const cast1 = this.factory.makeFunctionCall('uint160', FunctionCallKind.TypeConversion, this.factory.uint160, [
      this.factory.makeIdFromVarDec(param),
    ]);

    const cast2 = this.factory.makeFunctionCall(
      GUARD_ADDR_TYPE,
      FunctionCallKind.TypeConversion,
      this.factory.uint256,
      [cast1],
    );
    const returnStmt = this.factory.makeReturn(0, cast2);

    const funBody = this.factory.makeBlock([returnStmt]);

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

  process(): void {
    const wrapFun = this.createWrapFun();
    this.contract.appendChild(wrapFun);

    this.updateVarDeclaration();
  }
}
