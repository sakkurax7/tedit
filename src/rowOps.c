#include <stdlib.h>
#include <string.h>

#include "rowOps.h"
#include "syntaxHighlighting.h"

static int editorDigitCount(int value)
{
	int digits = 1;

	while (value >= 10) {
		value /= 10;
		digits++;
	}

	return digits;
}

int editorRowCxToRx(const erow *row, int cx)
{
	int rx = 0;

	for (int index = 0; index < cx && index < row->size; index++) {
		if (row->chars[index] == '\t') {
			rx += (E.settings.tab_stop - 1) - (rx % E.settings.tab_stop);
		}
		rx++;
	}

	return rx;
}

int editorRowRxToCx(const erow *row, int rx)
{
	int current_rx = 0;

	for (int cx = 0; cx < row->size; cx++) {
		if (row->chars[cx] == '\t') {
			current_rx += (E.settings.tab_stop - 1) - (current_rx % E.settings.tab_stop);
		}
		current_rx++;
		if (current_rx > rx) {
			return cx;
		}
	}

	return row->size;
}

void editorUpdateRow(erow *row)
{
	int tabs = 0;
	for (int index = 0; index < row->size; index++) {
		if (row->chars[index] == '\t') {
			tabs++;
		}
	}

	free(row->render);
	row->render = malloc((size_t)row->size +
	                     (size_t)tabs * (size_t)(E.settings.tab_stop - 1) + 1U);
	if (row->render == NULL) {
		die("malloc");
	}

	int render_index = 0;
	for (int index = 0; index < row->size; index++) {
		if (row->chars[index] == '\t') {
			row->render[render_index++] = ' ';
			while (render_index % E.settings.tab_stop != 0) {
				row->render[render_index++] = ' ';
			}
			continue;
		}

		row->render[render_index++] = row->chars[index];
	}

	row->render[render_index] = '\0';
	row->render_size = render_index;
	editorUpdateSyntax(row);
}

void editorInsertRow(int at, const char *text, size_t len)
{
	if (at < 0 || at > E.numrows) {
		return;
	}

	erow *rows = realloc(E.row, sizeof(*E.row) * (size_t)(E.numrows + 1));
	if (rows == NULL) {
		die("realloc");
	}
	E.row = rows;

	memmove(&E.row[at + 1], &E.row[at], sizeof(*E.row) * (size_t)(E.numrows - at));
	for (int row_index = at + 1; row_index <= E.numrows; row_index++) {
		E.row[row_index].index++;
	}

	E.row[at].index = at;
	E.row[at].size = (int)len;
	E.row[at].chars = malloc(len + 1);
	E.row[at].render = NULL;
	E.row[at].highlight = NULL;
	E.row[at].render_size = 0;
	E.row[at].open_comment = false;

	if (E.row[at].chars == NULL) {
		die("malloc");
	}

	memcpy(E.row[at].chars, text, len);
	E.row[at].chars[len] = '\0';

	editorUpdateRow(&E.row[at]);
	E.numrows++;
	E.dirty++;
}

void editorFreeRow(erow *row)
{
	free(row->render);
	free(row->chars);
	free(row->highlight);
	row->render = NULL;
	row->chars = NULL;
	row->highlight = NULL;
}

void editorDelRow(int at)
{
	if (at < 0 || at >= E.numrows) {
		return;
	}

	editorFreeRow(&E.row[at]);
	memmove(&E.row[at], &E.row[at + 1], sizeof(*E.row) * (size_t)(E.numrows - at - 1));

	for (int row_index = at; row_index < E.numrows - 1; row_index++) {
		E.row[row_index].index--;
	}

	E.numrows--;
	E.dirty++;
}

void editorRowInsertChar(erow *row, int at, int c)
{
	if (at < 0 || at > row->size) {
		at = row->size;
	}

	char *chars = realloc(row->chars, (size_t)row->size + 2);
	if (chars == NULL) {
		die("realloc");
	}
	row->chars = chars;

	memmove(&row->chars[at + 1], &row->chars[at], (size_t)(row->size - at + 1));
	row->size++;
	row->chars[at] = (char)c;
	editorUpdateRow(row);
	E.dirty++;
}

void editorRowAppendString(erow *row, const char *text, size_t len)
{
	char *chars = realloc(row->chars, (size_t)row->size + len + 1);
	if (chars == NULL) {
		die("realloc");
	}
	row->chars = chars;

	memcpy(&row->chars[row->size], text, len);
	row->size += (int)len;
	row->chars[row->size] = '\0';
	editorUpdateRow(row);
	E.dirty++;
}

void editorRowDelChar(erow *row, int at)
{
	if (at < 0 || at >= row->size) {
		return;
	}

	memmove(&row->chars[at], &row->chars[at + 1], (size_t)(row->size - at));
	row->size--;
	editorUpdateRow(row);
	E.dirty++;
}

size_t editorIndentColumns(const erow *row, int limit_cx)
{
	size_t columns = 0;
	const int limit = limit_cx < row->size ? limit_cx : row->size;

	for (int index = 0; index < limit; index++) {
		if (row->chars[index] == ' ') {
			columns++;
		} else if (row->chars[index] == '\t') {
			columns += (size_t)(E.settings.tab_stop -
			                    (int)(columns % (size_t)E.settings.tab_stop));
		} else {
			break;
		}
	}

	return columns;
}

int editorLineNumberWidth(void)
{
	if (!E.settings.show_line_numbers) {
		return 0;
	}

	return editorDigitCount(E.numrows > 0 ? E.numrows : 1) + 2;
}

int editorTextCols(void)
{
	const int cols = E.screencols - editorLineNumberWidth();
	return cols > 1 ? cols : 1;
}

int editorRowScreenRows(const erow *row)
{
	if (!E.settings.soft_wrap) {
		return 1;
	}

	const int text_cols = editorTextCols();
	if (row->render_size <= 0) {
		return 1;
	}

	return (row->render_size + text_cols - 1) / text_cols;
}

int editorDocumentScreenRowForCursor(int file_row, int rx)
{
	int screen_row = 0;

	for (int row_index = 0; row_index < file_row && row_index < E.numrows; row_index++) {
		screen_row += editorRowScreenRows(&E.row[row_index]);
	}

	if (E.settings.soft_wrap && file_row < E.numrows) {
		screen_row += rx / editorTextCols();
	}

	return screen_row;
}

bool editorScreenRowToFileRow(int screen_row, int *file_row, int *wrap_row)
{
	int current = 0;

	for (int row_index = 0; row_index < E.numrows; row_index++) {
		const int row_screen_rows = editorRowScreenRows(&E.row[row_index]);
		if (screen_row < current + row_screen_rows) {
			*file_row = row_index;
			*wrap_row = screen_row - current;
			return true;
		}
		current += row_screen_rows;
	}

	return false;
}
