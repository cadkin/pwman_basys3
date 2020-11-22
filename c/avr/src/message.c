#include "message.h"

// Local
#include "term.h"

void print_clear() {
    term_printf("%s", DC1);
    for(int i = 0; i < 75; i++) {
        term_printf("                                                         \n");
    }
}

void print_intro() {
    term_printf("%sWelcome to the P3_PWMAN Password Manager!\n\n", DC1);
    term_printf("(Version 0.1a)\n");
    term_printf("(BUILD 20201121)\n\n");
    term_printf("For more info on the project visit:\n");
    term_printf("http://github.com/cadkin/pwman_basys3:\n\n\n");
    term_printf("Press enter to get started!\n", DC1);
}

void print_menu() {
    term_printf("=========================================================\n");
    term_printf("| %-10s | %-40s |\n", "Selection", "Operation");
    term_printf("=========================================================\n");
    term_printf("| %-10s | %-40s |\n", "1", "Retrieve Passwords");
    term_printf("| %-10s | %-40s |\n", "2", "Enter a New Password");
    term_printf("| %-10s | %-40s |\n", "3", "Generate a New Password");
    term_printf("| %-10s | %-40s |\n", "4", "Manage Passwords");
    term_printf("=========================================================\n\n");
}
