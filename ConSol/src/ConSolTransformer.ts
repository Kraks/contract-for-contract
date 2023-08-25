import {
  ASTNodeFactory,
  EventDefinition,
  FunctionDefinition,
  ASTNode,
  StructuredDocumentation,
  ContractDefinition,
  ErrorDefinition,
} from 'solc-typed-ast';

import { ValSpec } from './spec/index.js';
import { SPEC_PREFIX, isConSolSpec } from './utils.js';
import { CSSpecParse, CSSpecVisitor, CSSpec, isValSpec, isTempSpec } from './spec/index.js';

import { ConSolFactory } from './ConSolFactory.js';
import { FunDefValSpecTransformer } from './FunDefValSpecTransformer.js';

// AST node kinds that allow ConSol spec attachments
type ConSolCheckNodes = FunctionDefinition | EventDefinition;

export class ConSolTransformer<T> {
  factory: ASTNodeFactory;
  contract: ContractDefinition;
  preCondError: ErrorDefinition;
  postCondError: ErrorDefinition;
  preAddrError: ErrorDefinition;
  postAddrError: ErrorDefinition;
  specToId: Map<CSSpec<T>, number>;

  constructor(factory: ASTNodeFactory, scope: number, contract: ContractDefinition) {
    this.factory = factory;
    this.contract = contract;
    this.specToId = new Map<CSSpec<T>, number>();

    const csFactory = new ConSolFactory(factory, scope);
    this.preCondError = csFactory.makeError('preViolation', 'funcName', 'string');
    this.postCondError = csFactory.makeError('postViolation', 'funcName', 'string');
    this.preAddrError = csFactory.makeError('PreViolationAddr', 'specId', 'uint256');
    this.postAddrError = csFactory.makeError('PostViolationAddr', 'specId', 'uint256');
  }

  parseConSolSpec(doc: string): CSSpec<string> {
    const specStr = doc.substring(SPEC_PREFIX.length).trim();
    // console.log('Processing spec: ' + specStr);
    const visitor = new CSSpecVisitor<string>((s) => s);
    const spec = CSSpecParse<string>(specStr, visitor);
    return spec;
  }

  handleValSpec<T>(node: ASTNode, spec: ValSpec<T>) {
    console.log('Parsed spec AST:');
    console.log(spec);
    console.log(spec.tag);
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
      trans.apply();
    } else if (node instanceof EventDefinition) {
      // Note(GW): allowing to attach pre-cond to events, the pre-cond is
      // checked before the event is emitted. Optional.
    } else {
      console.assert(false, 'unexpected node type: ' + node.constructor.name);
    }
  }

  process(): void {
    const contract = this.contract;

    // TODO: traverse twice, spec as key
    contract.appendChild(this.preCondError);
    contract.appendChild(this.postCondError);
    contract.appendChild(this.preAddrError);
    contract.appendChild(this.postAddrError);

    let id = 0;
    contract.walkChildren((astNode: ASTNode) => {
      const astNodeDoc = (astNode as ConSolCheckNodes).documentation as StructuredDocumentation;
      if (!astNodeDoc) return;

      const specStr = astNodeDoc.text;
      if (!isConSolSpec(specStr)) return;
      const spec = this.parseConSolSpec(specStr);

      this.specToId.set(spec as CSSpec<T>, id);
      id += 1;
    });

    console.log(this.specToId);

    contract.walkChildren((astNode: ASTNode) => {
      const astNodeDoc = (astNode as ConSolCheckNodes).documentation as StructuredDocumentation;
      if (!astNodeDoc) return;

      const specStr = astNodeDoc.text;
      if (!isConSolSpec(specStr)) return;

      const spec = this.parseConSolSpec(specStr);
      const specId = this.specToId.get(spec as CSSpec<T>);
      // FIXME: specId is undefined
      console.log('Processing spec ' + specId + ':  ' + specStr.substring(SPEC_PREFIX.length).trim());

      if (isValSpec(spec)) {
        this.handleValSpec(astNode, spec);
      } else if (isTempSpec(spec)) {
        // TODO
      } else {
        console.assert(false);
      }
    });
  }
}
