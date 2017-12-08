%{
  #include "p04.tab.h"
%}
/*  ************************************************************************  */

DIGIT [0-9]
INTEGER {DIGIT}+
DECIMAL {DIGIT}*"."{DIGIT}+
NUMBER {INTEGER} | {DECIMAL}
MOD [Mm][Oo][Dd]
/*"("{NUMBER}","{NUMBER}");" */
STRING "\""[a-zA-Z0-9 ,.]*"\""

/*  ************************************************************************  */
%%

{INTEGER} {
  printf("\tNumero entero %s\n",yytext);
  yylval.integer = atoi(yytext);

  return (INTEGER);
}

{DECIMAL} {
  printf("\tNumero decimal %s\n",yytext);
  yylval.decimal = atof(yytext);

  return(DECIMAL);
}

{STRING} {
  printf("\tCadena %s\n",yytext);
  yylval.string = getString(yytext);

  return STRING;
}

{MOD} {
  printf("\tOperacion modulo\n");

  return MOD;
}

"+"	{
  printf("\tSigno mas.\n");
  
  return(yytext[0]);
}

"-"	{
  printf("\tSigno menos.\n");
  
  return(yytext[0]);
}

"*"	{
  printf("\tSigno multiplicacion.\n");
  
  return(yytext[0]);
}

"/"	{
  printf("\tSigno division.\n");
  
  return(yytext[0]);
}

"^"	{
  printf("\tSigno potencia.\n");
  
  return(yytext[0]);
}

"\n" {
  printf("\tSalto de linea.\n");

  return (yytext[0]);
}

"\"" {
  printf("\tDoble comilla.\n");

  return (yytext[0]);
}

"(" {
  printf("\tParentesis abierto.\n");

  return (yytext[0]);
}

")" {
  printf("\tParentesis cerrado.\n");

  return (yytext[0]);
}

"," {
  printf("\tComa.\n");

  return (yytext[0]);
}

. ;

%%
