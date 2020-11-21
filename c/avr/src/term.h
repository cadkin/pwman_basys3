// C
#include <stdint.h>
#include <stdarg.h>

// Return to top.
#define DC1 "\x11"
// Clear screen.
#define DC2 "\x12"

void term_init(volatile uint8_t* stdout_port, volatile uint8_t* stdin_port);
void term_print(char* str);
void term_printf(const char* fmt, ...);
int term_scanf(const char* fmt, ...);
