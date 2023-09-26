import { CSSpecVisitor, CSSpecParse, TempSpec, makeTempSpec } from '../../spec/index.js';

describe('temporal contract - parser', () => {
  const visitor = new CSSpecVisitor((s: string) => {
    return s;
  });

  it('no argument and dict', () => {
    const s = '{ f() =/> g() }';
    const spec: TempSpec<string> = makeTempSpec({
      call1: { tgt: { func: 'f' }, kwargs: [], args: [], rets: [] },
      call2: { tgt: { func: 'g' }, kwargs: [], args: [], rets: [] },
      conn: 1,
    });

    const spec_ = CSSpecParse(s, visitor) as TempSpec<string>;
    expect(spec_).toEqual(spec);
  });

  it('single argument without conditions', () => {
    const s = '{ f(x) returns (y) ~> g() returns z }';
    const spec: TempSpec<string> = makeTempSpec({
      call1: { tgt: { func: 'f' }, kwargs: [], args: ['x'], rets: ['y'] },
      call2: { tgt: { func: 'g' }, kwargs: [], args: [], rets: ['z'] },
      conn: 2,
    });

    const spec_ = CSSpecParse(s, visitor) as TempSpec<string>;
    expect(spec_).toEqual(spec);
  });

  it('single argument with pre-condition', () => {
    const s = `
    {
        f(x) returns (y) ~> g() returns z
        when {
            x + y == z
        }
    }
    `;
    const spec: TempSpec<string> = makeTempSpec({
      call1: { tgt: { func: 'f' }, kwargs: [], args: ['x'], rets: ['y'] },
      call2: { tgt: { func: 'g' }, kwargs: [], args: [], rets: ['z'] },
      conn: 2,
      preCond: 'x+y==z',
    });

    const spec_ = CSSpecParse(s, visitor) as TempSpec<string>;
    expect(spec_).toEqual(spec);
  });

  it('single argument with post-condition', () => {
    const s = `
    {
        f(x) returns (y) ~> g() returns z
        ensures {
            x + y == z
        }
    }
    `;
    const spec: TempSpec<string> = makeTempSpec({
      call1: { tgt: { func: 'f' }, kwargs: [], args: ['x'], rets: ['y'] },
      call2: { tgt: { func: 'g' }, kwargs: [], args: [], rets: ['z'] },
      conn: 2,
      postCond: 'x+y==z',
    });

    const spec_ = CSSpecParse(s, visitor) as TempSpec<string>;
    expect(spec_).toEqual(spec);
  });

  it('single argument in dict without conditions', () => {
    const s = '{ f{gas: g1}(x) ~/> g{gas: g2}() }';
    const spec: TempSpec<string> = makeTempSpec({
      call1: {
        tgt: { func: 'f' },
        kwargs: [{ fst: 'gas', snd: 'g1' }],
        args: ['x'],
        rets: [],
      },
      call2: {
        tgt: { func: 'g' },
        kwargs: [{ fst: 'gas', snd: 'g2' }],
        args: [],
        rets: [],
      },
      conn: 3,
    });

    const spec_ = CSSpecParse(s, visitor) as TempSpec<string>;
    expect(spec_).toEqual(spec);
  });

  it('single argument in dict with pre-condition', () => {
    const s = `
    {
        f{gas: g1}(x) ~/> g{gas: g2}()
        when {
            g1 > g2
        }
    }
    `;
    const spec: TempSpec<string> = makeTempSpec({
      call1: {
        tgt: { func: 'f' },
        kwargs: [{ fst: 'gas', snd: 'g1' }],
        args: ['x'],
        rets: [],
      },
      call2: {
        tgt: { func: 'g' },
        kwargs: [{ fst: 'gas', snd: 'g2' }],
        args: [],
        rets: [],
      },
      conn: 3,
      preCond: 'g1>g2',
    });

    const spec_ = CSSpecParse(s, visitor) as TempSpec<string>;
    expect(spec_).toEqual(spec);
  });

  it('single argument in dict with post-condition', () => {
    const s = `
    {
        f{gas: g1}(x) ~/> g{gas: g2}()
        ensures {
            g1 > g2
        }
    }
    `;
    const spec: TempSpec<string> = makeTempSpec({
      call1: {
        tgt: { func: 'f' },
        kwargs: [{ fst: 'gas', snd: 'g1' }],
        args: ['x'],
        rets: [],
      },
      call2: {
        tgt: { func: 'g' },
        kwargs: [{ fst: 'gas', snd: 'g2' }],
        args: [],
        rets: [],
      },
      conn: 3,
      postCond: 'g1>g2',
    });

    const spec_ = CSSpecParse(s, visitor) as TempSpec<string>;
    expect(spec_).toEqual(spec);
  });

  it('muliptles arguments with conditions (1)', () => {
    const s = `
    {
        f{gas: g1, value: v1}(x, y, z) returns w
            ~/> g(a) returns (b, c, d)
        when {
          v1 + x > g1 - w
        }
        ensures {
            x + y + z == b + c + d
        }
    }
    `;
    const spec: TempSpec<string> = makeTempSpec({
      call1: {
        tgt: { func: 'f' },
        kwargs: [
          { fst: 'gas', snd: 'g1' },
          { fst: 'value', snd: 'v1' },
        ],
        args: ['x', 'y', 'z'],
        rets: ['w'],
      },
      call2: {
        tgt: { func: 'g' },
        kwargs: [],
        args: ['a'],
        rets: ['b', 'c', 'd'],
      },
      conn: 3,
      preCond: 'v1+x>g1-w',
      postCond: 'x+y+z==b+c+d',
    });

    const spec_ = CSSpecParse(s, visitor) as TempSpec<string>;
    expect(spec_).toEqual(spec);
  });

  it('muliptles arguments with conditions (2)', () => {
    const s = `
    {
        f(x, y, z) returns (f1)
            => g{value: v1, gas: g1, gas_: g2}()
        when {
            x == v1 && (g1 + g2 == z)
        }
        ensures {
            f1 > 0
        }
    }
    `;
    const spec: TempSpec<string> = makeTempSpec({
      call1: {
        tgt: { func: 'f' },
        kwargs: [],
        args: ['x', 'y', 'z'],
        rets: ['f1'],
      },
      call2: {
        tgt: { func: 'g' },
        kwargs: [
          { fst: 'value', snd: 'v1' },
          { fst: 'gas', snd: 'g1' },
          { fst: 'gas_', snd: 'g2' },
        ],
        args: [],
        rets: [],
      },
      conn: 0,
      preCond: 'x==v1&&(g1+g2==z)',
      postCond: 'f1>0',
    });

    const spec_ = CSSpecParse(s, visitor) as TempSpec<string>;
    expect(spec_).toEqual(spec);
  });
});
