%skeleton "lalr1.cc" 
%defines 
%define api.value.type variant 
%define api.token.constructor 
%code requires
{
  #include "node.h"
}
%code{ 
unsigned int total = 0; 
Node root;
#include <string> 
#define YY_DECL yy::parser::symbol_type yylex() 
YY_DECL; 
} 

%token <std::string> SEMICOLON
%token <std::string> NAME
%token <std::string> BREAK
%token <std::string> RETURN
%token <std::string> EQUAL
%token <std::string> COMMA
%token <std::string> OSBRACKET
%token <std::string> CSBRACKET
%token <std::string> POINT
%token <std::string> OPARENTHESIS
%token <std::string> CPARENTHESIS
%token <std::string> COLON
%token <std::string> STRING
%token <std::string> OBRACKET
%token <std::string> CBRACKET

%token <std::string> DO
%token <std::string> END1

%token <std::string> WHILE
%token <std::string> REPEAT
%token <std::string> UNTIL

%token <std::string> IF
%token <std::string> THEN
%token <std::string> ELSEIF
%token <std::string> ELSE
%token <std::string> FOR
%token <std::string> IN
%token <std::string> FUNCTION
%token <std::string> LOCAL
%token <std::string> THREEPOINT
%token <std::string> PLUS
%token <std::string> MINUS
%token <std::string> ASTERISK
%token <std::string> FSLASH
%token <std::string> HASH
%token <std::string> ARCH
%token <std::string> PERCENTAGE
%token <std::string> LOWER
%token <std::string> GREATER
%token <std::string> NOT
%token <std::string> AND
%token <std::string> OR
%token <std::string> ELOWER
%token <std::string> EGREATER
%token <std::string> ETILDA
%token <std::string> DEQUAL
%token <std::string> TWOPOINT
%token <std::string> SDQUOTE
%token <std::string> SQUOTE

%token <std::string> NIL
%token <std::string> FALSE
%token <std::string> TRUE
%token <std::string> NUMBER
%left PLUS MINUS
%left ARCH ASTERISK FSLASH PERCENTAGE TWOPOINT LOWER GREATER ELOWER EGREATER ETILDA DEQUAL AND OR 
%left NOT 
%left HASH

%type <Node> program
%type <Node> chunk
%type <Node> stats
%type <Node> stat
%type <Node> laststatment
//%type <Node> optional_semicolon
%type <Node> varlist
%type <Node> var
%type <Node> explist
%type <Node> exp
%type <Node> oexplist
%type <Node> block
%type <Node> prefixexp
%type <Node> functioncall
%type <Node> args
%type <Node> tableconstructor
%type <Node> ofieldlist
%type <Node> field
//%type <Node> fieldsep
//%type <Node> ofieldsep
%type <Node> fieldlist
%type <Node> elseif_statement
%type <Node> else_statement
%type <Node> oexpcomma
%type <Node> namelist
%type <Node> funcname
%type <Node> ofuncname
%type <Node> funcbody
%type <Node> parlist
%type <Node> oparlist
%type <Node> opt_parlist
%type <Node> function

//aggiungere robe optionali
//sistemare else if
//sistemare binary 
//ERRORI: FIELDLIST UNOP BINOP
//functioncall
//creare token per i diversi numeri 
//aggiungere regole per i diversi number
//--[.]*commenti
// aggiungere nel bison che la stringa può contenere numeri indicanti caratteri
// aggiungere tutti i caratteri escssappati
//new line
//regex non prende stringa vuota
//cercare commenti con uguali
//program rule for root
//controllare elseif crea nodo anke se vuoto
%token END 0 "end of file" 
%%           
           




           program: chunk {root = $1;}
                  ;

             chunk:stats{$$ = Node("chunk","");$$.children.push_back($1);} 
                  |stats laststatment optional_semicolon{$$ = Node("chunk","");$$.children.push_back($1);$$.children.push_back($2);} 
                  ;

             stats:{$$ = Node("statements","");}
                  |stats stat optional_semicolon {$$ = $1;$$.children.push_back($2);} 
                  ;

