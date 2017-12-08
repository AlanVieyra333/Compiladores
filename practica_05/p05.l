%{
  #include "p05.tab.h"
%}
/*  ************************************************************************  */
DIGIT [0-9]
SIGN [+-]?
INTEGER {SIGN}{DIGIT}+
DECIMAL {SIGN}{DIGIT}*"."{DIGIT}+
NUMBER {INTEGER} | {DECIMAL}
MOD [Mm][Oo][Dd]
STRING "\""[a-zA-Z0-9 ,.]*"\""
VAR [a-zA-Z][a-zA-Z0-9]*
INT_RESERVED "int"
DOUBLE_RESERVED "double"
STRING_RESERVED "string"

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

{INT_RESERVED}	{
  printf("\tPalabra reservada (int).\n");
  
  return(INT_RESERVED);
}

{DOUBLE_RESERVED}	{
  printf("\tPalabra reservada (double).\n");
  
  return(DOUBLE_RESERVED);
}

{STRING_RESERVED}	{
  printf("\tPalabra reservada (string).\n");
  
  return(STRING_RESERVED);
}

{VAR} {
  printf("\tVariable %s\n",yytext);
  yylval.string = str_copy(yytext);

  return VAR;
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

"="	{
  printf("\tSigno igual.\n");
  
  return(yytext[0]);
}

"%"	{
  printf("\tSigno modulo.\n");
  
  return(yytext[0]);
}

";" {
  printf("\tSigno punto y coma.\n");
  
  return(yytext[0]);
}

. ;

%%
