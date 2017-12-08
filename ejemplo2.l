%{
#include "ejemplo2.tab.h"
%}

NUM [0-9]+
DEC [0-9]*"."[0-9]+
%%

{NUM}           {
                printf("\tNumero entero %s\n",yytext);
                yylval.entero = atoi(yytext);
                return (ENTERO);
                }

{DEC}           {
		printf("\tNumero decimal %s\n",yytext);
                yylval.decimal = atof(yytext);
                return (DECIMAL);
                }

"+"	 	{
		printf("\tSigno mas\n");
                return (yytext[0]);
                }

"\n"            {
		printf("\tSalto de linea\n");
                return (yytext[0]);
                }
.               ;
%%
