grammar Spec;
// Online test: http://lab.antlr.org/

// Add EOF to ensure that the sexpr in tspec will capture the entire expression.
spec  :   vspec EOF
      |   tspec EOF
      ;
vspec :   '{' (dict)? tuple '|' (sexpr | vspec) '}'
      |   vspec '->' vspec
      ;
tspec :   func TCONN func ( '/\\' sexpr )? ;
tuple :   IDENT
      |   '(' idents ')'
      ;
idents:   (IDENT (',' IDENT)*)? ;
dict  :   '{' (pair (',' pair)*)? '}' ;
pair  :   IDENT ':' IDENT ;
func  :   IDENT '(' idents ')' ('returns' tuple)? ;
sexpr :   ~('{' | '}')+ ;


IDENT :   [a-zA-Z_] [a-zA-Z_0-9]* ;
TCONN :   '=>'
      |   '=/>'
      |   '~>'
      |   '~/>'
      ;
// Define OP for the lexer
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
      |   '.'
      ;
QUOTE :   '\'' | '"' ;
INT   :   [0-9]+
      |   '0' [xX] [0-9a-fA-F]+
      |   '0' [oO]? [0-7]+
      ;
WS    :   [ \n\t\r]+ -> skip ;
