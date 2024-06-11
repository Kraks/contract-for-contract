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
import { isConSolSpec, parseConSolSpec, usesAddr } from './ConSolUtils.js';
import { isValSpec } from './spec/index.js';

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

  handleFunDefSpec<T>(node: ASTNode, spec: ValSpec<T>): boolean {
    if (node instanceof FunctionDefinition) {
      console.log('Parsed function spec AST:');
      console.log(spec);
      new FunDefValSpecTransformer(
        node,
        spec,
        this.preCondError,
        this.postCondError,
        this.preAddrError,
        this.postAddrError,
        this.factory,
      ).process();
      return true;
    }
    return false;
  }

  handleValSpec<T>(node: ASTNode, spec: ValSpec<T>): boolean {
    //if (node instanceof EventDefinition) {
    // Note(GW): allowing to attach pre-cond to events, the pre-cond is
    // checked before the event is emitted. Optional.
    if (node instanceof VariableDeclaration) {
      if (!usesAddr(node.typeString)) {
        console.log('ValSpec on non-address variables is not supported.');
        return false;
      }
      console.log('Parsed storage-address spec AST:');
      console.log(spec);
      new VarDefValSpecTransformer(
        this.contract,
        node,
        spec,
        this.preAddrError,
        this.postAddrError,
        this.factory,
      ).process();
      return true;
    }
    return false;
  }

  extractSpecStrFromDoc(doc: StructuredDocumentation | string): string | undefined {
    if (typeof doc === 'string') {
      return doc;
    } else if (doc instanceof StructuredDocumentation) {
      // @custom:consol
      return doc.text;
    } else {
      return undefined;
    }
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
      const specStr = this.extractSpecStrFromDoc(astNodeDoc);
      if (specStr === undefined || !isConSolSpec(specStr)) return;
      const spec = parseConSolSpec(specStr);
      if (!isValSpec(spec)) return;
      hasConSolSpec = this.handleFunDefSpec(astNode, spec) || hasConSolSpec;
    });

    contract.walkChildren((astNode: ASTNode) => {
      const astNodeDoc = (astNode as ConSolCheckNodes).documentation as StructuredDocumentation | string;
      const specStr = this.extractSpecStrFromDoc(astNodeDoc);
      if (specStr === undefined || !isConSolSpec(specStr)) return;
      const spec = parseConSolSpec(specStr);
      if (!isValSpec(spec)) return;
      hasConSolSpec = this.handleValSpec(astNode, spec) || hasConSolSpec;
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
