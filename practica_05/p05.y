//Exec: flex p05.l && bison -d p05.y && gcc p05.tab.c lex.yy.c -lm && ./a.out
%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <math.h>
  #define TRUE 1
  #define FALSE 0
  // Identifiers for recognize the data type of value into symbols table.
  #define INTEGER_ID 0
  #define DECIMAL_ID 1
  #define STRING_ID 2

  // Functions of the operations between strings. 
  char* getString(char* string);
  char* str_add(char* a, char* b);
  int str_len(char* a);
  int str_coincidence(char* a, char* b);
  int str_find(char* a, char* b);
  char* str_sub(char* a, char* b);
  char* str_copy(char*);
  int str_equals(char* a, char* b);

  int findLexem(char* lexem);
  // Size of the symbols table.
  int symbolsTable_size;

%}       
/*  *************************  BISON declarations  *************************  */
%code requires {
  // Data type with 3 different data types inside.
  typedef union {
    int integer;
    float decimal;
    char* string;
  } dataTypes;

  // Symbols table: Lexem, type and value.
  typedef struct {
    char* lexem;          // Ex. var1
    int type;             // Ex. int
    dataTypes value;      // Ex. 60
  } sym;

  // Function for save a new variable into symbols table.
  sym saveIntoSymbolsTable(char* lexem, int type, dataTypes value);
  // Function for update a variable of the symbols table.
  sym updateSymbolsTable(char* lexem, int type, dataTypes value);
  // Declaration of symbols table.
  sym* symbolsTable;
}

%union{
	int integer;
  double decimal;
  char* string;
  sym symbol;
}

%token <integer> INTEGER
%token <decimal> DECIMAL
%token <string> STRING
%token MOD
%token <string> VAR
%token INT_RESERVED
%token DOUBLE_RESERVED
%token STRING_RESERVED

// Rules betwwn integers.
%type <integer> op_integer
%type <integer> add_integer
%type <integer> sub_integer
%type <integer> mul_integer
%type <integer> div_integer
%type <integer> pow_integer
%type <integer> mod_integer
// Rules betwwn decimals.
%type <decimal> op_decimal
%type <decimal> add_decimal
%type <decimal> sub_decimal
%type <decimal> mul_decimal
%type <decimal> div_decimal
%type <decimal> pow_decimal
// Rules betwwn strings.
%type <string> op_string
%type <string> add_string
%type <string> sub_string
// Rules betwwn declarations.
%type <symbol> declaration
%type <symbol> declaration_int
%type <symbol> declaration_double
%type <symbol> declaration_string
// Rules betwwn assignments.
%type <symbol> assignment
%type <symbol> assignment_int
%type <symbol> assignment_double
%type <symbol> assignment_string

// Precedence of operators.
%left '+' '-'
%left '*' '/' '^' MOD

/*  *****************************  Gramática  *****************************  */
%%

input: /* cadena vacía */
  | input line
;

line: '\n'
  | op_integer ';' '\n'                 { printf ("\t\tResultado: %d\n", $1); }
  | op_decimal ';' '\n'                 { printf ("\t\tResultado: %f\n", $1); }
  | op_string ';' '\n'                  { printf ("\t\tResultado: %s\n", $1); }
  | declaration ';' '\n'                {
    printf ("\t\tLa variable '%s' tiene el valor: ", $1.lexem);
    switch($1.type) {
      case INTEGER_ID:
        printf("%d\n", $1.value.integer);
        break;
      case DECIMAL_ID:
        printf("%f\n", $1.value.decimal);
        break;
      case STRING_ID:
        printf("\"%s\"\n", $1.value.string);
        break;
      default:
        break;
    }
  }
  | assignment ';' '\n'                  {
    printf ("\t\tLa variable '%s' tiene el valor: ", $1.lexem);
    switch($1.type) {
      case INTEGER_ID:
        printf("%d\n", $1.value.integer);
        break;
      case DECIMAL_ID:
        printf("%f\n", $1.value.decimal);
        break;
      case STRING_ID:
        printf("\"%s\"\n", $1.value.string);
        break;
      default:
        break;
    }
  }
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

  add_string: op_string '+' op_string     { $$ = str_add($1, $3); }
  ;

  sub_string: op_string '-' op_string     { $$ = str_sub($1, $3); }
  ;

declaration: declaration_int            { $$ = $1; }
  | declaration_double                  { $$ = $1; }
  | declaration_string                  { $$ = $1; }
