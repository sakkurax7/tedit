// Includes

#define _DEFAULT_SOURCE      // Make GCC not complain about getline()
#define _BSD_SOURCE          // Add feature test macro.
#define _GNU_SOURCE          // Also makes code more portible.

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

// FIletypes

char *C_HL_extensions[] = { ".c", ".cpp", ".h", NULL};
char *C_HL_keywords[] = { "switch", "if", "while", "for", "break", "continue", "return", "else",
  "struct", "union", "typedef", "static", "enum", "class", "case",
  "int|", "long|", "double|", "float|", "char|", "unsigned|", "signed|",
  "void|", NULL };

// HLDB = hlighlight database
struct editorSyntax HLDB[] = {
	{
		"c",
		C_HL_extensions,
		C_HL_keywords,
		"//", "/*", "*/",
		HL_HIGHLIGHT_NUMERS | HL_HIGHLIGHT_STRINGS
	}
};
#define HLDB_ENTRIES (sizeof(HLDB) / sizeof(HLDB[0]))


// Print error message and exit the program
void die(const char *s)
{
	write(STDOUT_FILENO, "\x1b[2J", 4); // This line and next clear the screen
	write(STDOUT_FILENO, "\x1b[H", 3);

	perror(s);
	exit(1);
}

// Syntax highlighting


void editorSelectSyntaxHighlight()
{
	E.syntax = NULL;
	if (E.filename == NULL) return;

	char *ext = strrchr(E.filename, '.');

	for (unsigned int j = 0; j<HLDB_ENTRIES; j++)
	{
		struct editorSyntax *s = &HLDB[j];
		unsigned int i = 0;
		while (s->filematch[i])
		{
			int is_ext = (s->filematch[i][0] == '.');
			if ((is_ext && ext && !strcmp(ext, s->filematch[i])) ||
				(!is_ext && strstr(E.filename, s->filematch[i])))
				{
					E.syntax = s;

					for (int filerow = 0; filerow<E.numrows; filerow++)
					{
						editorUpdateSyntax(&E.row[filerow]);
					}

					return;
				}
				i++;
		}
	}
}

// Init

void initEditor()
{
	E.cx = 0;
	E.cy = 0;
	E.rx = 0;
	E.rowoff = 0;
	E.coloff = 0;
	E.numrows = 0;
	E.row = NULL;
	E.dirty = 0;
	E.filename = NULL;
	E.statusmsg[0] = '\0';
	E.statusmsg_time = 0;
	E.syntax = NULL;
	
	if (getWindowSize(&E.screenrows, &E.screencols) == -1) die("getWindwowSize");
	E.screenrows -= 2;
}

int main(int argc, char *argv[]) 
{
	enableRawMode(E); 
	initEditor();
	if (argc >= 2)
	{
		if ( access(argv[1], F_OK) != -1) 
		{
			editorOpen(argv[1]);
		} else {
			E.filename = argv[1];
		}
	}

	editorSetStatusMessage(
		"HELP: Ctrl-Q to quit | Ctrl-S to save | Ctrl-F to find | Ctrl-O to open"
		);

	while (1) 
	{
		editorRefreshScreen();
		editorProcessKeypress();
	}

	return 0;

}
