#ifndef CANONICAL_C_
#define CANONICAL_C_

void disableRawMode();
void enableRawMode(struct editorConfig* E);
int editorReadKey();
int getCursorPosition(int *rows, int *cols);
int getWindowSize(int *rows, int *cols);

#endif
