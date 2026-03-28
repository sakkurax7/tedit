#ifndef ROW_OPS_H
#define ROW_OPS_H

#include <stddef.h>
#include <stdbool.h>

#include "tedit.h"

int editorRowCxToRx(const erow *row, int cx);
int editorRowRxToCx(const erow *row, int rx);
void editorUpdateRow(erow *row);
void editorInsertRow(int at, const char *text, size_t len);
void editorFreeRow(erow *row);
void editorDelRow(int at);
void editorRowInsertChar(erow *row, int at, int c);
void editorRowAppendString(erow *row, const char *text, size_t len);
void editorRowDelChar(erow *row, int at);
size_t editorIndentColumns(const erow *row, int limit_cx);
int editorLineNumberWidth(void);
int editorTextCols(void);
int editorRowScreenRows(const erow *row);
int editorDocumentScreenRowForCursor(int file_row, int rx);
bool editorScreenRowToFileRow(int screen_row, int *file_row, int *wrap_row);

#endif
