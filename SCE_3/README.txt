#commands to run

STEP1 : flex lexer.l
STEP2 : gcc lex.yy.c
STEP3 : ./a < input.txt > output.txt