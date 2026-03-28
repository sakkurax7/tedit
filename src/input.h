#ifndef INPUT_H
#define INPUT_H

char *editorPrompt(const char *prompt, void (*callback)(char *, int));
void editorMoveCursor(int key);
void editorProcessKeypress(void);

#endif
