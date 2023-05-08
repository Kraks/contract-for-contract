import { CSSpecVisitor, CSSpecParse, TempSpec } from '../index.js';

describe('temporal contract', () => {
  const visitor = new CSSpecVisitor((s: string) => {
    return s;
  });

  it('no argument and dict', () => {
    const s = 'f() returns () =/> g{}()';
    const spec: TempSpec<string> = {
      call1: { funName: 'f', kwargs: [], args: [], rets: [] },
      call2: { funName: 'g', kwargs: [], args: [], rets: [] },
      conn: 1,
    };

    const spec_ = CSSpecParse(s, visitor) as TempSpec<string>;
    expect(spec_).toEqual(spec);
  });

  it('single argument without side condition', () => {
    const s = 'f{}(x) returns (y) ~> g() returns z';
    const spec: TempSpec<string> = {
      call1: { funName: 'f', kwargs: [], args: ['x'], rets: ['y'] },
      call2: { funName: 'g', kwargs: [], args: [], rets: ['z'] },
      conn: 2,
    };

    const spec_ = CSSpecParse(s, visitor) as TempSpec<string>;
    expect(spec_).toEqual(spec);
  });

  it('single argument with side condition', () => {
    const s = 'f{}(x) returns (y) ~> g() returns z /\\ x + y == z';
    const spec: TempSpec<string> = {
      call1: { funName: 'f', kwargs: [], args: ['x'], rets: ['y'] },
      call2: { funName: 'g', kwargs: [], args: [], rets: ['z'] },
      conn: 2,
      cond: 'x+y==z',
    };

    const spec_ = CSSpecParse(s, visitor) as TempSpec<string>;
    expect(spec_).toEqual(spec);
  });

  it('single argument in dict without side condition', () => {
    const s = 'f{gas}(x) ~/> g{gas}()';
    const spec: TempSpec<string> = {
      call1: { funName: 'f', kwargs: ['gas'], args: ['x'], rets: [] },
      call2: { funName: 'g', kwargs: ['gas'], args: [], rets: [] },
      conn: 3,
    };

    const spec_ = CSSpecParse(s, visitor) as TempSpec<string>;
    expect(spec_).toEqual(spec);
  });

  it('single argument in dict with side condition', () => {
    const s = 'f{gas}(x) ~/> g{gas}() /\\ f.gas > g.gas';
    const spec: TempSpec<string> = {
      call1: { funName: 'f', kwargs: ['gas'], args: ['x'], rets: [] },
      call2: { funName: 'g', kwargs: ['gas'], args: [], rets: [] },
      conn: 3,
      cond: 'f.gas>g.gas',
    };

    const spec_ = CSSpecParse(s, visitor) as TempSpec<string>;
    expect(spec_).toEqual(spec);
  });

  it('muliptles arguments with side condition (1)', () => {
    const s =
      'f{gas, value}(x, y ,z) returns x ~/> g{}(a) returns (b, c, d) /\\ f.value + x > g.gas - a';
    const spec: TempSpec<string> = {
      call1: {
        funName: 'f',
        kwargs: ['gas', 'value'],
        args: ['x', 'y', 'z'],
        rets: ['x'],
      },
      call2: { funName: 'g', kwargs: [], args: ['a'], rets: ['b', 'c', 'd'] },
      conn: 3,
      cond: 'f.value+x>g.gas-a',
    };

    const spec_ = CSSpecParse(s, visitor) as TempSpec<string>;
    expect(spec_).toEqual(spec);
  });

  it('muliptles arguments with side condition (2)', () => {
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

    const spec_ = CSSpecParse(s, visitor) as TempSpec<string>;
    expect(spec_).toEqual(spec);
  });
});
