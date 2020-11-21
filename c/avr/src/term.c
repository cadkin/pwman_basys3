#include "term.h"

// C
#include <stdio.h>
#include <stdlib.h>

// AVR
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

volatile uint8_t* _term_stdout_port = 0;
volatile uint8_t* _term_stdout_ddr  = 0;
volatile uint8_t* _term_stdout_pin  = 0;
volatile uint8_t* _term_stdin_port  = 0;
volatile uint8_t* _term_stdin_ddr   = 0;
volatile uint8_t* _term_stdin_pin   = 0;

char* _term_buf = 0;
uint64_t _term_buf_free = 0;

void term_init(volatile uint8_t* stdout_port, volatile uint8_t* stdin_port) {
    _term_stdout_port = stdout_port;
    _term_stdout_ddr = stdout_port - 1;
    _term_stdout_pin = stdout_port - 2;

    _term_stdin_port = stdin_port;
    _term_stdin_ddr = stdin_port - 1;
    _term_stdin_pin = stdin_port - 2;

    *_term_stdout_ddr = 0xFF;

    *_term_stdin_ddr = 0x00;
    *_term_stdin_port = 0x7F;

    // Currently assumes that PCINT0 is the interrupt pin.
    DDRB = 0x00;
    // Pullup.
    PORTB = 0x01;

    // Enable interrupt.
    PCMSK0 |= (1 << PCINT0);
    PCICR |= (1 << PCIE0);
    sei();
}

void term_print(char* str) {
    for (char* str_pos = str; *str_pos != '\0'; str_pos++) {
        *_term_stdout_port = (*str_pos) & 0x7F;

        // Clock for 1 ms.
        *_term_stdout_port ^= 0x80;
        _delay_us(500);
        *_term_stdout_port ^= 0x80;
        _delay_us(500);
    }
}

void term_printf(const char* fmt, ...) {
    va_list va;
    va_start(va, fmt);

    // Getting buffer.
    size_t bn = vsnprintf(0, 0, fmt, va);
    char* buf = malloc(bn);

    vsprintf(buf, fmt, va);
    term_print(buf);

    free(buf);
    va_end(va);
}

// PS2 keypress interrupt.
ISR(PCINT0_vect) {
    // Rising edge.
    if (PINB & (1 << PINB0)) {
        char c = *_term_stdin_pin & 0x7F;

        term_printf("%c", c);

        if (c == '\b') {
            term_printf(" \b");
        }
    }
}
