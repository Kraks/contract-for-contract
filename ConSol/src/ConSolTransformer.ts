import {
  ASTNodeFactory,
  EventDefinition,
  FunctionDefinition,
  VariableDeclaration,
  ASTNode,
  DataLocation,
  StateVariableVisibility,
  Mutability,
  StructuredDocumentation,
  ContractDefinition,
  ErrorDefinition,
} from 'solc-typed-ast';

import { ValSpec } from './spec/index.js';
import { SPEC_PREFIX, isConSolSpec } from './utils.js';
import { CSSpecParse, CSSpecVisitor, CSSpec, isValSpec, isTempSpec } from './spec/index.js';

import { ConSolFactory } from './ConSolFactory.js';
import { FunDefValSpecTransformer } from './FunDefValSpecTransformer.js';

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
      // TODO: optional
    } else {
      console.assert(false, 'wow');
    }
  }

  process(): void {
    // AST node kinds that allow ConSol spec attachments
    type ConSolCheckNodes = FunctionDefinition | EventDefinition;
    // TODO: traverse twice, spec as key
    this.contract.appendChild(this.preCondError);
    this.contract.appendChild(this.postCondError);
    this.contract.appendChild(this.preAddrError);
    this.contract.appendChild(this.postAddrError);

    let id = 0;
    this.contract.walkChildren((astNode: ASTNode) => {
      const astNodeDoc = (astNode as ConSolCheckNodes).documentation as StructuredDocumentation;
      if (!astNodeDoc) return;
      const specStr = astNodeDoc.text;
      if (!isConSolSpec(specStr)) return;
      // console.log('Processing spec: ' + specStr.substring(SPEC_PREFIX.length).trim());
      const spec = this.parseConSolSpec(specStr);

      this.specToId.set(spec as CSSpec<T>, id);
      id += 1;
    });

    console.log(this.specToId);

    this.contract.walkChildren((astNode: ASTNode) => {
      const astNodeDoc = (astNode as ConSolCheckNodes).documentation as StructuredDocumentation;
      if (!astNodeDoc) return;
      const specStr = astNodeDoc.text;
      if (!isConSolSpec(specStr)) return;
      // console.log('Processing spec: ' + specStr.substring(SPEC_PREFIX.length).trim());
      const spec = this.parseConSolSpec(specStr);
      const specId = this.specToId.get(spec as CSSpec<T>);
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
