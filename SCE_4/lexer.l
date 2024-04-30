%{
#include <stdio.h>
#include <string.h>

#define MAX_WORD_LENGTH 100

int total_words_a = 0;
int matched_words = 0;
FILE *file_b;

int word_exists_in_document_b(char *word);
%}

%option noyywrap

%%
[a-zA-Z]+ {
    char word[MAX_WORD_LENGTH];
    strncpy(word, yytext, MAX_WORD_LENGTH);
    word[MAX_WORD_LENGTH - 1] = '\0'; // Ensure null-termination
    if (strcmp(word, "is") && strcmp(word, "am") && strcmp(word, "a") && strcmp(word, "the") && strcmp(word, "if")) {
        total_words_a++;
        // Search for the word in document B
        if (word_exists_in_document_b(word)) {
            matched_words++;
        }
    }
}

\n { /* ignore newlines */ }
. { /* ignore other characters */ }

%%

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <file_a> <file_b>\n", argv[0]);
        return 1;
    }

    FILE *file_a = fopen(argv[1], "r");
    file_b = fopen(argv[2], "r");

    if (file_a == NULL || file_b == NULL) {
        perror("Error opening files");
        return 1;
    }

    yyin = file_a;
    yylex();

    float similarity_percentage = (matched_words / (float)total_words_a) * 100;
    printf("Similarity percentage: %.2f%%\n", similarity_percentage);

    fclose(file_a);
    fclose(file_b);

    return 0;
}

int word_exists_in_document_b(char *word) {
    char buffer[MAX_WORD_LENGTH];
    fseek(file_b, 0, SEEK_SET);
    while (fgets(buffer, sizeof(buffer), file_b) != NULL) {
        char *token = strtok(buffer, " ");
        while (token != NULL) {
            if (strcmp(token, word) == 0) {
                return 1;
            }
            token = strtok(NULL, " ");
        }
    }
    return 0;
}
