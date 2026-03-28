#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "canonical.h"
#include "editorOps.h"
#include "fileIO.h"
#include "find.h"
#include "input.h"
#include "output.h"
#include "rowOps.h"
#include "tedit.h"

static bool editorIsWordChar(int c)
{
	return isalnum((unsigned char)c) || c == '_';
}

static int editorCurrentRx(void)
{
	if (E.cy >= E.numrows) {
		return 0;
	}

	return editorRowCxToRx(&E.row[E.cy], E.cx);
}

static void editorMoveToRx(int row_index, int rx)
{
	if (row_index < 0) {
		row_index = 0;
	}
	if (row_index > E.numrows) {
		row_index = E.numrows;
	}

	E.cy = row_index;
	if (E.cy >= E.numrows) {
		E.cx = 0;
		return;
	}

	const erow *row = &E.row[E.cy];
	if (rx < 0) {
		rx = 0;
	}
	if (rx > row->render_size) {
		rx = row->render_size;
	}

	E.cx = editorRowRxToCx(row, rx);
}

static void editorMoveCursorVertical(int direction, int amount)
{
	const int preferred_rx = E.preferred_rx >= 0 ? E.preferred_rx : editorCurrentRx();
	E.preferred_rx = preferred_rx;

	if (!E.settings.soft_wrap) {
		int target_row = E.cy + (direction * amount);
		if (target_row < 0) {
			target_row = 0;
		}
		if (target_row > E.numrows) {
			target_row = E.numrows;
		}
		editorMoveToRx(target_row, preferred_rx);
		return;
	}

	const int current_screen_row = editorDocumentScreenRowForCursor(E.cy, editorCurrentRx());
	int target_screen_row = current_screen_row + (direction * amount);
	if (target_screen_row < 0) {
		target_screen_row = 0;
	}

	int file_row = 0;
	int wrap_row = 0;
	if (!editorScreenRowToFileRow(target_screen_row, &file_row, &wrap_row)) {
		E.cy = E.numrows;
		E.cx = 0;
		return;
	}

	const int text_cols = editorTextCols();
	const erow *row = &E.row[file_row];
	const int segment_start = wrap_row * text_cols;
	int target_rx = preferred_rx;

	if (target_rx < segment_start) {
		target_rx = segment_start;
	}
	if (target_rx > segment_start + text_cols - 1) {
		target_rx = segment_start + text_cols - 1;
	}
	if (target_rx > row->render_size) {
		target_rx = row->render_size;
	}

	editorMoveToRx(file_row, target_rx);
}

static void editorMoveCursorWord(int direction)
{
	if (E.numrows == 0) {
		return;
	}

	if (direction < 0) {
		while (E.cy > 0 || E.cx > 0) {
			if (E.cx == 0) {
				E.cy--;
				E.cx = E.row[E.cy].size;
				if (E.row[E.cy].size == 0) {
					continue;
				}
			}

			erow *row = &E.row[E.cy];
			while (E.cx > 0 && !editorIsWordChar(row->chars[E.cx - 1])) {
				E.cx--;
			}
			while (E.cx > 0 && editorIsWordChar(row->chars[E.cx - 1])) {
				E.cx--;
			}
			break;
		}
	} else {
		while (E.cy < E.numrows) {
			if (E.cy == E.numrows) {
				break;
			}

			erow *row = &E.row[E.cy];
			while (E.cx < row->size && !editorIsWordChar(row->chars[E.cx])) {
				E.cx++;
			}
			while (E.cx < row->size && editorIsWordChar(row->chars[E.cx])) {
				E.cx++;
			}
			if (E.cx < row->size || E.cy == E.numrows - 1) {
				break;
			}
			E.cy++;
			E.cx = 0;
		}
	}

	E.preferred_rx = -1;
}

