## Install and Build

### Relevant Links
- We use a modified version of `solc-typed-ast`
    - Github: https://github.com/Kraks/solc-typed-ast
    - Doc: https://consensys.github.io/solc-typed-ast/
- ANTLR4: https://www.antlr.org/

### Build

```
git clone --recurse-submodules git@github.com:Kraks/contract-for-contract.git
cd contract-for-contract/solc-typed-ast
npm install
cd ../ConSol
npm install
npm run build
```

### Generate Parser from ANTLR4

```
npm run gen:parser
```

### Lint

Lint and format the code before committing.

```
$ npm run lint:fix && npm run format
```

### Test

Run automated test suites.

```
npm run test
```

### Link

To generate the `consol` executable file:

```
$ npm link          # required only for the initial run.
```

## Usage

The `consol` command takes the file path of the input Solidity program
and generates output files under its same folder.
```
$ consol <input-file>
```

For example, running the following command with `Lock.sol` as input
```
$ consol test/Lock.sol
```
generates two files:
```
Lock_ast.json   # output json (for debugging)
Lock_out.sol    # transformed Solidity code with assertion injected
```

The JSON file contains AST nodes in `data.sources[<filename>.sol].ast.nodes[1].nodes`.
To print AST nodes in TS/JS:
```
console.log(result.data.sources[ \` ${filename}.sol \` ].ast.nodes[1].nodes)
```

### Annotations

See `grammar/Spec.g4` for the grammar of ConCol specifications.
ConSol's annotation starts with `@custom:consol`, following
[Solidity's annotation convention](https://docs.soliditylang.org/en/v0.8.11/natspec-format.html).

```
/// @custom:consol ...
```

Or

```
/**
@custom:consol firstline
secondline
*/
```

### Naming Convention

- Files with names ending in `-test.ts` are utilized for testing and are not subject to lint rule enforcement.

### Pre-commit

If you want a pre-commit lint check, place the following script in `.git/hooks/pre-commit`.

```bash
#!/bin/sh

TOPLEVEL=$(git rev-parse --show-toplevel)

cd "$TOPLEVEL/ConSol" && npm run lint
```
