// C
#include <stdbool.h>
#include <stdint.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

// AVR
#include <avr/io.h>
#include <util/delay.h>

// Local
#include "term.h"

int main() {
    term_init(&PORTC, &PORTA);
    term_printf("%sB3_PWMAN - V0.1a\nBUILD 20201120\n", DC2);

    _delay_ms(5000);

    //char* str = "\nHello world, this is being print out over a serial communication between an AVR ATMEGA2560 and a Xillix XC7A35T!";
    //char* str = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";

    // Ascii Art, why not?
    //char* str = "\n\
    //                                                                    ..;===+.\n\
    //                                                                .:=iiiiii=+=\n\
    //                                                             .=i))=;::+)i=+,\n\
    //                                                          ,=i);)I)))I):=i=;\n\
    //                                                       .=i==))))ii)))I:i++\n\
    //                                                     +)+))iiiiiiii))I=i+:'\n\
    //                                .,:;;++++++;:,.       )iii+:::;iii))+i='\n\
    //                             .:;++=iiiiiiiiii=++;.    =::,,,:::=i));=+'\n\
    //                           ,;+==ii)))))))))))ii==+;,      ,,,:=i))+=:\n\
    //                         ,;+=ii))))))IIIIII))))ii===;.    ,,:=i)=i+\n\
    //                        ;+=ii)))IIIIITIIIIII))))iiii=+,   ,:=));=,\n\
    //                      ,+=i))IIIIIITTTTTITIIIIII)))I)i=+,,:+i)=i+\n\
    //                     ,+i))IIIIIITTTTTTTTTTTTI))IIII))i=::i))i='\n\
    //                    ,=i))IIIIITLLTTTTTTTTTTIITTTTIII)+;+i)+i`\n\
    //                    =i))IIITTLTLTTTTTTTTTIITTLLTTTII+:i)ii:'\n\
    //                   +i))IITTTLLLTTTTTTTTTTTTLLLTTTT+:i)))=,\n\
    //                   =))ITTTTTTTTTTTLTTTTTTLLLLLLTi:=)IIiii;\n\
    //                  .i)IIITTTTTTTTLTTTITLLLLLLLT);=)I)))))i;\n\
    //                  :))IIITTTTTLTTTTTTLLHLLLLL);=)II)IIIIi=:\n\
    //                  :i)IIITTTTTTTTTLLLHLLHLL)+=)II)ITTTI)i=\n\
    //                  .i)IIITTTTITTLLLHHLLLL);=)II)ITTTTII)i+\n\
    //                  =i)IIIIIITTLLLLLLHLL=:i)II)TTTTTTIII)i'\n\
    //                +i)i)))IITTLLLLLLLLT=:i)II)TTTTLTTIII)i;\n\
    //              +ii)i:)IITTLLTLLLLT=;+i)I)ITTTTLTTTII))i;\n\
    //             =;)i=:,=)ITTTTLTTI=:i))I)TTTLLLTTTTTII)i;\n\
    //           +i)ii::,  +)IIITI+:+i)I))TTTTLLTTTTTII))=,\n\
    //         :=;)i=:,,    ,i++::i))I)ITTTTTTTTTTIIII)=+'\n\
    //       .+ii)i=::,,   ,,::=i)))iIITTTTTTTTIIIII)=+\n\
    //      ,==)ii=;:,,,,:::=ii)i)iIIIITIIITIIII))i+:'\n\
    //     +=:))i==;:::;=iii)+)=  `:i)))IIIII)ii+'\n\
    //   .+=:))iiiiiiii)))+ii;\n\
    //  .+=;))iiiiii)));ii+\n\
    // .+=i:)))))))=+ii+\n\
    //.;==i+::::=)i=;\n\
    //,+==iiiiii+,\n\
    //`+=+++;`\n\
    //";

    char buf[200];

    term_printf("Enter thing:");
    term_scanf("%s", buf);

    term_printf("\nGot: %s", buf);

    for(;;) {}
}
