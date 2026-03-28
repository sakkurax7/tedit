#ifndef FILE_IO_H
#define FILE_IO_H

#include <stddef.h>

char *editorRowsToString(size_t *buflen);
void editorOpen(const char *filename);
void editorOpenFromEdit(void);
void editorSave(void);

#endif
