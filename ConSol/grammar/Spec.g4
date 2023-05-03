grammar Spec;

spec  :   vspec ;
vspec :   '{' (dict)? args '|' expr '}' ;
args  :   IDENT
      |   tuple
      ;
tuple :   '(' idents ')' ;
dict  :   '{' pairs '}' ;
idents:   (IDENT (',' IDENT)*)? ;
pairs :   (pair (',' pair)*)? ;
pair  :   IDENT ':' expr ;
expr  :   expr ('*'|'/') expr
      |   expr ('+'|'-') expr
      |   IDENT
      |   INT
      |   '(' expr ')'
      ;

IDENT: [a-zA-Z_] [a-zA-Z_0-9]*;
INT  : [0-9]+ ;
WS   : [ \n\t\r]+ -> skip ;
