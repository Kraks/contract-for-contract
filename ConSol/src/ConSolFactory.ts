import assert from 'assert';
import {
  ASTNodeFactory,
  VariableDeclaration,
  ASTNode,
  DataLocation,
  StateVariableVisibility,
  Mutability,
  TypeName,
  Identifier,
  ErrorDefinition,
  Expression,
  ExpressionStatement,
  LiteralKind,
  FunctionCallKind,
  FunctionCall,
} from 'solc-typed-ast';

// Note(GW): this function changes `decls` in-place
function attachNames(names: string[], decls: VariableDeclaration[]): VariableDeclaration[] {
  assert(names.length === decls.length, 'Return Variable length wrong');
  names.forEach((name, i) => {
    decls[i].name = name;
  });
  return decls;
}

export class ConSolFactory {
  factory: ASTNodeFactory;
  scope: number;

  constructor(factory: ASTNodeFactory, scope: number) {
    this.factory = factory;
    this.scope = scope;
  }

  makeCallStmt(funName: string, args: Expression[], retType = 'void'): ExpressionStatement {
    const f = this.factory.makeIdentifier('function', funName, -1);
    const call = this.makeFunCall(f, args, retType);
    return this.factory.makeExpressionStatement(call);
  }

  makeFunCall(id: Identifier, args: Expression[], retType: string): FunctionCall {
    const call = this.factory.makeFunctionCall(retType, FunctionCallKind.FunctionCall, id, args);
    return call;
  }

  makeTypedVarDecls(types: TypeName[], names: string[]): VariableDeclaration[] {
    assert(types.length == names.length, 'The number of types should equal to the number of names');
    return types.map((ty, i) => {
      const retTypeDecl = this.factory.makeVariableDeclaration(
        false,
        false,
        names[i],
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

  makeNeg(e: Expression): Expression {
    return this.factory.makeUnaryOperation(
      'bool', // typeString
      true, // prefix
      '!', // operator
      e,
    );
  }

  makeRequireStmt(constraint: Expression, msg: string): ExpressionStatement {
    const callArgs = [
      constraint,
      this.factory.makeLiteral('string', LiteralKind.String, Buffer.from(msg, 'utf8').toString('hex'), msg),
    ];
    const requireFn = this.factory.makeIdentifier('function (bool, string memory) pure', 'require', -1);
    const requireCall = this.factory.makeFunctionCall('bool', FunctionCallKind.FunctionCall, requireFn, callArgs);
    return this.factory.makeExpressionStatement(requireCall);
  }

  makeError(eventName: string, paramName: string, paraTypeName: string): ErrorDefinition {
    const param: VariableDeclaration = this.factory.makeVariableDeclaration(
      false,
      false,
      paramName,
      // this.scope, // -> error, why???
      0,
      false,
      DataLocation.Default,
      StateVariableVisibility.Default,
      Mutability.Mutable,
      paraTypeName,
    );
    param.vType = this.strToTypeName(paraTypeName);
    const errorDef = this.factory.makeErrorDefinition(eventName, this.factory.makeParameterList([param]));
    return errorDef;
  }

  strToTypeName(str: string, storage?: string): TypeName {
    if (storage) {
      return this.factory.makeElementaryTypeName('', `${str} ${storage}`);
    }
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
