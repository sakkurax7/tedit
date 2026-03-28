#include <ctype.h>

#include "editorOps.h"
#include "rowOps.h"
#include "tedit.h"

static void editorInsertSoftIndent(void)
{
	const int current_column = E.cy < E.numrows ? editorRowCxToRx(&E.row[E.cy], E.cx) : 0;
	const int spaces = E.settings.tab_stop - (current_column % E.settings.tab_stop);

	for (int count = 0; count < spaces; count++) {
		editorInsertChar(' ');
	}
}

void editorInsertChar(int c)
{
	if (c == '\t' && E.settings.soft_indent) {
		editorInsertSoftIndent();
		return;
	}

	if (E.cy == E.numrows) {
		editorInsertRow(E.numrows, "", 0);
	}

	editorRowInsertChar(&E.row[E.cy], E.cx, c);
	E.cx++;
	E.preferred_rx = -1;
}

void editorInsertNewline(void)
{
	size_t indent_columns = 0;
	bool grow_indent = false;

	if (E.settings.auto_indent && E.cy < E.numrows) {
		const erow *row = &E.row[E.cy];
		indent_columns = editorIndentColumns(row, E.cx);

		for (int index = E.cx - 1; index >= 0; index--) {
			if (isspace((unsigned char)row->chars[index])) {
				continue;
			}
			grow_indent = row->chars[index] == '{';
			break;
		}
	}

	if (E.cx == 0) {
		editorInsertRow(E.cy, "", 0);
	} else {
		erow *row = &E.row[E.cy];
		editorInsertRow(E.cy + 1, &row->chars[E.cx], (size_t)(row->size - E.cx));
		row = &E.row[E.cy];
		row->size = E.cx;
		row->chars[row->size] = '\0';
		editorUpdateRow(row);
	}

	E.cy++;
	E.cx = 0;
	E.preferred_rx = -1;

	if (!E.settings.auto_indent || E.cy >= E.numrows) {
		return;
	}

	if (grow_indent) {
		indent_columns += (size_t)E.settings.tab_stop;
	}

	for (size_t column = 0; column < indent_columns; column++) {
		editorRowInsertChar(&E.row[E.cy], E.cx++, ' ');
	}
}

void editorDelChar(void)
{
	if (E.cy == E.numrows || (E.cx == 0 && E.cy == 0)) {
		return;
	}

	erow *row = &E.row[E.cy];
	if (E.cx > 0) {
		editorRowDelChar(row, E.cx - 1);
		E.cx--;
		E.preferred_rx = -1;
		return;
	}

	E.cx = E.row[E.cy - 1].size;
	editorRowAppendString(&E.row[E.cy - 1], row->chars, (size_t)row->size);
	editorDelRow(E.cy);
	E.cy--;
	E.preferred_rx = -1;
}
