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
    //char* str = "\rHello world, this is being print out over a serial communication between an AVR ATMEGA2560 and a Xillix XC7A35T!";
    //char* str = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";

    // Ascii Art, why not?
    //char* str = "\r\
    //                                                                    ..;===+.\r\
    //                                                                .:=iiiiii=+=\r\
    //                                                             .=i))=;::+)i=+,\r\
    //                                                          ,=i);)I)))I):=i=;\r\
    //                                                       .=i==))))ii)))I:i++\r\
    //                                                     +)+))iiiiiiii))I=i+:'\r\
    //                                .,:;;++++++;:,.       )iii+:::;iii))+i='\r\
    //                             .:;++=iiiiiiiiii=++;.    =::,,,:::=i));=+'\r\
    //                           ,;+==ii)))))))))))ii==+;,      ,,,:=i))+=:\r\
    //                         ,;+=ii))))))IIIIII))))ii===;.    ,,:=i)=i+\r\
    //                        ;+=ii)))IIIIITIIIIII))))iiii=+,   ,:=));=,\r\
    //                      ,+=i))IIIIIITTTTTITIIIIII)))I)i=+,,:+i)=i+\r\
    //                     ,+i))IIIIIITTTTTTTTTTTTI))IIII))i=::i))i='\r\
    //                    ,=i))IIIIITLLTTTTTTTTTTIITTTTIII)+;+i)+i`\r\
    //                    =i))IIITTLTLTTTTTTTTTIITTLLTTTII+:i)ii:'\r\
    //                   +i))IITTTLLLTTTTTTTTTTTTLLLTTTT+:i)))=,\r\
    //                   =))ITTTTTTTTTTTLTTTTTTLLLLLLTi:=)IIiii;\r\
    //                  .i)IIITTTTTTTTLTTTITLLLLLLLT);=)I)))))i;\r\
    //                  :))IIITTTTTLTTTTTTLLHLLLLL);=)II)IIIIi=:\r\
    //                  :i)IIITTTTTTTTTLLLHLLHLL)+=)II)ITTTI)i=\r\
    //                  .i)IIITTTTITTLLLHHLLLL);=)II)ITTTTII)i+\r\
    //                  =i)IIIIIITTLLLLLLHLL=:i)II)TTTTTTIII)i'\r\
    //                +i)i)))IITTLLLLLLLLT=:i)II)TTTTLTTIII)i;\r\
    //              +ii)i:)IITTLLTLLLLT=;+i)I)ITTTTLTTTII))i;\r\
    //             =;)i=:,=)ITTTTLTTI=:i))I)TTTLLLTTTTTII)i;\r\
    //           +i)ii::,  +)IIITI+:+i)I))TTTTLLTTTTTII))=,\r\
    //         :=;)i=:,,    ,i++::i))I)ITTTTTTTTTTIIII)=+'\r\
    //       .+ii)i=::,,   ,,::=i)))iIITTTTTTTTIIIII)=+\r\
    //      ,==)ii=;:,,,,:::=ii)i)iIIIITIIITIIII))i+:'\r\
    //     +=:))i==;:::;=iii)+)=  `:i)))IIIII)ii+'\r\
    //   .+=:))iiiiiiii)))+ii;\r\
    //  .+=;))iiiiii)));ii+\r\
    // .+=i:)))))))=+ii+\r\
    //.;==i+::::=)i=;\r\
    //,+==iiiiii+,\r\
    //`+=+++;`\r\
    //";

    term_init(&PORTC);
    //term_print(str);

    term_printf("\r%s, hello, %d\r", "foobar", 128);

    for(;;) {}
}

