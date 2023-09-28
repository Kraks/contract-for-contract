import {
  ASTNodeFactory,
  EventDefinition,
  FunctionDefinition,
  ASTNode,
  StructuredDocumentation,
  ContractDefinition,
  ErrorDefinition,
  UserDefinedValueTypeDefinition,
  StructDefinition,
} from 'solc-typed-ast';

import { ValSpec } from './spec/index.js';
import { SPEC_PREFIX, isConSolSpec, parseConSolSpec } from './ConSolUtils.js';
import { isValSpec, isTempSpec } from './spec/index.js';

import { ConSolFactory } from './ConSolFactory.js';
import { FunDefValSpecTransformer } from './FunDefValSpecTransformer.js';
import { resetStructMap } from './Global.js';

// AST node kinds that allow ConSol spec attachments
type ConSolCheckNodes = FunctionDefinition | EventDefinition;

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

  handleValSpec<T>(node: ASTNode, spec: ValSpec<T>) {
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
    } else {
      console.assert(false, 'unexpected node type: ' + node.constructor.name);
    }
  }

  process(): void {
    const contract = this.contract;
    contract.appendChild(this.preCondError);
    contract.appendChild(this.postCondError);
    contract.appendChild(this.preAddrError);
    contract.appendChild(this.postAddrError);

    resetStructMap();
    contract.walkChildren((astNode) => {
      // TODO: may also need to handle mapping types
      if (astNode instanceof StructDefinition) {
        console.log(`Found struct ${astNode.canonicalName} with ${astNode.vMembers.length} members`);
        globalThis.structMap.set(astNode.canonicalName, astNode);
      }
    })

    contract.walkChildren((astNode: ASTNode) => {
      const astNodeDoc = (astNode as ConSolCheckNodes).documentation as StructuredDocumentation;
      if (!astNodeDoc) return;

      const specStr = astNodeDoc.text;
      if (!isConSolSpec(specStr)) return;

      const spec = parseConSolSpec(specStr);
      console.log('Processing spec :  ' + specStr.substring(SPEC_PREFIX.length).trim());

      if (isValSpec(spec)) {
        this.handleValSpec(astNode, spec);
      } else if (isTempSpec(spec)) {
        // TODO: handle temporal specification
      } else {
        console.assert(false);
      }
    });
  }
}
