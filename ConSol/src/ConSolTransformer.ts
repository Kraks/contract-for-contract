import {
  ASTNodeFactory,
  VariableDeclaration,
  ASTNode,
  DataLocation,
  StateVariableVisibility,
  Mutability,
  TypeName,
  Identifier,
} from 'solc-typed-ast';
import { attachNames } from './utils.js';

export class ConSolTransformer {
  factory: ASTNodeFactory;
  scope: number;

  constructor(factory: ASTNodeFactory, scope: number) {
    this.factory = factory;
    this.scope = scope;
  }

  strToTypeName(str: string): TypeName {
    if (str === 'bytes') return this.factory.makeElementaryTypeName('', 'bytes memory');
    if (str === 'string') return this.factory.makeElementaryTypeName('', 'string memory');
    // TODO(GW): other types with storage modifier
    return this.factory.makeElementaryTypeName('', str);
  }

  copyNodes<T extends ASTNode>(nodes: Array<T>): Array<T> {
    const newNodes: Array<T> = [];
    nodes.forEach((node, i) => {
      newNodes.push(this.factory.copy(node));
    });
    return newNodes;
  }

  makeVarDecs(names: string[], decls: VariableDeclaration[]): VariableDeclaration[] {
    const params = this.copyNodes(decls);
    attachNames(names, params);
    return params;
  }

  makeIdFromVarDec(vd: VariableDeclaration): Identifier {
    return this.factory.makeIdentifierFor(vd);
  }

  makeIdsFromVarDecs(vds: VariableDeclaration[]): Identifier[] {
    return vds.map((vd) => this.makeIdFromVarDec(vd));
  }

  makeNamelessTypedVarDecls(types: TypeName[]): VariableDeclaration[] {
    return types.map((ty, i) => {
      const retTypeDecl = this.factory.makeVariableDeclaration(
        false,
        false,
        '',
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

  makeTypedIds(xs: string[], ts: TypeName[]): Identifier[] {
    // Note(GW): is it necessary to make variable declaration first???
    return this.makeIdsFromVarDecs(this.makeVarDecs(xs, this.makeNamelessTypedVarDecls(ts)));
  }
}
