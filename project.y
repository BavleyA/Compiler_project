%{
        #include<stdio.h>
        #include<stdlib.h>
        #include<string.h>
        #include<math.h>
        int yylex(void);
        void yyerror(char *);
        extern FILE *yyin;
        extern FILE *yyout;
        FILE *yyError;
        int sym[1000];
        int flag = 1;
%}

%token MAIN INT FLOAT CHAR NUM VAR IF ELSE LB RB PRINT  WHILE
%left '-' '+' '>' '<'
%left '*' '/' '%'
%left NEG    /* negation--unary minus */
%right '^'     /* exponentiation */


%%

start: MAIN '('')' '{' statements '}'  {fprintf(yyout,"-----> Compiled Successfully!! <-----\n");}
        ;

statements: 
        |statements statement
        ;

statement:  declaration ';'       {}
        | expression ';'        {fprintf(yyout,"Value of expression: %d\n",$1); $$=$1;                        
                        }
        | VAR '=' expression ';'        {
                                        sym[$1] = $3; 
					fprintf(yyout,"Variable value: %d\t\n",$3);
					$$=$3;
                                        }
        | VAR '+''+'';'         {
                                fprintf(yyout,"\nValue before Increment : %d",sym[$1] );
                                fprintf(yyout,"\nValue after Increment : %d\n",sym[$1]+1 );
                                sym[$1]=sym[$1]+1;
                        }
        | NUM '+''+'';'         {
                                fprintf(yyout,"\nValue before Increment : %d",$1 );
                                fprintf(yyout,"\nValue after Increment : %d\n",$1+1 );
                                $$=$1+1;
                        }
        | NUM '+''=' NUM ';'         {
                                fprintf(yyout,"\nValue before Increment : %d",$1 );
                                fprintf(yyout,"\nValue after Increment : %d\n",$1+$4 );
                                $$=$1+$4;
                        }
        | VAR '+''=' NUM ';'         {
                                fprintf(yyout,"\nValue before Increment : %d",sym[$1] );
                                sym[$1]=sym[$1]+$4;
                                fprintf(yyout,"\nValue after Increment : %d\n",sym[$1] );
                        }
        | VAR '+''=' VAR ';'         {
                                fprintf(yyout,"\nValue before Increment : %d",sym[$1] );
                                sym[$1]=sym[$1]+sym[$4];
                                fprintf(yyout,"\nValue after Increment : %d\n",sym[$1] );
                        }
        | NUM '-''=' NUM ';'         {
                                fprintf(yyout,"\nValue before Decrement : %d",$1 );
                                fprintf(yyout,"\nValue after Decrement : %d\n",$1-$4 );
                                $$=$1-$4;
                        }
        | VAR '-''=' NUM ';'         {
                                fprintf(yyout,"\nValue before Decrement : %d",sym[$1] );
                                sym[$1]=sym[$1]-$4;
                                fprintf(yyout,"\nValue after Decrement : %d\n",sym[$1] );          
                        }
        | VAR '-''=' VAR ';'         {
                                fprintf(yyout,"\nValue before Decrement : %d",sym[$1] );
                                sym[$1]=sym[$1]-sym[$4];
                                fprintf(yyout,"\nValue after Decrement : %d\n",sym[$1] );          
                        }
        | NUM '*''=' NUM ';'         {
                                fprintf(yyout,"\nValue before Multiplication : %d",$1 );
                                fprintf(yyout,"\nValue after Multiplication : %d\n",$1*$4 );
                        }
        | VAR '*''=' NUM ';'         {
                                
                                fprintf(yyout,"\nValue before Multiplication : %d",sym[$1] );
                                sym[$1]=sym[$1]*$4;
                                fprintf(yyout,"\nValue after Multiplication : %d\n",sym[$1] );          
                        }
        | VAR '*''=' VAR ';'         {
                                
                                fprintf(yyout,"\nValue before Multiplication : %d",sym[$1] );
                                sym[$1]=sym[$1]*sym[$4];
                                fprintf(yyout,"\nValue after Multiplication : %d\n",sym[$1] );          
                        }
        | NUM '/''=' NUM ';'         {
                                        fprintf(yyout,"\nValue before Division : %d",$1 );
                                        if($4){
                                                                        
				     		
                                                fprintf(yyout,"\nValue after Division : %d\n",$1/$4 );
				     			$$ = $1 / $4;		
				  	}
				  	else{
						$$ = 0;
						fprintf(yyError,"\nRuntime Error: Division by zero\n\t");
                                                fprintf(yyout,"\nValue after Division : %d\n",$1 );
				  	} 	
                        }
        | VAR '/''=' NUM ';'         {
                                        fprintf(yyout,"\nValue before Division : %d",sym[$1] );
                                        if($4){
                                                sym[$1]=sym[$1]/$4;
                                                fprintf(yyout,"\nValue after Division : %d\n",sym[$1] );
				  	}
				  	else{
						$$ = 0;
						fprintf(yyError,"\nRuntime Error: Division by zero\n\t");
                                                fprintf(yyout,"\nValue after Division : %d\n",sym[$1] );
				  	} 	
                        }
        | VAR '/''=' VAR ';'         {
                                        fprintf(yyout,"\nValue before Division : %d",sym[$1] );
                                        if(sym[$4]){
                                                sym[$1]=sym[$1]/sym[$4];
                                                fprintf(yyout,"\nValue after Division : %d\n",sym[$1] );
				  	}
				  	else{
						$$ = 0;
						fprintf(yyError,"\nRuntime Error: Division by zero\n\t");
                                                fprintf(yyout,"\nValue after Division : %d\n",sym[$1] );
				  	} 	
                        }
        | NUM '-''-'';'         {
                                fprintf(yyout,"\nValue before Decrement : %d",$1 );
                                fprintf(yyout,"\nValue after Decrement : %d\n\n",$1-1 );
                                $$=$1-1;
                        }
        | WHILE '(' NUM '<' NUM ')' '{' statement '}' {
	                                                int i;
	                                                fprintf(yyout,"\nWHILE Loop Found\n");
	                                                for(i=$3 ; i<$5 ; i++) 
                                                        {
                                                                fprintf(yyout,"%dth Loop: %d\n", i,$8);
                                                        }
				        }
        | WHILE '(' VAR '<' VAR ')' '{' statement '}' {
	                                                int i;
	                                                fprintf(yyout,"\nWHILE Loop Found\n");
	                                                for(i=sym[$3] ; i<sym[$5] ; i++) 
                                                        {
                                                                fprintf(yyout,"%dth Loop: %d\n", i,$8);
                                                        }
				        }
        | IF '(' expression ')' '{' expression ';' '}' %prec IFX {
                                                                fprintf(yyout,"\nIF Condition Found\n");
								if($3){
									fprintf(yyout,"\nIF is TURE: %d\n",$6);
								}
								else{
									fprintf(yyout,"IF is FALSE\n");
								}
							}
        | IF '(' expression ')' '{' expression ';' '}' ELSE '{' expression ';' '}' {
                                                                                fprintf(yyout,"\nIF ELSE Condition Found\n");
                                                                                if($3){
									        fprintf(yyout,"IF is TURE: %d\n",$6);
								                }
								                else{
									        fprintf(yyout,"IF is FALSE: %d\n\n",$11);
								                }
                                                                        }

        | PRINT '(' expression ')' ';'          {fprintf(yyout,"Result: %d\n\n",$3);}                  
        ; 

