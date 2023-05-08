import { jest } from '@jest/globals';
import { createParser, TestErrorListener } from './util.js';

describe('address spec', () => {
  describe('Parser', () => {
    const specs = [
      '{ addr | { {value, gas}(arg) | value > 0 } -> { (res, data) | res == true } }',
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
