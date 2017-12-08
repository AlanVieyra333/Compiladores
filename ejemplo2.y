%{
//#include <math.h>
%}
             
/* Declaraciones de BISON */
%union{
	int entero;
  double decimal;
}
%token <entero> ENTERO
%token <decimal> DECIMAL
%type <entero> exp
%type <decimal> expd

%left '+' 
             
/* Gramática */
%%
             
input:    /* cadena vacía */
        | input line             
;

line:     '\n'
        | exp '\n'  { printf ("\t\tresultado: %d\n", $1); }
        | expd '\n'  { printf ("\t\tresultado: %f\n", $1); }
;
             
exp:     ENTERO	{ $$ = $1; }
	| exp '+' exp        { $$ = $1 + $3;    }
;

expd:     DECIMAL { $$ = $1; }
  | expd '+' expd        { $$ = $1 + $3;    }
;        
%%

int main() {
  yyparse();
}
             
int yyerror (char *s){
  printf ("--%s--\n", s);
  return 0;
}
            
int yywrap()  
{  
  return 1;  
}  
