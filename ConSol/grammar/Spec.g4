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
sexpr : ~('{' | '}' | KEYWORDS)+ ;

call  : target dict? '(' idents ')' ('returns' tuple)? ;

target : IDENT                          // function
       | IDENT '.' IDENT                // low-level addr call
       | IDENT '(' IDENT ')' '.' IDENT  // high-level addr call with signature
;

// dict is non-empty
dict  : '{' pair (',' pair)* '}' ;

pair  : IDENT ':' IDENT ;

// tuple can be empty
tuple : IDENT
      | '(' idents ')'
      ;

idents: (IDENT (',' IDENT)*)? ;

RETURNS : 'returns';
REQUIRES : 'requires';
ENSURES : 'ensures';
WHERE : 'where';

LCURPAR : '{';
RCURPAR : '}';

KEYWORDS : RETURNS | REQUIRES | ENSURES | WHERE ;

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
