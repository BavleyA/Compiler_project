/* C Declarations */

%{
        #include<stdio.h>
        #include<stdlib.h>
        #include<math.h>
        #include<string.h>
        #include "y.tab.h"  
        extern YYSTYPE yylval;
        void yyerror(char *);
        extern FILE *yyin;
        extern FILE *yyout;
        FILE *yyError;
%}

%%
"int"   {return INT;}
"float" {return FLOAT;}
"char"  {return CHAR;}
[0-9]+  {
        yylval = atoi(yytext);
        return NUM;
        }
[a-zA-Z]   {   
        yylval = *yytext - 'a';
        return VAR;
        }
[-+/*<>=,():;%^!]    {
                    yylval = yytext[0];	
                    return  *yytext;	
                    }
"if"    {return IF;}
"else"  {return ELSE;}
"{"     {return '{';}
"}"     {return '}';}
"print" {return PRINT;}
"while"         {return WHILE;}

[#].*   {
        fprintf(yyout,"Comment Found!!\n");
        }
"main"      {return MAIN;}
[ \t\n]*       {}

.           {fprintf(yyError,"%s  ->  Unkown character!!\n",yytext);}

%%

int yywrap()
{
	return 1;
}
