#include "util/string.h"
#include "bootservices/bootservices.h"
#include "util/printf.h"
#include "memory/memory.h"

void _start(void) {
    /*
    void (*writer)(const char*, uint64_t) = get_terminal_writer();
    char string[] = "Hello World!\n";
    writer(string, strlen(string));
    */
    printf("Hola mundo\n");
    init_memory();

    int* buffer = (int*) request_page();

    for(int i = 0; i < 100; i++){
        buffer[i] = i;
    }

    for(int i = 0; i < 100; i++){
        printf("buffer[%d] = %d\n", i, buffer[i]);
    }

    while(1);
}