char *editorPrompt(const char *prompt, void (*callback)(char *, int))
{
	size_t bufsize = 128;
	char *buffer = malloc(bufsize);
	if (buffer == NULL) {
		die("malloc");
	}

	size_t buflen = 0;
	buffer[0] = '\0';

	for (;;) {
		editorSetStatusMessage(prompt, buffer);
		editorRefreshScreen();

		const int c = editorReadKey();
		if (c == DEL_KEY || c == CTRL_KEY('h') || c == BACKSPACE) {
			if (buflen > 0) {
				buffer[--buflen] = '\0';
			}
		} else if (c == '\x1b') {
			editorSetStatusMessage("");
			if (callback != NULL) {
				callback(buffer, c);
			}
			free(buffer);
			return NULL;
		} else if (c == '\r') {
			if (buflen > 0) {
				editorSetStatusMessage("");
				if (callback != NULL) {
					callback(buffer, c);
				}
				return buffer;
			}
		} else if (!iscntrl(c) && c < 128) {
			if (buflen == bufsize - 1) {
				bufsize *= 2;
				char *grown = realloc(buffer, bufsize);
				if (grown == NULL) {
					free(buffer);
					die("realloc");
				}
				buffer = grown;
			}
			buffer[buflen++] = (char)c;
			buffer[buflen] = '\0';
		}

		if (callback != NULL) {
			callback(buffer, c);
		}
	}
}

void editorMoveCursor(int key)
{
	erow *row = E.cy >= E.numrows ? NULL : &E.row[E.cy];

	switch (key) {
	case ARROW_LEFT:
		if (E.cx > 0) {
			E.cx--;
		} else if (E.cy > 0) {
			E.cy--;
			E.cx = E.row[E.cy].size;
		}
		E.preferred_rx = -1;
		break;
	case ARROW_RIGHT:
		if (row != NULL && E.cx < row->size) {
			E.cx++;
		} else if (row != NULL && E.cx == row->size) {
			E.cy++;
			E.cx = 0;
		}
		E.preferred_rx = -1;
		break;
	case ARROW_UP:
		editorMoveCursorVertical(-1, 1);
		break;
	case ARROW_DOWN:
		editorMoveCursorVertical(1, 1);
		break;
	default:
		break;
	}

	row = E.cy >= E.numrows ? NULL : &E.row[E.cy];
	if (row != NULL && E.cx > row->size) {
		E.cx = row->size;
	}
}

void editorProcessKeypress(void)
{
	static int quit_times = -1;
	static int open_times = -1;

	if (quit_times < 0) {
		quit_times = E.settings.quit_confirmations;
	}
	if (open_times < 0) {
		open_times = E.settings.open_confirmations;
	}

	const int c = editorReadKey();

	switch (c) {
	case '\r':
		editorInsertNewline();
		break;
	case CTRL_KEY('q'):
		if (E.dirty && quit_times > 0) {
			editorSetStatusMessage(
				"WARNING: File has unsaved changes. Press Ctrl-Q %d more times to quit.",
				quit_times);
			quit_times--;
			return;
		}
		write(STDOUT_FILENO, "\x1b[2J", 4);
		write(STDOUT_FILENO, "\x1b[H", 3);
		exit(0);
	case CTRL_KEY('o'):
		if (E.dirty && open_times > 0) {
			editorSetStatusMessage(
				"WARNING: File has unsaved changes. Press Ctrl-O %d more times to discard them.",
				open_times);
			open_times--;
			return;
		}
		editorOpenFromEdit();
		break;
	case CTRL_KEY('s'):
		editorSave();
		break;
	case CTRL_KEY('f'):
		editorFind();
		break;
	case HOME_KEY:
		E.cx = 0;
		E.preferred_rx = -1;
		break;
	case END_KEY:
		if (E.cy < E.numrows) {
			E.cx = E.row[E.cy].size;
			E.preferred_rx = -1;
		}
		break;
	case BACKSPACE:
	case CTRL_KEY('h'):
	case DEL_KEY:
		if (c == DEL_KEY) {
			editorMoveCursor(ARROW_RIGHT);
		}
		editorDelChar();
		break;
	case PAGE_UP:
		editorMoveCursorVertical(-1, E.screenrows);
		break;
	case PAGE_DOWN:
		editorMoveCursorVertical(1, E.screenrows);
		break;
	case CTRL_ARROW_LEFT:
		editorMoveCursorWord(-1);
		break;
	case CTRL_ARROW_RIGHT:
		editorMoveCursorWord(1);
		break;
	case CTRL_ARROW_UP:
		editorMoveCursorVertical(-1, E.screenrows);
		break;
	case CTRL_ARROW_DOWN:
		editorMoveCursorVertical(1, E.screenrows);
		break;
	case ARROW_UP:
	case ARROW_DOWN:
	case ARROW_LEFT:
	case ARROW_RIGHT:
		editorMoveCursor(c);
		break;
	case CTRL_KEY('l'):
	case '\x1b':
		break;
	default:
		editorInsertChar(c);
		break;
	}

	quit_times = E.settings.quit_confirmations;
	open_times = E.settings.open_confirmations;
}
