#ifndef SYNTAX_HIGHLIGHTING_C_
#define SYNTAX_HIGHLIGHTING_C_

extern char *C_HL_extensions[];
extern char *C_HL_keywords[];

extern struct editorSyntax HLDB[];

int is_seperator(int c);
void editorUpdateSyntax(erow *row);
int editorSyntaxToColor(int hl);
void editorSelectSyntaxHighlight();

#endif