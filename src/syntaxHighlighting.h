#ifndef SYNTAX_HIGHLIGHTING_C_
#define SYNTAX_HIGHLIGHTING_C_



int is_seperator(int c);
void editorUpdateSyntax(erow *row);
int editorSyntaxToColor(int hl);


#endif