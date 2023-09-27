import { CSSpecVisitor, CSSpecParse, ValSpec, makeValSpec } from '../../spec/index.js';

describe('value (fun) contract - parser', () => {
  const visitor = new CSSpecVisitor((s: string) => {
    return s;
  });

  it('minimum case', () => {
    const s = `{foo()}`;
    const spec: ValSpec<string> = makeValSpec({
      call: { tgt: { func: 'foo' }, kwargs: [], args: [], rets: [] },
    });

    const spec_ = CSSpecParse(s, visitor) as ValSpec<string>;
    expect(spec_).toEqual(spec);
  });

  it('address', () => {
    const s = `
        { testCallFoo(addr)
        where
          {
            addr{value: v, gas: g}(msg, x) returns (flag, data)
            requires { v > 5 && g < 10000 && x != 0 }
            ensures { flag == true }
          }
        }`;
    const spec: ValSpec<string> = makeValSpec({
      call: { tgt: { func: 'testCallFoo' }, kwargs: [], args: ['addr'], rets: [] },
      preFunSpec: [
        makeValSpec({
          call: {
            tgt: { func: 'addr' },
            kwargs: [
              { fst: 'value', snd: 'v' },
              { fst: 'gas', snd: 'g' },
            ],
            args: ['msg', 'x'],
            rets: ['flag', 'data'],
          },
          id: 0,
          preCond: 'v>5&&g<10000&&x!=0',
          postCond: 'flag==true',
        }),
      ],
    });

    const spec_ = CSSpecParse(s, visitor) as ValSpec<string>;
    expect(spec_).toEqual(spec);
  });

  it('pre and post', () => {
    const s = `{
        foo (y) returns (x)
        requires {xxx}
        ensures {yyy}
        }`;
    const spec: ValSpec<string> = makeValSpec({
      call: { tgt: { func: 'foo' }, kwargs: [], args: ['y'], rets: ['x'] },
      preCond: 'xxx',
      postCond: 'yyy',
    });

    const spec_ = CSSpecParse(s, visitor) as ValSpec<string>;
    expect(spec_).toEqual(spec);
  });

  it('simple function and only funSpec', () => {
    const s = `{
        foo(argfun, argfun2)
        where
            {argfun() ensures{aaa}}
            {argfun2(xxx) returns (hhh) requires{ddd}}
        }`;
    const spec: ValSpec<string> = makeValSpec({
      call: {
        tgt: { func: 'foo' },
        kwargs: [],
        args: ['argfun', 'argfun2'],
        rets: [],
      },
      preFunSpec: [
        makeValSpec({
          call: { tgt: { func: 'argfun' }, kwargs: [], args: [], rets: [] },
          id: 0,
          postCond: 'aaa',
        }),
        makeValSpec({
          call: {
            tgt: { func: 'argfun2' },
            kwargs: [],
            args: ['xxx'],
            rets: ['hhh'],
          },
          id: 1,
          preCond: 'ddd',
        }),
      ],
    });
    const spec_ = CSSpecParse(s, visitor) as ValSpec<string>;
    expect(spec_).toEqual(spec);
  });

  it('only funSpec', () => {
    const s = `{
        foo {value:v, gas:g} (argfun, x, argfun2) returns (retFun)
        where
            {argfun() ensures{aaa}}
            {retFun() ensures{bbb}}
            {argfun2(xxx) returns (hhh) requires{ddd}}
        }`;
    const spec: ValSpec<string> = makeValSpec({
      call: {
        tgt: { func: 'foo' },
        kwargs: [
          { fst: 'value', snd: 'v' },
          { fst: 'gas', snd: 'g' },
        ],
        args: ['argfun', 'x', 'argfun2'],
        rets: ['retFun'],
      },
      preFunSpec: [
        makeValSpec({
          call: { tgt: { func: 'argfun' }, kwargs: [], args: [], rets: [] },
          postCond: 'aaa',
          id: 0,
        }),
        makeValSpec({
          call: {
            tgt: { func: 'argfun2' },
            kwargs: [],
            args: ['xxx'],
            rets: ['hhh'],
          },
          preCond: 'ddd',
          id: 2,
        }),
      ],
      postFunSpec: [
        makeValSpec({
          call: { tgt: { func: 'retFun' }, kwargs: [], args: [], rets: [] },
          postCond: 'bbb',
          id: 1,
        }),
      ],
    });

    const spec_ = CSSpecParse(s, visitor) as ValSpec<string>;
    expect(spec_).toEqual(spec);
  });

  it('postSpec+funSpec', () => {
    const s = `{
        foo {value:v, gas:g} (argfun, x, argfun2) returns (retFun)
        ensures {yyy}
        where
            {argfun() ensures{aaa}}
            {retFun() ensures{bbb}}
            {argfun2(xxx) returns (hhh) requires{ddd}}
        }`;
    const spec: ValSpec<string> = makeValSpec({
      call: {
        tgt: { func: 'foo' },
        kwargs: [
          { fst: 'value', snd: 'v' },
          { fst: 'gas', snd: 'g' },
        ],
        args: ['argfun', 'x', 'argfun2'],
        rets: ['retFun'],
      },
      postCond: 'yyy',
      preFunSpec: [
        makeValSpec({
          call: { tgt: { func: 'argfun' }, kwargs: [], args: [], rets: [] },
          postCond: 'aaa',
          id: 0,
        }),
        makeValSpec({
          call: {
            tgt: { func: 'argfun2' },
            kwargs: [],
            args: ['xxx'],
            rets: ['hhh'],
          },
          preCond: 'ddd',
          id: 2,
        }),
      ],
      postFunSpec: [
        makeValSpec({
          call: { tgt: { func: 'retFun' }, kwargs: [], args: [], rets: [] },
          postCond: 'bbb',
          id: 1,
        }),
      ],
    });

    const spec_ = CSSpecParse(s, visitor) as ValSpec<string>;
    expect(spec_).toEqual(spec);
  });

  it('complex case (funSpec)', () => {
    const s = `{
        foo {value:v, gas:g} (argfun, x, argfun2) returns (retFun)
        requires {xxx}
        ensures {yyy}
        where
            {argfun() ensures{aaa}}
            {retFun() ensures{bbb}}
            {argfun2(xxx) returns (hhh) requires{ddd}}
        }`;
    const spec: ValSpec<string> = makeValSpec({
      call: {
        tgt: { func: 'foo' },
        kwargs: [
          { fst: 'value', snd: 'v' },
          { fst: 'gas', snd: 'g' },
        ],
        args: ['argfun', 'x', 'argfun2'],
        rets: ['retFun'],
      },
      preCond: 'xxx',
      postCond: 'yyy',
      preFunSpec: [
        makeValSpec({
          call: { tgt: { func: 'argfun' }, kwargs: [], args: [], rets: [] },
          postCond: 'aaa',
          id: 0,
        }),
        makeValSpec({
          call: {
            tgt: { func: 'argfun2' },
            kwargs: [],
            args: ['xxx'],
            rets: ['hhh'],
          },
          preCond: 'ddd',
          id: 2,
        }),
      ],
      postFunSpec: [
        makeValSpec({
          call: { tgt: { func: 'retFun' }, kwargs: [], args: [], rets: [] },
          postCond: 'bbb',
          id: 1,
        }),
      ],
    });

    const spec_ = CSSpecParse(s, visitor) as ValSpec<string>;
    expect(spec_).toEqual(spec);
  });

  it('[expect error] undefined function in PreFunSpec', () => {
    const s = `{
        foo {value:v, gas:g} (argfun, x) returns (retFun)
        requires {xxx}
        ensures {yyy}
        where
            {argfun() ensures{aaa}}
            {retFun() ensures{bbb}}
            {argfun2(xxx) returns (hhh) requires{ddd}}
        }`;
    const spec: ValSpec<string> = makeValSpec({
      call: {
        tgt: { func: 'foo' },
        kwargs: [
          { fst: 'value', snd: 'v' },
          { fst: 'gas', snd: 'g' },
        ],
        args: ['argfun', 'x', 'argfun2'],
        rets: ['retFun'],
      },
      preCond: 'xxx',
      postCond: 'yyy',
      preFunSpec: [
        makeValSpec({
          call: { tgt: { func: 'argfun' }, kwargs: [], args: [], rets: [] },
          postCond: 'aaa',
          tag: 'ValSpec',
          id: 0,
        }),
        makeValSpec({
          call: {
            tgt: { func: 'argfun2' },
            kwargs: [],
            args: ['xxx'],
            rets: ['hhh'],
          },
          preCond: 'ddd',
          tag: 'ValSpec',
          id: 1,
        }),
      ],
      postFunSpec: [
        makeValSpec({
          call: { tgt: { func: 'retFun' }, kwargs: [], args: [], rets: [] },
          postCond: 'bbb',
          tag: 'ValSpec',
          id: 2,
        }),
      ],
    });
    const parseSpec = () => {
      CSSpecParse(s, visitor) as ValSpec<string>;
    };

    expect(parseSpec).toThrow();
  });

  it('[expect error] undefined PostFunSpec', () => {
    const s = `{
        foo {value:v, gas:g} (argfun, x, argfun2)
        requires {xxx}
        ensures {yyy}
        where
            {argfun() ensures{aaa}}
            {retFun() ensures{bbb}}
            {argfun2(xxx) returns (hhh) requires{ddd}}
        }`;
    const spec: ValSpec<string> = makeValSpec({
      call: {
        tgt: { func: 'foo' },
        kwargs: [
          { fst: 'value', snd: 'v' },
          { fst: 'gas', snd: 'g' },
        ],
        args: ['argfun', 'x', 'argfun2'],
        rets: ['retFun'],
      },
      preCond: 'xxx',
      postCond: 'yyy',
      preFunSpec: [
        makeValSpec({
          call: { tgt: { func: 'argfun' }, kwargs: [], args: [], rets: [] },
          postCond: 'aaa',
          id: 0,
        }),
        makeValSpec({
          call: {
            tgt: { func: 'argfun2' },
            kwargs: [],
            args: ['xxx'],
            rets: ['hhh'],
          },
          preCond: 'ddd',
          id: 1,
        }),
      ],
      postFunSpec: [
        makeValSpec({
          call: { tgt: { func: 'retFun' }, kwargs: [], args: [], rets: [] },
          postCond: 'bbb',
          id: 2,
        }),
      ],
    });
    const parseSpec = () => {
      CSSpecParse(s, visitor) as ValSpec<string>;
    };

    expect(parseSpec).toThrow();
  });

  it('high-level address cal', () => {
    const s = `{
        foo(addr, x, y)
        where {
          Iface(addr).f(data) ensures { good(data) }
        } }`;

    const spec: ValSpec<string> = makeValSpec({
      preFunSpec: [
        {
          preFunSpec: [],
          postFunSpec: [],
          call: {
            tgt: {
              func: 'f',
              addr: 'addr',
              interface: 'Iface',
            },
            kwargs: [],
            args: ['data'],
            rets: [],
          },
          tag: 'ValSpec',
          postCond: 'good(data)',
          id: 0,
        },
      ],
      postFunSpec: [],
      call: {
        tgt: { func: 'foo' },
        kwargs: [],
        args: ['addr', 'x', 'y'],
        rets: [],
      },
      tag: 'ValSpec',
    });
    const parseSpec = CSSpecParse(s, visitor) as ValSpec<string>;
    expect(parseSpec).toEqual(spec);
  });
});
