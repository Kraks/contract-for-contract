import { jest } from '@jest/globals';
import { createParser, TestErrorListener } from './util.js';

describe('first-order value spec', () => {
  describe('Parser', () => {
    const specs = [
      /*
      '{x | 1 + 2}',
      '{ (x) | 1 + 2}',
      '{ (x, y) | 1 + 2}',
      '{ {value, gas} (x, y) | 1 + 2}',
      '{x | x % 1e18 < 1e17}',
      '{y | y < type(uint).max / 1e18}',
      '{x | x % 1e18 < 1e17} -> {y | y < type(uint).max / 1e18}',
      '{x | x < type(uint).max / 1e18}  -> {y | true}',
      '{x | x > 0} -> {y | y < 100} -> {z | z == x + y }',
      '{ (x, y) | x > 0 && y < 100 } -> {z | z == x + y }',
      '{ n | msg.value >= 1e15 * n }',a
      */
      '{ f(x) requires { x > 0 } }'
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
