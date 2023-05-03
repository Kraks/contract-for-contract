grammar Spec;
// online test: http://lab.antlr.org/

spec  :   vspec ;
vspec :   '{' (dict)? args '|' sexpr '}' ;
args  :   IDENT
      |   '(' idents ')'
      ;
idents:   (IDENT (',' IDENT)*)? ;
dict  :   '{' (pair (',' pair)*)? '}' ;
pair  :   IDENT ':' IDENT ;
sexpr :   ~('{' | '}')+ ;


IDENT :   [a-zA-Z_] [a-zA-Z_0-9]* ;
OP    :   '|'
      |   '&'
      |   '^'
      |   '~'
      |   '+'
      |   '-'
      |   '*'
      |   '/'
      |   '%'
      |   '!'
      |   '?'
      |   ':'
      |   '=='
      |   '!='
      |   '<'
      |   '>'
      |   '<='
      |   '>='
      |   '&&'
      |   '||'
      |   '++'
      |   '--'
      |   '-='
      |   '+='
      |   '*='
      |   '/='
      |   '%='
      |   '>>'
      |   '>>>'
      |   '<<'
      |   '('
      |   ')'
      ;
QUOTE :   '\'' | '"' ;
INT   :   [0-9]+
      |   '0' [xX] [0-9a-fA-F]+
      |   '0' [oO]? [0-7]+
      ;
WS    :   [ \n\t\r]+ -> skip ;
