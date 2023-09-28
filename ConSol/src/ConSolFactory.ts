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
  ASTContext,
} from 'solc-typed-ast';

// Note(GW): this function changes `decls` in-place
function attachNames(names: string[], decls: VariableDeclaration[]) {
  assert(names.length === decls.length, 'Return Variable length wrong');
  names.forEach((name, i) => {
    decls[i].name = name;
  });
}

export class ConSolFactory extends ASTNodeFactory {
  scope: number;

  constructor(context: ASTContext, scope: number) {
    super(context);
    this.scope = scope;
  }

  makeCallStmt(funName: string, args: Expression[], retType = 'void'): ExpressionStatement {
    const f = this.makeIdentifier('function', funName, -1);
    const call = this.makeFunCall(f, args, retType);
    return this.makeExpressionStatement(call);
  }

  makeFunCall(id: Identifier, args: Expression[], retType: string): FunctionCall {
    const call = this.makeFunctionCall(retType, FunctionCallKind.FunctionCall, id, args);
    return call;
  }

  makeTypedVarDecls(types: TypeName[], names: string[], scope: number = this.scope): VariableDeclaration[] {
    assert(types.length == names.length, 'The number of types should equal to the number of names');
    return types.map((ty, i) => {
      const retTypeDecl = this.makeVariableDeclaration(
        false,
        false,
        names[i],
        scope,
        false,
        DataLocation.Default,
        StateVariableVisibility.Default,
        Mutability.Constant,
        types[i].typeString,
      );
      retTypeDecl.vType = ty;
      return retTypeDecl;
    });
  }

  makeNeg(e: Expression): Expression {
    return this.makeUnaryOperation(
      'bool', // typeString
      true, // prefix
      '!', // operator
      e,
    );
  }

  makeRequireStmt(constraint: Expression, msg: string): ExpressionStatement {
    const callArgs = [
      constraint,
      this.makeLiteral('string', LiteralKind.String, Buffer.from(msg, 'utf8').toString('hex'), msg),
    ];
    const requireFn = this.makeIdentifier('function (bool, string memory) pure', 'require', -1);
    const requireCall = this.makeFunctionCall('bool', FunctionCallKind.FunctionCall, requireFn, callArgs);
    return this.makeExpressionStatement(requireCall);
  }

  makeError(eventName: string, paramName: string, paraTypeName: string): ErrorDefinition {
    const param: VariableDeclaration = this.makeVariableDeclaration(
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
    const errorDef = this.makeErrorDefinition(eventName, this.makeParameterList([param]));
    return errorDef;
  }

  strToTypeName(str: string, storage?: string): TypeName {
    if (storage) {
      return this.makeElementaryTypeName('', `${str} ${storage}`);
    }
    // TODO(GW): other types with storage modifier
    return this.makeElementaryTypeName('', str);
  }

  normalize(type: string): string {
    if (type.startsWith('struct')) return type.slice('struct '.length);
    // TODO(GW): also removes storage modifier?
    return type;
  }

  copyNodes<T extends ASTNode>(nodes: Array<T>): Array<T> {
    const newNodes: Array<T> = [];
    nodes.forEach((node, i) => {
      newNodes.push(this.copy(node));
    });
    return newNodes;
  }

  makeVarDecs(names: string[], decls: VariableDeclaration[]): VariableDeclaration[] {
    const params = this.copyNodes(decls);
    attachNames(names, params);
    return params;
  }

  makeIdFromVarDec(vd: VariableDeclaration): Identifier {
    return this.makeIdentifierFor(vd);
  }

  makeIdsFromVarDecs(vds: VariableDeclaration[]): Identifier[] {
    return vds.map((vd) => this.makeIdFromVarDec(vd));
  }

  makeNamelessTypedVarDecls(types: TypeName[]): VariableDeclaration[] {
    return types.map((ty, i) => {
      const retTypeDecl = this.makeVariableDeclaration(
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
