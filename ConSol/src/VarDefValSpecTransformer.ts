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
} from 'solc-typed-ast';

import { ValSpec } from './spec/index.js';
import { GUARD_ADDR_TYPE } from './ConSolUtils.js';
import { ConSolFactory } from './ConSolFactory.js';
import { ValSpecTransformer } from './ValSpecTransformer.js';
import { findContract } from './Global.js';
import { CheckFunFactory } from './CheckFunFactory.js';

const HARDCODE_SPECID = 20; // hard coded for now

export class VarDefValSpecTransformer<T> extends ValSpecTransformer<T> {
  contract: ContractDefinition;
  varDef: VariableDeclaration;
  preAddrError: ErrorDefinition;
  postAddrError: ErrorDefinition;
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
    super(factory);
    this.contract = contract;
    this.varDef = varDef;
    this.preAddrError = preAddrError;
    this.postAddrError = postAddrError;
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
      const asgn = this.factory.makeAssignment('void', '=', id, this.attachSpec(id, this.encodeSpecIdToUInt96(specId)));
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
      // no init value assigned.
      expr = this.factory.makeLiteral('uint160', LiteralKind.Number, '', '0');
    } else if (this.varDef.vValue instanceof FunctionCall && this.varDef.vValue.kind == 'typeConversion') {
      // addr = Interface(0x....);
      expr = this.varDef.vValue.vArguments[0];
    } else {
      // addr = 0x....;
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
    const tgtFun = this.spec.call.tgt.func;
    const tgtInterface = this.spec.call.tgt.interface;
    const tgtAddr = this.spec.call.tgt.addr;
    // const tgtVarNameInSpec = this.spec.call.args[idx];
    if (tgtInterface != undefined) {
      const iface = findContract(tgtInterface);
      if (iface == undefined) {
        console.error(`Error: interface ${tgtInterface} not found. Abort.`);
        process.exit(-1);
      }
      const addrCallFun = iface.vFunctions.find((f) => f.name === tgtFun);
      if (addrCallFun == undefined) {
        console.error(`Error: function ${tgtFun} not found in ${tgtInterface}. Abort.`);
        process.exit(-1);
      }

      // Generate pre/post function for addr calls

      const addrParam = this.factory.makeTypedVarDecls(
        [this.factory.address],
        ['seems doesnt matter'],
        addrCallFun.scope,
      );
      const tgtFuncParams = addrCallFun.vParameters.vParameters;
      const valGasParams = this.factory.makeTypedVarDecls(
        [this.factory.uint256, this.factory.uint256],
        ['value', 'gas'],
        addrCallFun.scope,
      );
      // TODO(DX): hard code spec id for now. storage value spec doesn't have id now

      const specid = HARDCODE_SPECID;

      const allFuncParams = addrParam.concat(valGasParams.concat(tgtFuncParams));
      const tgtFuncRetParams = addrCallFun.vReturnParameters.vParameters;
      const checkFunFactory = new CheckFunFactory(this.spec, allFuncParams, tgtFuncRetParams, this.factory, tgtAddr);
      // console.log(allFuncParams);
      // console.log(tgtFuncRetParams);
      const addrCallPreFun = checkFunFactory.preCondCheckFun(
        this.preAddrError,
        FunctionStateMutability.NonPayable,
        specid,
      );
      if (addrCallPreFun) this.contract.appendChild(addrCallPreFun);
      const addrCallPostFun = checkFunFactory.postCondCheckFun(
        this.postAddrError,
        FunctionStateMutability.NonPayable,
        specid,
      );
      if (addrCallPostFun) this.contract.appendChild(addrCallPostFun);

      // Generate dispatch_Iface_f

      const dispatchingFun = this.dispatchingFunction(
        specid,
        tgtInterface,
        tgtFun,
        addrCallFun,
        addrCallPreFun,
        addrCallPostFun,
      );
      this.contract.appendChild(dispatchingFun);
    }

    for (const func of this.contract.vFunctions) {
      func.vBody?.walkChildren((node) => {
        this.rewriteAddrCallsInFunBody(node, tgtFun, tgtInterface, tgtAddr);
      });
    }
  }
  process(): void {
    // console.log(this.spec);
    this.spec.id = HARDCODE_SPECID;
    const wrapFun = this.createWrapFun([this.spec.id]); // fix: hard code spec id for now
    this.contract.appendChild(wrapFun);

    this.updateVarDeclaration();
    this.iterateFunctions();
  }
}
