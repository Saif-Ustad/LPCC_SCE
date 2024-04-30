%{
#include <stdio.h>
#include <ctype.h>
%}

%option noyywrap

%%
[a-z] { printf("%c", toupper(yytext[0])); }
.     { printf("%s", yytext); }

%%

int main() {
    yylex();
    return 0;
}
