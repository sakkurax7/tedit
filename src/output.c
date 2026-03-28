#include <ctype.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#include "output.h"
#include "rowOps.h"
#include "syntaxHighlighting.h"
#include "tedit.h"

static int editorCurrentLineNumberWidth(void)
{
	return editorLineNumberWidth();
}

void editorScroll(void)
{
	E.rx = 0;
	if (E.cy < E.numrows) {
		E.rx = editorRowCxToRx(&E.row[E.cy], E.cx);
	}

	const int cursor_screen_row = editorDocumentScreenRowForCursor(E.cy, E.rx);
	const int line_number_width = editorCurrentLineNumberWidth();
	const int visible_text_cols = editorTextCols();
	const int wrap_offset = E.settings.soft_wrap ? E.rx % visible_text_cols : 0;

	if (cursor_screen_row < E.rowoff) {
		E.rowoff = cursor_screen_row;
	}
	if (cursor_screen_row >= E.rowoff + E.screenrows) {
		E.rowoff = cursor_screen_row - E.screenrows + 1;
	}

	if (!E.settings.soft_wrap) {
		if (E.rx < E.coloff) {
			E.coloff = E.rx;
		}
		if (E.rx >= E.coloff + visible_text_cols) {
			E.coloff = E.rx - visible_text_cols + 1;
		}
	} else {
		E.coloff = 0;
		(void)wrap_offset;
	}

	if (line_number_width >= E.screencols) {
		E.coloff = 0;
	}
}

static void editorDrawLineNumber(struct abuf *ab, int file_row, bool continued_line)
{
	const int width = editorCurrentLineNumberWidth();
	if (width == 0) {
		return;
	}

	char buffer[32];
	if (continued_line) {
		snprintf(buffer, sizeof(buffer), "%*s ", width - 1, ".");
	} else {
		snprintf(buffer, sizeof(buffer), "%*d ", width - 1, file_row + 1);
	}
	abAppend(ab, buffer, strlen(buffer));
}

static void editorDrawWrappedSegment(struct abuf *ab, const erow *row, int segment)
{
	const int text_cols = editorTextCols();
	const int render_offset = E.settings.soft_wrap ? segment * text_cols : E.coloff;
	int len = row->render_size - render_offset;

	if (len < 0) {
		len = 0;
	}
	if (len > text_cols) {
		len = text_cols;
	}

	const char *render = &row->render[render_offset];
	const unsigned char *highlight = &row->highlight[render_offset];
	int current_color = -1;

	for (int column = 0; column < len; column++) {
		if (iscntrl((unsigned char)render[column])) {
			const char symbol = render[column] <= 26 ? (char)('@' + render[column]) : '?';
			abAppend(ab, "\x1b[7m", 4);
			abAppend(ab, &symbol, 1);
			abAppend(ab, "\x1b[m", 3);
			if (current_color != -1) {
				char color_buffer[16];
				const int color_len =
					snprintf(color_buffer, sizeof(color_buffer), "\x1b[%dm", current_color);
				abAppend(ab, color_buffer, (size_t)color_len);
			}
			continue;
		}

		if (highlight[column] == HL_NORMAL) {
			if (current_color != -1) {
				abAppend(ab, "\x1b[39m", 5);
				current_color = -1;
			}
		} else {
			const int color = editorSyntaxToColor(highlight[column]);
			if (color != current_color) {
				char color_buffer[16];
				current_color = color;
				const int color_len =
					snprintf(color_buffer, sizeof(color_buffer), "\x1b[%dm", color);
				abAppend(ab, color_buffer, (size_t)color_len);
			}
		}

		abAppend(ab, &render[column], 1);
	}

	abAppend(ab, "\x1b[39m", 5);
}

