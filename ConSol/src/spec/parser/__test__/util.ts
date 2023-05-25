import SpecLexer from '../SpecLexer.js';
import SpecParser from '../SpecParser.js';
import { CharStream, CommonTokenStream } from 'antlr4';

export const createParser = (specStr: string): SpecParser => {
  const chars = new CharStream(specStr);
  const lexer = new SpecLexer(chars);
  const tokens = new CommonTokenStream(lexer);
  return new SpecParser(tokens);
};
