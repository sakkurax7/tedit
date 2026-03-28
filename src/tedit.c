#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <termios.h>
#include <time.h>
#include <unistd.h>
#include "editorOps.h"
#include "tedit.h"
#include "fileIO.h"
#include "canonical.h"
#include "rowOps.h"
#include "find.h"
#include "input.h"
#include "output.h"
#include "appendBuffer.h"
#include "syntaxHighlighting.h"
#include "config.h"


struct editorConfig E;

void die(const char *message)
{
	write(STDOUT_FILENO, "\x1b[2J", 4);
	write(STDOUT_FILENO, "\x1b[H", 3);
	perror(message);
	exit(EXIT_FAILURE);
}

void editorResetDocument(void)
{
	for (int row_index = 0; row_index < E.numrows; row_index++) {
		editorFreeRow(&E.row[row_index]);
	}

	free(E.row);
	E.row = NULL;
	E.numrows = 0;
	E.cx = 0;
	E.cy = 0;
	E.rx = 0;
	E.preferred_rx = -1;
	E.rowoff = 0;
	E.coloff = 0;
	E.dirty = 0;
	E.syntax = NULL;
}

void initEditor(void)
{
	memset(&E, 0, sizeof(E));
	E.preferred_rx = -1;
	E.filename = NULL;
	E.settings.tab_stop = 4;
	E.settings.quit_confirmations = 3;
	E.settings.open_confirmations = 3;
	E.settings.show_line_numbers = true;
	E.settings.soft_wrap = true;
	E.settings.soft_indent = true;
	E.settings.auto_indent = true;

	editorLoadConfig();

	if (getWindowSize(&E.screenrows, &E.screencols) == -1) {
		die("getWindowSize");
	}
	E.screenrows -= 2;
}

int main(int argc, char *argv[])
{
	initEditor();
	enableRawMode(&E);

	if (argc >= 2) {
		if (access(argv[1], F_OK) != -1) {
			editorOpen(argv[1]);
		} else {
			E.filename = argv[1];
		}
	}

	editorSetStatusMessage(
		"HELP: Ctrl-Q quit | Ctrl-S save | Ctrl-F find | Ctrl-O open");

	while (1) {
		editorRefreshScreen();
		editorProcessKeypress();
	}

	return 0;
}
