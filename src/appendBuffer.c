#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "tedit.h"

void abAppend(struct abuf *ab, const char *s, int len)
{
	char *new = realloc(ab->b, ab->len + len);

	if (new == NULL) return;

	memcpy(&new[ab->len], s, len);

	ab->b = new;
	ab->len += len;
}

void abFree(struct abuf *ab) { free(ab->b); }