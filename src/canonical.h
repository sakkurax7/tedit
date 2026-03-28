#ifndef CANONICAL_H
#define CANONICAL_H

#include "tedit.h"

void disableRawMode(void);
void enableRawMode(struct editorConfig *editor);
int editorReadKey(void);
int getCursorPosition(int *rows, int *cols);
int getWindowSize(int *rows, int *cols);

#endif
