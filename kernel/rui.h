#include "typedefs.h"

#include <stddef.h>
#include <stdint.h>

#define VGA_BLACK 0
#define VGA_WHITE 15

#define VGA_COL 25
#define VGA_ROW 80
#define VGA_MEM 0xB8000

// vga stuff
static inline __uint get_color(__uint fg, __uint bg);
static inline __ulong  get_entry(__uc c, __uint clr);

// tty stuff
void tty_init(void);
void tty_setclr(__uint clr);
void tty_putentry(char c, __uint clr, size_t x, size_t y);
void tty_putc(char c);
void tty_putd(const char *data, size_t sz);
void tty_puts(const char *str);

// KERNEL !!!
void kernel_main(void);

size_t strlen(const char *str);
