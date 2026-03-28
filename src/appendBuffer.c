#include <stdlib.h>
#include <string.h>

#include "appendBuffer.h"

void abAppend(struct abuf *ab, const char *text, size_t len)
{
	char *new_buffer = realloc(ab->b, ab->len + len);

	if (new_buffer == NULL) {
		return;
	}

	memcpy(&new_buffer[ab->len], text, len);
	ab->b = new_buffer;
	ab->len += len;
}

void abFree(struct abuf *ab)
{
	free(ab->b);
	ab->b = NULL;
	ab->len = 0;
}
