#include "vga.h"

#if defined(__linux__)
#error "cross compiler did NOT work"
#endif

// ---- vga stuff ---- //

static inline __uint
get_color (__uint fg, __uint bg)
{
  return fg | bg << 4;
}

static inline __ulong
get_entry (__uc c, __uint clr)
{
  return (__ulong)c | (__ulong)clr << 8;
}

// ---- end of vga stuff ---- //

size_t
strlen (const char *str)
{
  size_t len = 0;
  while (str[len]) len++;

  return len;
}

// ---- tty stuff ----

struct tty {
  size_t row;
  size_t col;
  __uint clr;
  __ulong *buffer;
};

struct tty *t;

void
tty_init (void)
{
  t->buffer = (__ulong*)VGA_MEM;

  t->row = 0;
  t->col = 0;
  t->clr = get_color(VGA_WHITE, VGA_BLACK);

  for (size_t y = 0; y < VGA_COL; ++y) {
    for (size_t x = 0; x < VGA_ROW; ++x) {
      const size_t idx = y * VGA_ROW + x;
      t->buffer[idx] = get_entry(' ', t->clr);
    }
  }
}

void
tty_setclr (__uint clr)
{
  t->clr = clr;
}

void
tty_putentry (char c, __uint clr, size_t x, size_t y)
{
  const size_t idx = y * VGA_ROW + x;
  t->buffer[idx] = get_entry(c, clr);
}


void
tty_putc (char c)
{
  tty_putentry(c, t->clr, t->row, t->col);
  if (++t->row == VGA_ROW) {
    t->row = 0;

    if (++t->col == VGA_COL) {
      t->col = 0;
    }
  }
}

void
tty_putd (const char *data, size_t sz)
{
  for (size_t j = 0; j < sz; ++j) tty_putc(data[j]);
}

void
tty_puts (const char *str)
{
  tty_putd(str, strlen(str));
}

void
kernel_main (void)
{
  tty_init();

  tty_puts("Hello, rui.\n");
}
