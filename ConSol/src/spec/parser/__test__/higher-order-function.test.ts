import { jest } from '@jest/globals';
import { createParser, TestErrorListener } from './util.js';

describe('higher-order functions spec', () => {
  describe('Parser', () => {
    const specs = [
      //'{ f | {x | x < 0} -> {y | y > 0} }',
      //'{ f | smallerThanZero -> greaterThanZero }',
      '{ f(g) where { g(x) requires { x > 0 } } }',
    ];
    specs.forEach((specStr) =>
      it(`should parse ${specStr}`, () => {
        const parser = createParser(specStr);
        const syntaxError = jest.fn();
        parser.addErrorListener(new TestErrorListener(syntaxError));
        const tree = parser.spec();
        expect(syntaxError).not.toHaveBeenCalled();
        expect(tree).toBeDefined();
      }),
    );
  });
});
