%top{
#include "binary.tab.hh"
#include <math.h>
extern FILE *yyin;
#define YY_DECL yy::parser::symbol_type yylex()
}
%option noyywrap nounput batch noinput
%%
\;            	                                     return yy::parser::make_SEMICOLON(yytext);
\:                                                   return yy::parser::make_COLON(yytext);
\.                                                   return yy::parser::make_POINT(yytext);
\.\.\.                                               return yy::parser::make_THREEPOINT(yytext);
\=                                                   return yy::parser::make_EQUAL(yytext);
\,                                                   return yy::parser::make_COMMA(yytext);
\[                                                   return yy::parser::make_OSBRACKET(yytext);
\]                                                   return yy::parser::make_CSBRACKET(yytext);
\+                                                   return yy::parser::make_PLUS(yytext);
\-                                                   return yy::parser::make_MINUS(yytext);
\*                                                   return yy::parser::make_ASTERISK(yytext);
\/                                                   return yy::parser::make_FSLASH(yytext);
\<\=                                                 return yy::parser::make_ELOWER(yytext);
\>\=                                                 return yy::parser::make_EGREATER(yytext);
\=\=                                                 return yy::parser::make_DEQUAL(yytext);
\~\=                                                 return yy::parser::make_ETILDA(yytext);
\^                                                   return yy::parser::make_ARCH(yytext);
\%                                                   return yy::parser::make_PERCENTAGE(yytext);
\<                                                   return yy::parser::make_LOWER(yytext);
\>                                                   return yy::parser::make_GREATER(yytext);
\#                                                   return yy::parser::make_HASH(yytext);
\.\.                                                 return yy::parser::make_TWOPOINT(yytext);
break                                                return yy::parser::make_BREAK(yytext); 
do                                                   return yy::parser::make_DO(yytext); 
end                                                  return yy::parser::make_END1(yytext);
while                                                return yy::parser::make_WHILE(yytext); 
repeat                                               return yy::parser::make_REPEAT(yytext); 
until                                                return yy::parser::make_UNTIL(yytext); 
if                                                   return yy::parser::make_IF(yytext); 
then                                                 return yy::parser::make_THEN(yytext); 
elseif                                               return yy::parser::make_ELSEIF(yytext); 
else                                                 return yy::parser::make_ELSE(yytext); 
for                                                  return yy::parser::make_FOR(yytext); 
in                                                   return yy::parser::make_IN(yytext);
function                                             return yy::parser::make_FUNCTION(yytext); 
local                                                return yy::parser::make_LOCAL(yytext);
nil                                                  return yy::parser::make_NIL(yytext);
false                                                return yy::parser::make_FALSE(yytext);
true                                                 return yy::parser::make_TRUE(yytext);  
not                                                  return yy::parser::make_NOT(yytext); 
and                                                  return yy::parser::make_AND(yytext); 
or                                                   return yy::parser::make_OR(yytext); 
return                                               return yy::parser::make_RETURN(yytext);
\(                                                   return yy::parser::make_OPARENTHESIS(yytext);
\)                                                   return yy::parser::make_CPARENTHESIS(yytext);
\{                                                   return yy::parser::make_OBRACKET(yytext);
\}                                                   return yy::parser::make_CBRACKET(yytext);
\"                                                   return yy::parser::make_SDQUOTE(yytext);
\'                                                   return yy::parser::make_SQUOTE(yytext);
\"(\\([[:alpha:]]|[^[:alpha:]])|[^\"\n])*[^\\]\"     return yy::parser::make_STRING(yytext);
\'(\\([[:alpha:]]|[^[:alpha:]])|[^\"\n])*[^\\]\'     return yy::parser::make_STRING(yytext);
\"\"                                                 return yy::parser::make_STRING(yytext);
[a-zA-Z_][a-zA-Z_0-9]*                               return yy::parser::make_NAME(yytext);
[0-9]+                                               return yy::parser::make_NUMBER(yytext);
[0-9]+[eE][+-]?[0-9]+                                return yy::parser::make_NUMBER(yytext);
[0-9]+\.[0-9]+                                       return yy::parser::make_NUMBER(yytext);
[0-9]+\.[0-9]+[eE][+-]?[0-9]+                        return yy::parser::make_NUMBER(yytext);
0x[0-9a-fA-F]+                                       return yy::parser::make_NUMBER(yytext);
[\t\n\r ]+										 	 {}

<<EOF>>         return yy::parser::make_END();
%%
