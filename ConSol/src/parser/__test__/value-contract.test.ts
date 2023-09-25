import { CSSpecVisitor, CSSpecParse, ValSpec, makeValSpec } from '../../spec/index.js';

describe('value (fun) contract - parser', () => {
  const visitor = new CSSpecVisitor((s: string) => {
    return s;
  });
  it('minimum case', () => {
    const s = `{foo()}`;
    const spec: ValSpec<string> = makeValSpec({
      call: { funName: 'foo', kwargs: [], args: [], rets: [] },
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
      call: { funName: 'testCallFoo', kwargs: [], args: ['addr'], rets: [] },
      preFunSpec: [
        makeValSpec({
          call: {
            funName: 'addr',
            kwargs: [
              { fst: 'value', snd: 'v' },
              { fst: 'gas', snd: 'g' },
            ],
            args: ['msg', 'x'],
            rets: ['flag', 'data'],
          },
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
      call: { funName: 'foo', kwargs: [], args: ['y'], rets: ['x'] },
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
        funName: 'foo',
        kwargs: [],
        args: ['argfun', 'argfun2'],
        rets: [],
      },
      preFunSpec: [
        makeValSpec({
          call: { funName: 'argfun', kwargs: [], args: [], rets: [] },
          postCond: 'aaa',
        }),
        makeValSpec({
          call: {
            funName: 'argfun2',
            kwargs: [],
            args: ['xxx'],
            rets: ['hhh'],
          },
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
        funName: 'foo',
        kwargs: [
          { fst: 'value', snd: 'v' },
          { fst: 'gas', snd: 'g' },
        ],
        args: ['argfun', 'x', 'argfun2'],
        rets: ['retFun'],
      },
      preFunSpec: [
        makeValSpec({
          call: { funName: 'argfun', kwargs: [], args: [], rets: [] },
          postCond: 'aaa',
        }),
        makeValSpec({
          call: {
            funName: 'argfun2',
            kwargs: [],
            args: ['xxx'],
            rets: ['hhh'],
          },
          preCond: 'ddd',
        }),
      ],
      postFunSpec: [
        makeValSpec({
          call: { funName: 'retFun', kwargs: [], args: [], rets: [] },
          postCond: 'bbb',
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
        funName: 'foo',
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
          call: { funName: 'argfun', kwargs: [], args: [], rets: [] },
          postCond: 'aaa',
        }),
        makeValSpec({
          call: {
            funName: 'argfun2',
            kwargs: [],
            args: ['xxx'],
            rets: ['hhh'],
          },
          preCond: 'ddd',
        }),
      ],
      postFunSpec: [
        makeValSpec({
          call: { funName: 'retFun', kwargs: [], args: [], rets: [] },
          postCond: 'bbb',
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
        funName: 'foo',
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
          call: { funName: 'argfun', kwargs: [], args: [], rets: [] },
          postCond: 'aaa',
        }),
        makeValSpec({
          call: {
            funName: 'argfun2',
            kwargs: [],
            args: ['xxx'],
            rets: ['hhh'],
          },
          preCond: 'ddd',
        }),
      ],
      postFunSpec: [
        makeValSpec({
          call: { funName: 'retFun', kwargs: [], args: [], rets: [] },
          postCond: 'bbb',
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
        funName: 'foo',
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
          call: { funName: 'argfun', kwargs: [], args: [], rets: [] },
          postCond: 'aaa',
          tag: 'ValSpec',
        }),
        makeValSpec({
          call: {
            funName: 'argfun2',
            kwargs: [],
            args: ['xxx'],
            rets: ['hhh'],
          },
          preCond: 'ddd',
          tag: 'ValSpec',
        }),
      ],
      postFunSpec: [
        makeValSpec({
          call: { funName: 'retFun', kwargs: [], args: [], rets: [] },
          postCond: 'bbb',
          tag: 'ValSpec',
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
        funName: 'foo',
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
          call: { funName: 'argfun', kwargs: [], args: [], rets: [] },
          postCond: 'aaa',
        }),
        makeValSpec({
          call: {
            funName: 'argfun2',
            kwargs: [],
            args: ['xxx'],
            rets: ['hhh'],
          },
          preCond: 'ddd',
        }),
      ],
      postFunSpec: [
        makeValSpec({
          call: { funName: 'retFun', kwargs: [], args: [], rets: [] },
          postCond: 'bbb',
        }),
      ],
    });
    const parseSpec = () => {
      CSSpecParse(s, visitor) as ValSpec<string>;
    };

    expect(parseSpec).toThrow();
  });
});
