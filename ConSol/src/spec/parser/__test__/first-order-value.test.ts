import { jest } from '@jest/globals';
import { createParser, TestErrorListener } from './util.js';

describe('first-order value spec', () => {
  describe('Parser', () => {
    const specs = [
      '{ f(x) requires { x > 0 } }',
      '{ f(x) returns y requires { x > 0 } ensures { y > x } }',
      '{ f(x1, x2) returns (y, z) requires { x1 + z > 0 } ensures { y - z > x2 } }',
      '{ f{value: v, gas: g}(x1, x2) returns (y, z) requires { x1 + z > v } ensures { y - z > x2 + g } }',
      '{ f{value: v, gas: g}(x1, x2) returns (y, z) requires { x1 + z > v } ensures { y < type(uint).max / 1e18 } }',
      '{ f{value: v, gas: g}(x1, x2) returns (y, z) requires { msg.value >= 1e15 } ensures { y < type(uint).max / 1e18 } }',
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