optional_semicolon:{}
                  |SEMICOLON
                  ;

             block: chunk{$$=$1;}
                  ;
                  
      laststatment:RETURN oexplist {$$=Node("Returnexp ","");$$.children.push_back($2);}
                  |BREAK {$$=Node("BREAK ",$1);}
                  ;
              
             stat:varlist EQUAL explist    {$$=Node("assign","");$$.children.push_back($1);
                                             $$.children.push_back($3);}
                  | functioncall            {$$=$1;}
                  | DO block END1           {$$=Node("DoNode","");$$.children.push_back($2);}
                  | WHILE exp DO block END1 {$$=Node("WhileNode","");$$.children.push_back($2);
                                             $$.children. push_back($4);}
                  | REPEAT block UNTIL exp  {$$=Node("RepeatNode","");$$.children.push_back($2);
                                             $$.children.push_back($4);}
                  | IF exp THEN block elseif_statement else_statement END1 {$$=Node("IfNode",""); 
                                                                            $$.children.push_back($2);
                                                                            $$.children.push_back($4);$$.children.push_back($5);
                                                                            $$.children.push_back($6);}
                  | FOR NAME EQUAL exp COMMA exp oexpcomma DO block END1   {$$=Node("SimpleForNode","");
                                                                            $$.children.push_back
                                                                            (Node("singlevalue",$2));
                                                                            $$.children.push_back($4);
                                                                            $$.children.push_back($6);
                                                                            $$.children.push_back($7);
                                                                            $$.children.push_back($9);
                                                                            }
                  | FOR namelist IN explist DO block END1                  {$$=Node("CForNode:","");
                                                                            $$.children.push_back($2);
                                                                            $$.children.push_back($4);
                                                                            $$.children.push_back($6); }
                  | FUNCTION funcname funcbody                             {$$=Node("FuncNode:",""); 
                                                                            $$.children.push_back($2);
                                                                            $$.children.push_back($3);
                                                                            }                      
                  | LOCAL FUNCTION NAME funcbody {$$=Node("SmpLocalFunc","");
                                                  $$.children.push_back(Node("singlevalue",$3));
                                                  $$.children.push_back($4);}
                  | LOCAL namelist               {$$=Node("nameListLocalFunc","");$$.children.push_back($2);}
                  | LOCAL namelist EQUAL explist {$$=Node("asgmLocalFunc","");$$.children.push_back($2);
                                                  $$.children.push_back($4);}
                  ;

         oexpcomma: {$$=Node("emptycommaexp","");}
                  | COMMA exp {$$=$2;}
                  ;
          
  elseif_statement: {$$=Node("elseif","");}
                  | elseif_statement ELSEIF exp THEN block {$$=$1;$$.children.push_back($3);
                  ;                                         $$.children.push_back($5);}
                                                       
    else_statement: {$$=Node("emptyelse","");}
                  | ELSE block{$$=Node("ElseNode","");$$.children.push_back($2);}
                  ;

          funcname: NAME {$$=Node("funcName",$1);}
                  | funcname POINT NAME ofuncname {$$=$1; $$.children.push_back(Node("singlevalue",$3));
                                                   $$.children.push_back($4);}
                  ;

        ofuncname:{$$=Node("emptyfunc","");}
                  |COLON NAME {$$=Node("pointfunc",$2);}
                  ;

          varlist : var {$$=Node("varlist","");$$.children.push_back($1);}
                  | varlist COMMA var {$$=$1;$$.children.push_back($3);}
                  ;

               var: NAME{$$=Node("varName",$1);} //covered
                  | prefixexp OSBRACKET exp CSBRACKET {$$=Node("prefixbktName","");$$.children.push_back($1);
                                                       $$.children.push_back($3);}
                  | prefixexp POINT NAME {$$=Node("prefixpointName","");$$.children.push_back($1);$$.children.push_back(Node("singlevalue",$3));}
                  ;

          namelist: NAME {$$=Node("nameList","");$$.children.push_back(Node("singlevalue",$1));}
                  | namelist COMMA NAME{$$=$1;$$.children.push_back(Node("singlevalue",$3)); }
                  ;
                  
           
           explist:exp {$$=Node("explist","");$$.children.push_back($1);}
                  |explist COMMA exp {$$=$1;$$.children.push_back($3);}
                  ;
              
          
          oexplist:{$$=Node("emptyList","");}
                  |explist {$$=$1;}
                  ;

               exp: NIL               {$$=Node("NIL","");}
                  | FALSE             {$$=Node("FALSE","");}
                  | TRUE              {$$=Node("TRUE","");}
                  | NUMBER            {$$=Node("NUMBER",$1);}
                  | STRING            {$1.erase(0, 1);$1.erase($1.size() - 1);$$=Node("STRING",$1);}
                  | THREEPOINT        {$$=Node("TREEPOINT","");}
                  | function          {$$=$1;}
                  | prefixexp         {$$=$1;}
                  | tableconstructor  {$$=$1;}
                  | exp MINUS exp     {$$=Node("substraction","");$$.children.push_back($1);
                                       $$.children.push_back($3);}
                  | exp PLUS exp      {$$=Node("addition","");$$.children.push_back($1);
                                       $$.children.push_back($3);}
                  | exp ASTERISK exp  {$$=Node("multiplication","");$$.children.push_back($1);
                                       $$.children.push_back($3);}
                  | exp FSLASH exp    {$$=Node("division","");$$.children.push_back($1);
                                       $$.children.push_back($3);}
                  | exp ARCH exp      {$$=Node("archexp","");$$.children.push_back($1);
                                       $$.children.push_back($3);}
                  | exp TWOPOINT exp  {$$=Node("twopointexp","");$$.children.push_back($1);
                                       $$.children.push_back($3);}
                  | exp PERCENTAGE exp{$$=Node("percentagexp","");$$.children.push_back($1);
                                       $$.children.push_back($3);}
                  | exp LOWER exp     {$$=Node("lowerdisequation","");$$.children.push_back($1);
                                       $$.children.push_back($3);}
                  | exp ELOWER exp    {$$=Node("elowerdisequation","");$$.children.push_back($1);
                                       $$.children.push_back($3);}
                  | exp GREATER exp   {$$=Node("greaterdisequation","");$$.children.push_back($1);
                                       $$.children.push_back($3);}
                  | exp EGREATER exp  {$$=Node("egreaterdisequation","");$$.children.push_back($1);
                                       $$.children.push_back($3);}
                  | exp DEQUAL exp    {$$=Node("doubleequalexp","");$$.children.push_back($1);
                                       $$.children.push_back($3);}
                  | exp ETILDA exp    {$$=Node("equaltiladaexp","");$$.children.push_back($1);
                                       $$.children.push_back($3);}
                  | exp AND exp       {$$=Node("andexp","");$$.children.push_back($1);
                                       $$.children.push_back($3);}
                  | exp OR exp        {$$=Node("orexp","");$$.children.push_back($1);
                                       $$.children.push_back($3);}
                  | MINUS exp         {$$=Node("uminus","");$$.children.push_back($2);}
                  | NOT exp           {$$=Node("unot","");$$.children.push_back($2);}
                  | HASH exp          {$$=Node("uhash","");$$.children.push_back($2);}
                  ; 
                  

              
         prefixexp:var {$$=Node("prefixvar","");$$.children.push_back($1);}
                  |functioncall{$$=$1;}
                  |OPARENTHESIS exp CPARENTHESIS {$$=$2;}
                  ;

       functioncall: prefixexp args            {$$=Node("fcallprfargs","");$$.children.push_back($1);
                                               $$.children.push_back($2);}
                  | prefixexp COLON NAME args {$$=Node("fcallcolonfargs","");$$.children.push_back($1);
                                               $$.children.push_back($4);}
                  ; 

              args:OPARENTHESIS  oexplist CPARENTHESIS {$$=Node("args","");$$.children.push_back($2);}   
                  | tableconstructor{$$=$1;}
                  | STRING { $1.erase(0, 1);$1.erase($1.size() - 1);$$=Node("String",$1);}
                  ;

          function: FUNCTION funcbody {std::cout<<"FUNCTION: ";}
         
          funcbody:OPARENTHESIS opt_parlist CPARENTHESIS block END1{$$=Node("Funcbody","")   ;
                                                                    $$.children.push_back($2);
                                                                    $$.children.push_back($4);}
                  ;

          parlist :namelist oparlist {$$=Node("parlist","");$$.children.push_back($1);
                                      $$.children.push_back($2);}
                  |THREEPOINT        {$$=Node("threepointparlist","");}
                  ;

          oparlist:{$$=Node("emptyparlist","");}
                  |COMMA THREEPOINT {$$=Node("optparlist","");}
                  ;

       opt_parlist:{$$=Node("emptyparlist","");}
                  |parlist {$$=$1;}
                  ;

  tableconstructor:OBRACKET ofieldlist CBRACKET {$$=Node("bracketList","");$$.children.push_back($2);}
                  ;
         
         fieldlist: field {$$=Node("fieldList","");$$.children.push_back($1);}
                  | fieldlist fieldsep field {$$=$1;$$.children.push_back($3);}
                  ;
 
        ofieldlist: {$$=Node("emptyFieldList","");}
                  | fieldlist ofieldsep{$$=$1;}
                  ; 

            
             field: OSBRACKET exp CSBRACKET EQUAL exp {$$=Node("bracketfield",""); $$.children.push_back($2);
                                                       $$.children.push_back($5);}
                  | NAME EQUAL exp                    {$$=Node("assignfield","");
                                                      $$.children.push_back(Node("singlevalue",$1));
                                                      $$.children.push_back($3);}
                  | exp                               {$$=Node("expfield","");$$.children.push_back($1);}
                  ;

          fieldsep:COMMA 
                  |SEMICOLON
                  ;
         ofieldsep:{}
                  |fieldsep{}
                  ;
          