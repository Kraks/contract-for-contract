grammar Spec;

spec  : vspec EOF
      | tspec EOF
      ;

vspec : '{' call
          ('requires' '{' sexpr '}')?
          ('ensures' '{' sexpr '}')?
          ('where' vspec*)?
        '}'
;

tspec : '{' call TCONN call
          ('when' '{' sexpr '}')?
          ('ensures' '{' sexpr '}')?
        '}'
;
sexpr : ~('{' | '}')+ ;

call  : fname ( dict )? '(' idents ')' ('returns' tuple)? ;

fname : IDENT ( '.' IDENT)?;

// dict is non-empty
dict  : '{' pair (',' pair)* '}' ;

pair  : IDENT ':' IDENT ;

// tuple can be empty
tuple : IDENT
      | '(' idents ')'
      ;

idents: (IDENT (',' IDENT)*)? ;

IDENT : [a-zA-Z_] [a-zA-Z_0-9]* ;
TCONN : '=>'
      | '=/>'
      | '~>'
      | '~/>'
      ;
OP    : '|'
      | '&'
      | '^'
      | '~'
      | '+'
      | '-'
      | '*'
      | '/'
      | '%'
      | '!'
      | '?'
      | ':'
      | '=='
      | '!='
      | '<'
      | '>'
      | '<='
      | '>='
      | '&&'
      | '||'
      | '++'
      | '--'
      | '-='
      | '+='
      | '*='
      | '/='
      | '%='
      | '>>'
      | '>>>'
      | '<<'
      | '('
      | ')'
      | '.'
      ;
QUOTE : '\'' | '"' ;
INT   : [0-9]+
      | '0' [xX] [0-9a-fA-F]+
      | '0' [oO]? [0-7]+
      ;
WS    :   [ \n\t\r]+ -> skip ;