declaration: TYPE ID1
        ;
TYPE: INT
        |FLOAT
        |CHAR
        ;
ID1: ID1 ',' VAR 
        |VAR 
        ;
expression: NUM				{ fprintf(yyout,"\nNumber :  %d\n",$1 ); $$ = $1;  }

	| VAR				{ $$ = sym[$1]; }
	

	| expression '*' expression	{
                                                fprintf(yyout,"\nMUL: %d*%d \n ",$1,$3,$1*$3);
                                                 $$ = $1 * $3;
                                        }
        | expression '+' expression	{
                                                fprintf(yyout,"\nPLUS: %d+%d = %d \n",$1,$3,$1+$3 );  
                                                $$ = $1 + $3;  
                                        }

	| expression '-' expression	{fprintf(yyout,"\nSUB: %d-%d=%d \n ",$1,$3,$1-$3); $$ = $1 - $3; }
	| expression '/' expression	{ if($3){
				     		fprintf(yyout,"\nDIV:%d/%d \n ",$1,$3,$1/$3);
				     		$$ = $1 / $3;
				     					
				  	}
				  	else{
						$$ = 0;
						fprintf(yyError,"\nRuntime Error: Division by zero\n\t");
				  	} 	
				}
	| expression '%' expression	{ if($3){
				     		fprintf(yyout,"\nMOD :%d % %d \n",$1,$3,$1 % $3);
				     		$$ = $1 % $3;
				     					
				  	}
				  	else{
						$$ = 0;
						fprintf(yyError,"\nRuntime Error: MOD by zero\n");
				  	} 	
				}
	| expression '^' expression	{fprintf(yyout,"\nPOW  :%d ^ %d \n",$1,$3,$1 ^ $3);  $$ = pow($1 , $3);}
	| expression '<' expression	{fprintf(yyout,"\nLT:%d < %d \n",$1,$3,$1 < $3); $$ = $1 < $3 ; }
	
	| expression '>' expression	{fprintf(yyout,"\nGT:%d > %d \n ",$1,$3,$1 > $3); $$ = $1 > $3; }
        | expression '=''=' expression  {
                                        fprintf(yyout,"\nEQUAL: %d == %d\n",$1,$4);
                                        $$ = $1 == $4;                                        
                                }
        | expression '!''=' expression  {
                                        
                                        fprintf(yyout,"\nNOTEQUAL: %d == %d\n",$1,$4);
                                        $$ = $1 != $4;                                        
                                }

	| '(' expression ')'		{$$ = $2; }
	

        ;           	

%%

void yyerror(char *s) {
    fprintf(yyError, "%s\n", s);
}

int main(void) {
    yyin = fopen("input.txt", "r");
    yyout = fopen("output.txt", "w");
    yyError = fopen("outError.txt", "w");

    yyparse();

    fclose(yyin);
    fclose(yyout);
    fclose(yyError);
    return 0;
}