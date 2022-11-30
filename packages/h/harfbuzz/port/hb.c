#include "hb.h"
#include <stdio.h>

#ifdef HAVE_FREETYPE
#include <ft.h>
#endif

void hb_font_create() {
    printf("hb_font_create call\n");
}

#ifdef HAVE_FREETYPE
void hb_ft_font_create() {
    printf("hb_ft_font_create call\n");
}
#endif
