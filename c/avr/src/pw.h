#include <stdint.h>

struct pw_struct {
    char* label;
    char* pw;
};
typedef struct pw_struct pw_struct;

pw_struct* new_pw_struct(char* label, char* pw);
void free_pw_struct(pw_struct* ptr);

pw_struct** load_pws();
void write_pws(pw_struct** pws);
void add_pw(pw_struct*** pws, char* label, char* pw);
void del_pw(pw_struct*** pws, uint16_t idx);
int print_pws(pw_struct** pws);

