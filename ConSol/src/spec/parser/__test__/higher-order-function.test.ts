import { jest } from '@jest/globals';
import { createParser, TestErrorListener } from './util.js';

describe('higher-order functions spec', () => {
  describe('Parser', () => {
    const specs = [
      '{ f(x, g) requires { x > 0 } where { g(x) requires { x > 0 } } }',
      `{ f(x, g) returns (h, y) requires { x > 0 } where { g(x) requires { x > 0 } }
         ensures { y == 0 } where { h(z) returns r requires { z + r > 0 } ensures { z != 0 } }
       }`,
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
