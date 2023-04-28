## Relevant Links
- solc-typed-ast
    - Github: https://github.com/ConsenSys/solc-typed-ast
    - Doc: https://consensys.github.io/solc-typed-ast/
- ANTLR4: https://www.antlr.org/

## Install

Follow the [official instruction](https://github.com/ConsenSys/solc-typed-ast/tree/master#installation).

1. `npm install solc-typed-ast` 
2. `npm install ts-node` or install typescript


## Run

```
npx ts-node run.ts
```

**Input file**: `Lock.sol`  (To compile other files, change the variable `filename` in `run.ts`)

**Output file**: 
- `Lock.json`
    - ast nodes in `data.sources[<filename>.sol].ast.nodes[1].nodes`
    - print ast nodes: 
    > console.log(result.data.sources[ \` ${filename}.sol \` ].ast.nodes[1].nodes)
- `Lock_out.sol`: Solidity code after transformation.



Other way to compile: `sol-ast-compile Lock.sol --tree `


## Annotation
Follow [Solidity Annotation](https://docs.soliditylang.org/en/v0.8.11/natspec-format.html). 

```
/// @custom:consol ...
```

Or 

```
/**
@custom:consol  firstline
secondline
*/
```
