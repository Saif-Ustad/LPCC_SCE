#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE_LENGTH 100
#define MAX_NAME_LENGTH 20
#define MAX_PARAMS 10
#define MAX_MNT_ENTRIES 20

// Structure to store macro definition
typedef struct {
    char name[MAX_NAME_LENGTH];
    char params[MAX_PARAMS][MAX_NAME_LENGTH];
    int param_count;
    int index; // Index where macro definition starts
} MacroDefinition;

// Structure to store MNT entry
typedef struct {
    char name[MAX_NAME_LENGTH];
    int param_count;
    int index; // Index where macro call occurs
} MNTEntry;

int main() {
    FILE *fp;
    char line[MAX_LINE_LENGTH];
    MacroDefinition macro_defs[MAX_MNT_ENTRIES];
    MNTEntry mnt[MAX_MNT_ENTRIES];
    int mnt_index = 0;
    int mdt_index = 0;
    int line_number = 0;

    // Open the input file
    fp = fopen("input.txt", "r");
    if (fp == NULL) {
        printf("Error opening file.\n");
        return 1;
    }

    // Process input file line by line
    while (fgets(line, MAX_LINE_LENGTH, fp) != NULL) {
        line_number++;

        // Remove trailing newline character
        if (line[strlen(line) - 1] == '\n') {
            line[strlen(line) - 1] = '\0';
        }

        // Check for macro definition
        if (strstr(line, "MACRO") != NULL) {
            // Extract macro name and parameters
            char *token = strtok(line, " ");
            token = strtok(NULL, " ");
            strcpy(macro_defs[mnt_index].name, token);

            token = strtok(NULL, " ");
            if (token != NULL && strcmp(token, "MACRO") != 0) {
                // Macro has parameters
                macro_defs[mnt_index].param_count = 0;
                while (token != NULL && strcmp(token, "MEND") != 0) {
                    strcpy(macro_defs[mnt_index].params[macro_defs[mnt_index].param_count++], token);
                    token = strtok(NULL, " ");
                }
            } else {
                // Macro has no parameters
                macro_defs[mnt_index].param_count = 0;
            }

            macro_defs[mnt_index].index = mdt_index;
            mnt[mnt_index].index = line_number;

            mnt_index++;
        }

        // Check for MEND
        if (strstr(line, "MEND") != NULL) {
            mdt_index++;
        }

        mdt_index++;
    }

    // Print MNT
    printf("Macro Name Table (MNT):\n");
    for (int i = 0; i < mnt_index; i++) {
        printf("%d. %s", i + 1, macro_defs[i].name);
        if (macro_defs[i].param_count > 0) {
            printf("(");
            for (int j = 0; j < macro_defs[i].param_count; j++) {
                printf("%s", macro_defs[i].params[j]);
                if (j < macro_defs[i].param_count - 1) {
                    printf(", ");
                }
            }
            printf(")");
        }
        printf("\n");
    }

    // Close the file
    fclose(fp);

    return 0;
}