import {
  EventDefinition,
  FunctionDefinition,
  VariableDeclaration,
  ASTNode,
  StructuredDocumentation,
  ContractDefinition,
  ErrorDefinition,
  StructDefinition,
} from 'solc-typed-ast';

import { ValSpec } from './spec/index.js';
import { isConSolSpec, parseConSolSpec, trimSpec, usesAddr } from './ConSolUtils.js';
import { isValSpec, isTempSpec } from './spec/index.js';

import { ConSolFactory } from './ConSolFactory.js';
import { FunDefValSpecTransformer } from './FunDefValSpecTransformer.js';
import { VarDefValSpecTransformer } from './VarDefValSpecTransformer.js';
import { resetCSVarId, resetStructMap } from './Global.js';

// AST node kinds that allow ConSol spec attachments
type ConSolCheckNodes = FunctionDefinition | EventDefinition | VariableDeclaration;

export class ConSolTransformer<T> {
  factory: ConSolFactory;
  contract: ContractDefinition;
  interfaces: Array<ContractDefinition>;
  preCondError: ErrorDefinition;
  postCondError: ErrorDefinition;
  preAddrError: ErrorDefinition;
  postAddrError: ErrorDefinition;

  constructor(factory: ConSolFactory, contract: ContractDefinition, ifs: Array<ContractDefinition>) {
    this.factory = factory;
    this.contract = contract;
    this.interfaces = ifs;

    this.preCondError = factory.makeError('preViolation', 'funcName', 'string');
    this.postCondError = factory.makeError('postViolation', 'funcName', 'string');
    this.preAddrError = factory.makeError('preViolationAddr', 'specId', 'uint256');
    this.postAddrError = factory.makeError('postViolationAddr', 'specId', 'uint256');
  }

  handleValSpec<T>(node: ASTNode, spec: ValSpec<T>): boolean {
    console.log('Parsed spec AST:');
    console.log(spec);
    if (node instanceof FunctionDefinition) {
      const trans = new FunDefValSpecTransformer(
        node,
        spec,
        this.preCondError,
        this.postCondError,
        this.preAddrError,
        this.postAddrError,
        this.factory,
      );
      trans.process();
    } else if (node instanceof EventDefinition) {
      // Note(GW): allowing to attach pre-cond to events, the pre-cond is
      // checked before the event is emitted. Optional.
    } else if (node instanceof VariableDeclaration) {
      if (!usesAddr(node.typeString)) {
        console.log('ValSpec on non-address variables is not supported.');
        return false;
      }
      const trans = new VarDefValSpecTransformer(
        this.contract,
        node,
        spec,
        this.preAddrError,
        this.postAddrError,
        this.factory,
      );
      trans.process();
    } else {
      console.assert(false, 'unexpected node type: ' + node.constructor.name);
      return false;
    }
    return true;
  }

  process(): boolean {
    const contract = this.contract;

    resetStructMap();
    resetCSVarId();

    contract.walkChildren((astNode) => {
      // TODO: handle mapping and array types
      if (astNode instanceof StructDefinition) {
        console.log(`Found struct ${astNode.canonicalName} with ${astNode.vMembers.length} members`);
        globalThis.structMap.set(astNode.canonicalName, astNode);
      }

      if (
        astNode instanceof VariableDeclaration &&
        astNode.name === 'curve' &&
        contract.name === 'ExchangeBetweenPools'
      ) {
        // Note: for missing-slippage-check-UnknownVictim-111K, there seems a
        // bug in solc-typed-ast that does not parse the documentation correctly.
        // So we patch the spec to the variable declaration directly.
        astNode.documentation = `@dev {
          PriceInterface(curve).exchange_underlying{value: v, gas: g}(x, y, camount, n)
          ensures { _exchange_underlying_post_condition(camount) } }
        `;
      }
    });

    let hasConSolSpec = false;
    contract.walkChildren((astNode: ASTNode) => {
      const astNodeDoc = (astNode as ConSolCheckNodes).documentation as StructuredDocumentation | string;
      //if (!astNodeDoc) return;

      let specStr: string;
      if (typeof astNodeDoc === 'string') {
        specStr = astNodeDoc;
      } else if (astNodeDoc instanceof StructuredDocumentation) {
        // @custom:consol
        specStr = astNodeDoc.text;
      } else {
        return;
      }
      if (!isConSolSpec(specStr)) return;

      const spec = parseConSolSpec(specStr);
      console.log('Processing spec :  ' + trimSpec(specStr));

      if (isValSpec(spec)) {
        hasConSolSpec = this.handleValSpec(astNode, spec);
      } else if (isTempSpec(spec)) {
        // TODO: handle temporal specification
      } else {
        console.assert(false);
      }
    });

    if (hasConSolSpec && globalThis.customError) {
      contract.appendChild(this.preCondError);
      contract.appendChild(this.postCondError);
      contract.appendChild(this.preAddrError);
      contract.appendChild(this.postAddrError);
    }
    return hasConSolSpec;
  }
}
