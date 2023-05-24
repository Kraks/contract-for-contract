import { CSSpecVisitor, CSSpecParse, ValSpec, makeValSpec } from '../index.js';

describe('value (fun) contract', () => {
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
        {
          call: { funName: 'argfun', kwargs: [], args: [], rets: [] },
          postCond: 'aaa',
        },
        {
          call: {
            funName: 'argfun2',
            kwargs: [],
            args: ['xxx'],
            rets: ['hhh'],
          },
          preCond: 'ddd',
        },
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
        {
          call: { funName: 'argfun', kwargs: [], args: [], rets: [] },
          postCond: 'aaa',
        },
        {
          call: {
            funName: 'argfun2',
            kwargs: [],
            args: ['xxx'],
            rets: ['hhh'],
          },
          preCond: 'ddd',
        },
      ],
      postFunSpec: [
        {
          call: { funName: 'retFun', kwargs: [], args: [], rets: [] },
          postCond: 'bbb',
        },
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
        {
          call: { funName: 'argfun', kwargs: [], args: [], rets: [] },
          postCond: 'aaa',
        },
        {
          call: {
            funName: 'argfun2',
            kwargs: [],
            args: ['xxx'],
            rets: ['hhh'],
          },
          preCond: 'ddd',
        },
      ],
      postFunSpec: [
        {
          call: { funName: 'retFun', kwargs: [], args: [], rets: [] },
          postCond: 'bbb',
        },
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
        {
          call: { funName: 'argfun', kwargs: [], args: [], rets: [] },
          postCond: 'aaa',
        },
        {
          call: {
            funName: 'argfun2',
            kwargs: [],
            args: ['xxx'],
            rets: ['hhh'],
          },
          preCond: 'ddd',
        },
      ],
      postFunSpec: [
        {
          call: { funName: 'retFun', kwargs: [], args: [], rets: [] },
          postCond: 'bbb',
        },
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
        {
          call: { funName: 'argfun', kwargs: [], args: [], rets: [] },
          postCond: 'aaa',
        },
        {
          call: {
            funName: 'argfun2',
            kwargs: [],
            args: ['xxx'],
            rets: ['hhh'],
          },
          preCond: 'ddd',
        },
      ],
      postFunSpec: [
        {
          call: { funName: 'retFun', kwargs: [], args: [], rets: [] },
          postCond: 'bbb',
        },
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
        {
          call: { funName: 'argfun', kwargs: [], args: [], rets: [] },
          postCond: 'aaa',
        },
        {
          call: {
            funName: 'argfun2',
            kwargs: [],
            args: ['xxx'],
            rets: ['hhh'],
          },
          preCond: 'ddd',
        },
      ],
      postFunSpec: [
        {
          call: { funName: 'retFun', kwargs: [], args: [], rets: [] },
          postCond: 'bbb',
        },
      ],
    });
    const parseSpec = () => {
      CSSpecParse(s, visitor) as ValSpec<string>;
    };

    expect(parseSpec).toThrow();
  });
});
