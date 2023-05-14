import { jest } from '@jest/globals';
import { createParser, TestErrorListener } from './util.js';

describe('address spec', () => {
  describe('Parser', () => {
    const specs = [
      '{ f(addr) where { addr{value: v, gas: g}(arg) returns (res, data) requires {v > 0} ensures {res == true} } }'
    ];
    specs.forEach((specStr) =>
      it(`should parse ${specStr}`, () => {
        const parser = createParser(specStr);
        const syntaxErrorHandler = jest.fn();
        parser.addErrorListener(new TestErrorListener(syntaxErrorHandler));
        const tree = parser.spec();
        expect(syntaxErrorHandler).not.toHaveBeenCalled();
        expect(tree).toBeDefined();
      }),
    );
  });
});
