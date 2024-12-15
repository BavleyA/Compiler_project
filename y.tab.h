/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   enum yytokentype {
     MAIN = 258,
     INT = 259,
     FLOAT = 260,
     CHAR = 261,
     NUM = 262,
     VAR = 263,
     IF = 264,
     ELSE = 265,
     LB = 266,
     RB = 276,
     PRINT = 268,
     WHILE = 269,
     IFX = 270,
     
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


