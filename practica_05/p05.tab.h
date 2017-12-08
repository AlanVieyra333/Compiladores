/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_P05_TAB_H_INCLUDED
# define YY_YY_P05_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif
/* "%code requires" blocks.  */
#line 29 "p05.y" /* yacc.c:1909  */

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

#line 67 "p05.tab.h" /* yacc.c:1909  */

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    INTEGER = 258,
    DECIMAL = 259,
    STRING = 260,
    MOD = 261,
    VAR = 262,
    INT_RESERVED = 263,
    DOUBLE_RESERVED = 264,
    STRING_RESERVED = 265
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 52 "p05.y" /* yacc.c:1909  */

	int integer;
  double decimal;
  char* string;
  sym symbol;

#line 97 "p05.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_P05_TAB_H_INCLUDED  */
