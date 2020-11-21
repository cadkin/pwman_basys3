#include "pw.h"

// C
#include <string.h>
#include <stdlib.h>

// AVR
#include <avr/eeprom.h>

// Local
#include "term.h"

uint16_t EEMEM _pw_sto_start;

pw_struct* new_pw_struct(char* label, char* pw) {
    pw_struct* ptr = malloc(sizeof(pw_struct));

    ptr->label = label;
    ptr->pw    = pw;

    return ptr;
}

void free_pw_struct(pw_struct* ptr) {
    free(ptr->label);
    free(ptr->pw);
    free(ptr);
}

void add_pw(pw_struct*** pws, char* label, char* pw) {
    // Get size
    uint16_t pws_size;
    for (pws_size = 0; (*pws)[pws_size]->label != 0; pws_size++);

    // Get more memory and shuffle pointers.
    *pws = realloc(*pws, sizeof(pw_struct) * (pws_size + 1));

    (*pws)[pws_size + 1] = (*pws)[pws_size];
    (*pws)[pws_size] = new_pw_struct(label, pw);
}

void del_pw(pw_struct*** pws, uint16_t idx) {
    if ((*pws)[idx]->label == 0) return;
    (*pws)[idx]->label[0] = '\x18';
    (*pws)[idx]->pw[0]    = '\x18';
}

pw_struct** load_pws() {
    pw_struct** pws = 0;

    uint16_t pw_count = eeprom_read_word(&_pw_sto_start);
    uint64_t byte_count = 2;

    pws = malloc(sizeof(pw_struct) * (pw_count + 1));

    for (int i = 0; i < pw_count; i++) {
        // Get label.
        uint16_t lb_len = eeprom_read_word(&(_pw_sto_start) + byte_count);
        byte_count += 2;

        //term_printf("pw_count = %d, lb_len = %d, byte_count = %d\n", pw_count, lb_len, byte_count);

        char* lb = malloc(lb_len + 1);
        eeprom_read_block((void * )lb, &(_pw_sto_start) + byte_count, lb_len);
        lb[lb_len] = '\0';
        byte_count += lb_len;

        // Get pw.
        uint16_t pw_len = eeprom_read_word(&(_pw_sto_start) + byte_count);
        byte_count += 2;

        char* pw = malloc(pw_len + 1);
        eeprom_read_block((void * )pw, &(_pw_sto_start) + byte_count, pw_len);
        pw[pw_len] = '\0';
        byte_count += pw_len;

        pw_struct* pw_s = new_pw_struct(lb, pw);
        pws[i] = pw_s;
    }

    // Null termination.
    pws[pw_count] = malloc(sizeof(pw_struct));
    pws[pw_count]->label = 0;
    pws[pw_count]->pw = 0;

    return pws;
}

void write_pws(pw_struct** pws) {
    uint16_t byte_count = 2;
    uint16_t pw_count = 0;

    for(int i = 0; pws[i]->label != 0; i++) {
        // Bad/removed pair.
        if(pws[i]->label[0] == '\x18') continue;

        uint16_t lb_len = strlen(pws[i]->label);
        uint16_t pw_len = strlen(pws[i]->pw);

        // Write label.
        eeprom_write_word(&(_pw_sto_start) + byte_count, lb_len);
        byte_count += 2;
        eeprom_write_block((void *)pws[i]->label, &(_pw_sto_start) + byte_count, lb_len);
        byte_count += lb_len;

        // Write pw.
        eeprom_write_word(&(_pw_sto_start) + byte_count, pw_len);
        byte_count += 2;
        eeprom_write_block((void *)pws[i]->pw, &(_pw_sto_start) + byte_count, pw_len);
        byte_count += pw_len;

        pw_count++;

        //term_printf("pw_count = %d, byte_count = %d, lb_len = %d, pw_len = %d\n", pw_count, byte_count, lb_len, pw_len);
    }

    eeprom_write_word(&_pw_sto_start, pw_count);
}

void print_pws(pw_struct** pws) {
    term_printf("=========================================================\n");
    term_printf("| %-25s | %-25s |\n", "Name", "Password");
    term_printf("=========================================================\n");
    for (int i = 0; pws[i]->label != 0; i++) {
        // Bad/removed password.
        if(pws[i]->label[0] == '\x18') continue;

        term_printf("| %-25.25s | %-25.25s |\n", pws[i]->label, pws[i]->pw);
    }
    term_printf("=========================================================\n");
}