void editorDrawRows(struct abuf *ab)
{
	for (int screen_line = 0; screen_line < E.screenrows; screen_line++) {
		const int document_screen_line = E.rowoff + screen_line;
		int file_row = 0;
		int wrap_row = 0;

		if (!editorScreenRowToFileRow(document_screen_line, &file_row, &wrap_row)) {
			const int line_number_width = editorCurrentLineNumberWidth();
			if (line_number_width > 0) {
				char gutter[32];
				snprintf(gutter, sizeof(gutter), "%*s", line_number_width, "~");
				abAppend(ab, gutter, strlen(gutter));
			} else {
				abAppend(ab, "~", 1);
			}

			if (E.numrows == 0 && screen_line == E.screenrows / 3) {
				char welcome[80];
				const int welcome_len =
					snprintf(welcome, sizeof(welcome), "tEdit editor -- version %s", TEDIT_VERSION);
				int padding = (editorTextCols() - welcome_len) / 2;
				if (padding < 0) {
					padding = 0;
				}
				while (padding-- > 0) {
					abAppend(ab, " ", 1);
				}
				abAppend(ab, welcome, strlen(welcome));
			}

			abAppend(ab, "\x1b[K", 3);
			abAppend(ab, "\r\n", 2);
			continue;
		}

		editorDrawLineNumber(ab, file_row, wrap_row > 0);
		editorDrawWrappedSegment(ab, &E.row[file_row], wrap_row);
		abAppend(ab, "\x1b[K", 3);
		abAppend(ab, "\r\n", 2);
	}
}

void editorDrawStatusBar(struct abuf *ab)
{
	abAppend(ab, "\x1b[7m", 4);

	char left_status[128];
	char right_status[128];
	const int left_len = snprintf(
		left_status, sizeof(left_status), "%.30s - %d lines %s %s",
		E.filename != NULL ? E.filename : "[No Name]",
		E.numrows,
		E.dirty ? "(modified)" : "",
		E.settings.soft_wrap ? "[wrap]" : "[scroll]");
	const int right_len = snprintf(
		right_status, sizeof(right_status), "%s | %d/%d",
		E.syntax != NULL ? E.syntax->filetype : "no ft",
		E.cy + 1,
		E.numrows);

	int printed = left_len < E.screencols ? left_len : E.screencols;
	abAppend(ab, left_status, (size_t)printed);

	while (printed < E.screencols) {
		if (E.screencols - printed == right_len) {
			abAppend(ab, right_status, (size_t)right_len);
			break;
		}
		abAppend(ab, " ", 1);
		printed++;
	}

	abAppend(ab, "\x1b[m", 3);
	abAppend(ab, "\r\n", 2);
}

void editorDrawMessageBar(struct abuf *ab)
{
	abAppend(ab, "\x1b[K", 3);

	size_t message_len = strlen(E.statusmsg);
	if ((int)message_len > E.screencols) {
		message_len = (size_t)E.screencols;
	}

	if (message_len > 0 && time(NULL) - E.statusmsg_time < 5) {
		abAppend(ab, E.statusmsg, message_len);
	}
}

void editorRefreshScreen(void)
{
	editorScroll();

	struct abuf ab = ABUF_INIT;
	abAppend(&ab, "\x1b[?25l", 6);
	abAppend(&ab, "\x1b[H", 3);

	editorDrawRows(&ab);
	editorDrawStatusBar(&ab);
	editorDrawMessageBar(&ab);

	const int text_cols = editorTextCols();
	const int line_number_width = editorCurrentLineNumberWidth();
	const int cursor_screen_row = editorDocumentScreenRowForCursor(E.cy, E.rx) - E.rowoff + 1;
	const int cursor_screen_col = E.settings.soft_wrap
		? line_number_width + (E.rx % text_cols) + 1
		: line_number_width + (E.rx - E.coloff) + 1;

	char buffer[32];
	snprintf(buffer, sizeof(buffer), "\x1b[%d;%dH", cursor_screen_row, cursor_screen_col);
	abAppend(&ab, buffer, strlen(buffer));

	abAppend(&ab, "\x1b[?25h", 6);
	write(STDOUT_FILENO, ab.b, ab.len);
	abFree(&ab);
}

void editorSetStatusMessage(const char *fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	vsnprintf(E.statusmsg, sizeof(E.statusmsg), fmt, ap);
	va_end(ap);
	E.statusmsg_time = time(NULL);
}
