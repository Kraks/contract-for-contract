## Relevant Links
- solc-typed-ast
    - Github: https://github.com/ConsenSys/solc-typed-ast
    - Doc: https://consensys.github.io/solc-typed-ast/
- ANTLR4: https://www.antlr.org/

## Install and Build

```
$ npm install

$ npm run build
```

## Lint

Lint the code before committing.

```
$ npm run lint:fix
```

## Run

```
$ consol <inputfile>
```

For example, 

```
$ consol Lock.sol

$ ls 
    Lock.sol        # input file
    Lock.json       # output json
    Lock_out.sol    # solidity code after transformation.
```

### Explanation

**Output file**: 
- `Lock.json`
    - ast nodes in `data.sources[<filename>.sol].ast.nodes[1].nodes`
    - print ast nodes: 
    > console.log(result.data.sources[ \` ${filename}.sol \` ].ast.nodes[1].nodes)
- `Lock_out.sol`: Solidity code after transformation.


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
