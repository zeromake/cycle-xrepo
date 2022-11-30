#include "ft.h"
#include <stdio.h>

#ifdef FT_CONFIG_OPTION_USE_HARFBUZZ
#include <hb.h>
#endif

void ft_font_create() {
    printf("ft_font_create call\n");
#ifdef FT_CONFIG_OPTION_USE_HARFBUZZ
    hb_ft_font_create();
#endif
}