;

  declaration_int: INT_RESERVED VAR       {
      dataTypes value;
      value.integer = 0;
      $$ = saveIntoSymbolsTable($2, INTEGER_ID, value);
    }
    | INT_RESERVED VAR '=' op_integer     {
      dataTypes value;
      value.integer = $4;
      $$ = saveIntoSymbolsTable($2, INTEGER_ID, value);
    }
  ;

  declaration_double: DOUBLE_RESERVED VAR {
      dataTypes value;
      value.decimal = 0.0;
      $$ = saveIntoSymbolsTable($2, DECIMAL_ID, value);
    }
    | DOUBLE_RESERVED VAR '=' op_decimal     {
      dataTypes value;
      value.decimal = $4;
      $$ = saveIntoSymbolsTable($2, DECIMAL_ID, value);
    }
  ;

  declaration_string: STRING_RESERVED VAR {
      dataTypes value;
      value.string = "";
      $$ = saveIntoSymbolsTable($2, STRING_ID, value);
    }
    | STRING_RESERVED VAR '=' op_string     {
      dataTypes value;
      value.string = $4;
      $$ = saveIntoSymbolsTable($2, STRING_ID, value);
    }
  ;

assignment: assignment_int              { $$ = $1; }
  | assignment_double                   { $$ = $1; }
  | assignment_string                   { $$ = $1; }
;

  assignment_int: VAR '=' op_integer     {
      dataTypes value;
      value.integer = $3;
      $$ = updateSymbolsTable($1, INTEGER_ID, value);
    }
  ;

  assignment_double: VAR '=' op_decimal     {
      dataTypes value;
      value.decimal = $3;
      $$ = updateSymbolsTable($1, DECIMAL_ID, value);
    }
  ;

  assignment_string: VAR '=' op_string     {
      dataTypes value;
      value.string = $3;
      $$ = updateSymbolsTable($1, STRING_ID, value);
    }
  ;

%%
/*  ********************************  CODE  ********************************  */

int main() {
  printf("**********************************************************\n");
  symbolsTable = malloc(sizeof(sym));
  symbolsTable_size = 0;

  yyparse();
}

int yyerror (char *s) {
  printf ("--%s--\n", s);

  return 0;
}

int yywrap() {
  return 1;
}

/*  ********************************  CODE  ********************************  */

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

char* str_add(char* a, char* b) {
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

int str_len(char* a) {
  int result = 0;

  while(1){
    if (a[result] == 0) {
      break;
    }

    result++;
  }

  return result;
}

int str_coincidence(char* a, char* b) {
  int result = 1;
  int i = 0;
  int j = 0;

  while(1) {
    if (b[j] == 0) {
      break;
    } else {
      if (a[i] != b[j]){
        result = 0;
        break;
      }
      i++;
      j++;
    }
  }

  return result;
}

int str_find(char* a, char* b) {
  int pos = -1;
  int i=0;

  while(1) {
    if (a[i] == 0) {
      break;
    } else {
      if (a[i] == b[0]) {
        if(str_coincidence(a + i, b)) {
          pos = i;
          break;
        }
      }
      i++;
    }
  }

  return pos;
}

char* str_sub(char* a, char* b) {
  char* newString;
  int len1 = str_len(a);
  int len2 = str_len(b);
  int index = 0;
  int i = 0;
  int j = 0;

  newString = malloc (len1 * sizeof *newString);

  int index1 = str_find(a, b);
  
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

char* str_copy(char* string){
  char* newString;
  int len = sizeof string;
  int index = 0;

  newString = malloc (len * sizeof *newString);

  while (1) {
    if(string[index] == '\0'){
      break;
    }
    newString[index] = string[index++];
  }

  newString[index++] = 0;
  
  return newString;
}

int str_equals(char* a, char* b) {
  int result = TRUE;
  int aLen = str_len(a);
  int bLen = str_len(b);

  if (aLen == bLen) {
    for (int i=0; i<aLen; i++) {
      if (a[i] != b[i]) {
        result = FALSE;
        break;
      }
    }
  } else {
    result = FALSE;
  }

  return result;
}

sym saveIntoSymbolsTable(char* lexem, int type, dataTypes value){
  int index = findLexem(lexem);

  if (index == -1) {
    symbolsTable[symbolsTable_size].lexem = lexem;
    symbolsTable[symbolsTable_size].type = type;
    symbolsTable[symbolsTable_size].value = value;

    // Resize the symbols table, add one element.
    symbolsTable = realloc(symbolsTable, (++symbolsTable_size + 1) * sizeof(sym));
  } else {
    printf("Error: La variable ya fue declarada anteriormente.\n");
    // Return the old symbol.
    return symbolsTable[index];
  }

  // Return the new symbol.
  return symbolsTable[symbolsTable_size - 1];
}

sym updateSymbolsTable(char* lexem, int type, dataTypes value){
  int index = findLexem(lexem);

  if (index != -1) {
    if (symbolsTable[index].type == type) {
      symbolsTable[index].value = value;
    } else {
      printf("Error: El tipo de dato no coincide.\n");
    }
  } else {
    printf("Error: La variable no ha sido declarada.\n");
  }

  // Return the update symbol.
  return symbolsTable[index];
}

// Function for str_find a lexem into symbols table, return his index. -1 if don't exist.
int findLexem(char* lexem) {
  for (int i=0; i<symbolsTable_size; i++) {
    if (str_equals(symbolsTable[i].lexem, lexem)) {
      return i;
    }
  }

  return -1;
}
