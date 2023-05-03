grammar Spec;

spec  :   vspec ;
vspec :   '{' ( '{' (pair (',' pair)*)? '}' )? IDENT '|' expr '}'
      |   '{' ( '{' (pair (',' pair)*)? '}' )? '(' (IDENT (',' IDENT)*)? ')' '|' expr '}'
      ;
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
