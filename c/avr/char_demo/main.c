// C
#include <stdbool.h>
#include <stdint.h>

// AVR
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/delay.h>

int main() {
    char* str = "\rHello world, this is being print out over a serial communication between an AVR ATMEGA2560 and a Xillix XC7A35T!";
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
       char* str_pos;

    // Set DDR for Port C to output.
    DDRC = 0xFF;

    for (str_pos = str; *str_pos != '\0'; str_pos++) {
        PORTC = (*str_pos) & 0x7F;

        // Clock for 1 ms.
        PORTC ^= 0x80;
        _delay_us(500);
        PORTC ^=0x80;
        _delay_us(500);
    }

    for(;;) {}
}
