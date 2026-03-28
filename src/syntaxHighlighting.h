#ifndef SYNTAX_HIGHLIGHTING_H
#define SYNTAX_HIGHLIGHTING_H

#include "tedit.h"

extern const char *const C_HL_extensions[];
extern const char *const C_HL_keywords[];
extern const struct editorSyntax HLDB[];

int is_separator(int c);
void editorUpdateSyntax(erow *row);
int editorSyntaxToColor(int hl);
void editorSelectSyntaxHighlight(void);

#endif
