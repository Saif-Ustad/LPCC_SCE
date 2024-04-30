%{
#include <stdio.h>

int sl=0;
int ml=0;

int yywrap(void); // Custom prototype for yywrap
%}

%%
"/*"([^*]|"*"+[^*/])*"*"+"/"    { ml++; /* Remove multiline comments */ }
"//"(.*)                        {  sl++; /* Remove single line comments */ }
.                               { fprintf(yyout, "%s", yytext); } // Write non-comment characters to output
%%

int main(int argc, char *argv[]) {
    FILE *input_file = fopen(argv[1], "r");
    FILE *output_file = fopen(argv[2], "w");

    if (!input_file) {
        printf("Error opening input file.\n");
        return 1;
    }

    if (!output_file) {
        printf("Error opening output file.\n");
        fclose(input_file);
        return 1;
    }

    yyin = input_file;
    yyout = output_file;

    yylex();

    fclose(input_file);
    fclose(output_file);

    printf("\nNumber of single line comments are = %d\n", sl);
    printf("Number of multiline comments are = %d\n", ml);

    return 0;
}

// Custom implementation of yywrap to indicate end of input
int yywrap(void) {
    return 1;
}
