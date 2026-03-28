#ifndef APPEND_BUFFER_H
#define APPEND_BUFFER_H

#include <stddef.h>

#include "tedit.h"

void abAppend(struct abuf *ab, const char *text, size_t len);
void abFree(struct abuf *ab);

#endif
