// C
#include <stdbool.h>
#include <stdint.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// AVR
#include <avr/io.h>
#include <util/delay.h>

// Local
#include "term.h"
#include "pw.h"
#include "message.h"

int main() {
    term_init(&PORTC, &PORTA);
    char buf[200];
    char* ascii = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
    srand(PINB);

    print_intro();
    term_scanf("");

    pw_struct** pws = load_pws();

    start:

    print_menu();

    int selection = 0;

    term_printf("Selection? : ");
    term_scanf("%d", &selection);

    term_printf("Selection: %d\n", selection);

    switch(selection) {
        case 1: {
            print_clear();
            print_pws(pws);
            goto end;
        }
        case 2: {
            term_printf("Enter a new name for the password: ");
            term_scanf("%[^\n]", buf);

            int lb_len = strlen(buf);
            char* lb = malloc(lb_len + 1);
            strcpy(lb, buf);

            term_printf("Enter the password: ");
            term_scanf("%[^\n]", buf);

            int pw_len = strlen(buf);
            char* pw = malloc(pw_len + 1);
            strcpy(pw, buf);

            add_pw(&pws, lb, pw);
            write_pws(pws);

            goto end;
        }
        case 3: {
            term_printf("Enter a new name for the password: ");
            term_scanf("%[^\n]", buf);

            int lb_len = strlen(buf);
            char* lb = malloc(lb_len + 1);
            strcpy(lb, buf);

            int pw_len;
            char* pw;

            for (;;) {
                pw_len = (rand() % 19) + 5;
                pw = malloc(pw_len + 1);
                for (int i = 0; i <= pw_len; i++) {
                    pw[i] = ascii[rand() % 96];
                }

                pw[pw_len + 1] = '\0';

                term_printf("\n\nThe generated password is: %s\n", pw);
                term_printf("Is this OK [y/n]: ");

                char response = 'n';
                term_scanf("%c", &response);

                if (response == 'y' || response == 'Y') {
                    break;
                }

                free(pw);
            }

            add_pw(&pws, lb, pw);
            write_pws(pws);

            goto end;
        }
        case 4: {
            print_clear();
            int count = print_pws(pws);
            int sel = 0;

            term_printf("\n\nDelete which index? : ");
            term_scanf("%d", &sel);

            if (sel < count) {
                del_pw(&pws, sel);
                term_printf("Sucessfully deleted password #%d\n", sel);
            }
            else {
                term_printf("Unknown input.\n");
            }

            goto end;
        }
    }

    end:
        term_printf("\n\nOperation completed, press enter to return to menu...");
        term_scanf("");
        print_clear();
    goto start;

    //write_pws(pws);

    //_delay_ms(5000);

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

    //char buf[200];

    //term_printf("Enter thing:");
    //term_scanf("%s", buf);

    //term_printf("\nGot: %s", buf);
}
