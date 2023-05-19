import { CSSpecVisitor, CSSpecParse, ValSpec } from '../index.js';

describe('value (fun) contract', () => {
  const visitor = new CSSpecVisitor((s: string) => {
    return s;
  });

  it('toy case', () => {
    const s = `{ 
        foo (y) returns (x) 
        requires {xxx} 
        ensures {yyy} 
        }`;
    const spec: ValSpec<string> = {
      call: { funName: 'foo', kwargs: [], args: ['y'], rets: ['x'] },
      preCond: 'xxx',
      postCond: 'yyy',
    };

    const spec_ = CSSpecParse(s, visitor) as ValSpec<string>;
    expect(spec_).toEqual(spec);
  });

  it('complex case', () => {
    const s = `{ 
        foo {value:v, gas:g} (argfun, x, argfun2) returns (retFun) 
        requires {xxx} 
        ensures {yyy} 
        where 
            {argfun() ensures{aaa}} 
            {retFun() ensures{bbb}} 
            {argfun2(xxx) returns (hhh) requires{ddd}}
        }`;
    const spec: ValSpec<string> = {
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
    };

    const spec_ = CSSpecParse(s, visitor) as ValSpec<string>;
    expect(spec_).toEqual(spec);
  });
});
