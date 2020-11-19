// C
#include <stdbool.h>
#include <stdint.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

// AVR
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

// Return to top.
#define DC1 "\x11"
// Clear screen.
#define DC2 "\x12"

volatile uint8_t* term_port = 0;
volatile uint8_t* term_ddr  = 0;

void term_init(volatile uint8_t* port) {
    term_port = port;
    term_ddr = port - 1;

    // Set DDR to out.
    *term_ddr = 0xFF;
}

void term_print(char* str) {
    for (char* str_pos = str; *str_pos != '\0'; str_pos++) {
        *term_port = (*str_pos) & 0x7F;

        // Clock for 1 ms.
        *term_port ^= 0x80;
        _delay_us(500);
        *term_port ^=0x80;
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

int main() {
    //char* str = "\nHello world, this is being print out over a serial communication between an AVR ATMEGA2560 and a Xillix XC7A35T!";
    //char* str = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";

    // Ascii Art, why not?
    char* str = "\n\
                                                                        ..;===+.\n\
                                                                    .:=iiiiii=+=\n\
                                                                 .=i))=;::+)i=+,\n\
                                                              ,=i);)I)))I):=i=;\n\
                                                           .=i==))))ii)))I:i++\n\
                                                         +)+))iiiiiiii))I=i+:'\n\
                                    .,:;;++++++;:,.       )iii+:::;iii))+i='\n\
                                 .:;++=iiiiiiiiii=++;.    =::,,,:::=i));=+'\n\
                               ,;+==ii)))))))))))ii==+;,      ,,,:=i))+=:\n\
                             ,;+=ii))))))IIIIII))))ii===;.    ,,:=i)=i+\n\
                            ;+=ii)))IIIIITIIIIII))))iiii=+,   ,:=));=,\n\
                          ,+=i))IIIIIITTTTTITIIIIII)))I)i=+,,:+i)=i+\n\
                         ,+i))IIIIIITTTTTTTTTTTTI))IIII))i=::i))i='\n\
                        ,=i))IIIIITLLTTTTTTTTTTIITTTTIII)+;+i)+i`\n\
                        =i))IIITTLTLTTTTTTTTTIITTLLTTTII+:i)ii:'\n\
                       +i))IITTTLLLTTTTTTTTTTTTLLLTTTT+:i)))=,\n\
                       =))ITTTTTTTTTTTLTTTTTTLLLLLLTi:=)IIiii;\n\
                      .i)IIITTTTTTTTLTTTITLLLLLLLT);=)I)))))i;\n\
                      :))IIITTTTTLTTTTTTLLHLLLLL);=)II)IIIIi=:\n\
                      :i)IIITTTTTTTTTLLLHLLHLL)+=)II)ITTTI)i=\n\
                      .i)IIITTTTITTLLLHHLLLL);=)II)ITTTTII)i+\n\
                      =i)IIIIIITTLLLLLLHLL=:i)II)TTTTTTIII)i'\n\
                    +i)i)))IITTLLLLLLLLT=:i)II)TTTTLTTIII)i;\n\
                  +ii)i:)IITTLLTLLLLT=;+i)I)ITTTTLTTTII))i;\n\
                 =;)i=:,=)ITTTTLTTI=:i))I)TTTLLLTTTTTII)i;\n\
               +i)ii::,  +)IIITI+:+i)I))TTTTLLTTTTTII))=,\n\
             :=;)i=:,,    ,i++::i))I)ITTTTTTTTTTIIII)=+'\n\
           .+ii)i=::,,   ,,::=i)))iIITTTTTTTTIIIII)=+\n\
          ,==)ii=;:,,,,:::=ii)i)iIIIITIIITIIII))i+:'\n\
         +=:))i==;:::;=iii)+)=  `:i)))IIIII)ii+'\n\
       .+=:))iiiiiiii)))+ii;\n\
      .+=;))iiiiii)));ii+\n\
     .+=i:)))))))=+ii+\n\
    .;==i+::::=)i=;\n\
    ,+==iiiiii+,\n\
    `+=+++;`\n\
    ";

    srand(4);

    term_init(&PORTC);

    term_print(DC2);

    //for (int i = 0; i < 7500; i++) {
    //    term_printf("%c", (rand() % 2) ? '/' : '\\');
    //}

    for(;;) {
        term_printf("%s\n", str);
        _delay_ms(2000);

        term_printf("%s", DC2);
    }
}

