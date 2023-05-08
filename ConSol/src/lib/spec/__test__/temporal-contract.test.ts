import assert from 'assert';
import { CSSpecVisitorString, CSSpecParse, TempSpec } from '../index.js';

describe('temporal contract', () => {
  it('overall', () => {
    const s = 'f(x, y, z) returns (f1) => g{value, gas, gas_}() /\\ 1 + 2';
    const spec: TempSpec<string> = {
      call1: { funName: 'f', kwargs: [], args: ['x', 'y', 'z'], rets: ['f1'] },
      call2: {
        funName: 'g',
        kwargs: ['value', 'gas', 'gas_'],
        args: [],
        rets: [],
      },
      conn: 0,
      cond: '1+2',
    };

    const visitor = new CSSpecVisitorString();
    const spec_ = CSSpecParse(s, visitor) as TempSpec<string>;

    assert.deepEqual(spec, spec_);
  });
});
