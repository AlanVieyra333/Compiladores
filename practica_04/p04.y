//Exec: flex p04.l && bison -d p04.y && gcc p04.tab.c lex.yy.c -lm && ./a.out
%{
  #include <stdio.h>
  #include <math.h>

  char* getString(char* string) {
    char* newString;
    int len = sizeof string;
    int index = 0;

    newString = malloc (len * sizeof *newString);

    while (1) {
      if(string[index+1] == '"' || string[index+1] == 0){
        break;
      }
      newString[index++] = string[index];
    }

    newString[index++] = 0;
    
    return newString;
  }

  char* catString(char* a, char* b) {
    char* newString;
    int len1 = sizeof a;
    int len2 = sizeof b;
    int index = 0;
    int i = 0;
    int j = 0;

    newString = malloc ((len1 + len2) * sizeof *newString);

    while(1) {
      if(a[i] == 0){
        if (b[j] == 0){
          break;
        } else {
          newString[index++] = b[j++];
        }
      }else {
        newString[index++] = a[i++];
      }
    }

    newString[index] = 0;

    //printf("Cad: %s\n", newString);

    return newString;
  }

  int lenString(char* a) {
    int result = 0;

    while(1){
      if (a[result] == 0) {
        break;
      }

      result++;
    }

    return result;
  }

  int check(char* a, char* b, int index) {
    int result = 1;
    int i = 0;
    int j = 0;

    while(1) {
      if (b[j] == 0) {
        break;
      } else {
        if (a[index + i] != b[j]){
          result = 0;
          break;
        }
        i++;
        j++;
      }
    }

    return result;
  }

  int find(char* a, char* b) {
    int pos = -1;
    int i=0;

    while(1) {
      if (a[i] == 0) {
        break;
      } else {
        if (a[i] == b[0]) {
          if(check(a, b, i)) {
            pos = i;
            break;
          }
        }
        i++;
      }
    }

    return pos;
  }

  char* subString(char* a, char* b) {
    char* newString;
    int len1 = lenString(a);
    int len2 = lenString(b);
    int index = 0;
    int i = 0;
    int j = 0;

    newString = malloc (len1 * sizeof *newString);

    int index1 = find(a, b);
    
    if (index1 != -1) {   // Copy a without b
      while(1) {
        if(a[i] == 0){
          break;
        }else {
          if(i < index1 || i >= (index1 + len2)) {
            newString[index++] = a[i];
          }
        }
        i++;
      }
    } else {  // Copy a
      while(1) {
        if(a[i] == 0){
          break;
        }else {
          newString[index++] = a[i++];
        }
      }
    }

    newString[index] = 0;

    //printf("Cad: %s\n", newString);

    return newString;
  }

  /*struct {
    lexem;
    type;
    value;
  }*/
%}       
/*  ***********************  Declaraciones de BISON  ***********************  */

%union{
	int integer;
  double decimal;
  char* string;
}

%token <integer> INTEGER
%token <decimal> DECIMAL
%token <string> STRING
%token MOD

%type <integer> op_integer
%type <integer> add_integer
%type <integer> sub_integer
%type <integer> mul_integer
%type <integer> div_integer
%type <integer> pow_integer
%type <integer> mod_integer
%type <decimal> op_decimal
%type <decimal> add_decimal
%type <decimal> sub_decimal
%type <decimal> mul_decimal
%type <decimal> div_decimal
%type <decimal> pow_decimal
%type <string> op_string
%type <string> add_string
%type <string> sub_string

%left '+' '-'
%left '*' '/' '^' MOD

/*  *****************************  Gramática  *****************************  */
%%

input: /* cadena vacía */
  | input line
;

line: '\n'
  | op_integer '\n'                     { printf ("\t\tResultado: %d\n", $1); }
  | op_decimal '\n'                     { printf ("\t\tResultado: %f\n", $1); }
  | op_string '\n'                      { printf ("\t\tResultados: %s\n", $1); }
;

op_integer: INTEGER	                    { $$ = $1; }
  | add_integer                         { $$ = $1; }
  | sub_integer                         { $$ = $1; }
  | mul_integer                         { $$ = $1; }
  | div_integer                         { $$ = $1; }
  | pow_integer                         { $$ = $1; }
  | mod_integer                         { $$ = $1; }
;

add_integer: op_integer '+' op_integer  { $$ = $1 + $3; }
;

sub_integer: op_integer '-' op_integer  { $$ = $1 - $3; }
;

mul_integer: op_integer '*' op_integer  { $$ = $1 * $3; }
;

div_integer: op_integer '/' op_integer  { $$ = $1 / $3; }
;

pow_integer: op_integer '^' op_integer  { $$ = (int) pow($1, $3); }
;

mod_integer: MOD '(' op_integer ',' op_integer ')'  { $$ = $3 % $5; }
;

op_decimal: DECIMAL                     { $$ = $1; }
  | add_decimal                         { $$ = $1; }
  | sub_decimal                         { $$ = $1; }
  | mul_decimal                         { $$ = $1; }
  | div_decimal                         { $$ = $1; }
  | pow_decimal                         { $$ = $1; }
;

add_decimal: op_decimal '+' op_decimal  { $$ = $1 + $3; }
  | op_decimal '+' op_integer           { $$ = $1 + $3; }
  | op_integer '+' op_decimal           { $$ = $1 + $3; }
;

sub_decimal: op_decimal '-' op_decimal  { $$ = $1 - $3; }
  | op_decimal '-' op_integer           { $$ = $1 - $3; }
  | op_integer '-' op_decimal           { $$ = $1 - $3; }
;

mul_decimal: op_decimal '*' op_decimal  { $$ = $1 * $3; }
  | op_decimal '*' op_integer           { $$ = $1 * $3; }
  | op_integer '*' op_decimal           { $$ = $1 * $3; }
;

div_decimal: op_decimal '/' op_decimal  { $$ = $1 / $3; }
  | op_decimal '/' op_integer           { $$ = $1 / $3; }
  | op_integer '/' op_decimal           { $$ = $1 / $3; }
;

pow_decimal: op_decimal '^' op_decimal  { $$ = pow($1, $3); }
  | op_decimal '^' op_integer           { $$ = pow($1, $3); }
  | op_integer '^' op_decimal           { $$ = pow($1, $3); }
;

op_string: STRING                       { $$ = $1; }
  | add_string                          { $$ = $1; }
  | sub_string                          { $$ = $1; }
;

add_string: op_string '+' op_string     { $$ = catString($1, $3); }
;

sub_string: op_string '-' op_string     { $$ = subString($1, $3); }
;

%%
/*  *******************************  CÓDIGO  *******************************  */

int main() {
  printf("**********************************************************\n");
  yyparse();
}

int yyerror (char *s) {
  printf ("--%s--\n", s);

  return 0;
}

int yywrap() {
  return 1;
}
