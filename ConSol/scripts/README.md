# Scripts

## Purpose

The script folder is designed to collect automated scripts.
You can also put your own testing scripts here, but it may not be a good idea to push your own testing scripts.

## Usage

In a testing typescript file, if you would like to import some file in the `src` folder, use relative path like this:

```typescript
import SpecLexer from '../src/spec/parser/SpecLexer.js';
````

To run a typescript file, use:

```
npx ts-node-esm <path/to/file.ts>
```

No need to compile before running.
