#include <stdlib.h>
#include <string.h>

#include "find.h"
#include "input.h"
#include "rowOps.h"
#include "tedit.h"

void editorFindCallback(char *query, int key)
{
	static int last_match = -1;
	static int direction = 1;
	static int saved_highlight_line = -1;
	static unsigned char *saved_highlight = NULL;

	if (saved_highlight != NULL && saved_highlight_line >= 0 &&
	    saved_highlight_line < E.numrows) {
		memcpy(E.row[saved_highlight_line].highlight, saved_highlight,
		       (size_t)E.row[saved_highlight_line].render_size);
		free(saved_highlight);
		saved_highlight = NULL;
		saved_highlight_line = -1;
	}

	if (key == '\r' || key == '\x1b') {
		last_match = -1;
		direction = 1;
		return;
	}

	if (key == ARROW_RIGHT || key == ARROW_DOWN) {
		direction = 1;
	} else if (key == ARROW_LEFT || key == ARROW_UP) {
		direction = -1;
	} else {
		last_match = -1;
		direction = 1;
	}

	if (last_match == -1) {
		direction = 1;
	}

	int current = last_match;
	for (int row_index = 0; row_index < E.numrows; row_index++) {
		current += direction;
		if (current == -1) {
			current = E.numrows - 1;
		} else if (current == E.numrows) {
			current = 0;
		}

		erow *row = &E.row[current];
		char *match = strstr(row->render, query);
		if (match == NULL) {
			continue;
		}

		last_match = current;
		E.cy = current;
		E.cx = editorRowRxToCx(row, (int)(match - row->render));
		E.rowoff = editorDocumentScreenRowForCursor(E.cy, editorRowCxToRx(row, E.cx));

		saved_highlight_line = current;
		saved_highlight = malloc((size_t)row->render_size);
		if (saved_highlight == NULL) {
			die("malloc");
		}
		memcpy(saved_highlight, row->highlight, (size_t)row->render_size);
		memset(&row->highlight[match - row->render], HL_MATCH, strlen(query));
		break;
	}
}

void editorFind(void)
{
	const int saved_cx = E.cx;
	const int saved_cy = E.cy;
	const int saved_coloff = E.coloff;
	const int saved_rowoff = E.rowoff;

	char *query = editorPrompt("Search: %s (ESC/Arrows/Enter)", editorFindCallback);
	if (query != NULL) {
		free(query);
		return;
	}

	E.cx = saved_cx;
	E.cy = saved_cy;
	E.coloff = saved_coloff;
	E.rowoff = saved_rowoff;
}
