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

int is_seperator(int c)
{
	return isspace(c) || c == '\0' || strchr(",.()+-/*=~%<>[];", c) != NULL;
}

void editorUpdateSyntax(erow *row)
{
	row->hl = realloc(row->hl, row->rsize);
	memset(row->hl, HL_NORMAL, row->rsize);

	if (E.syntax == NULL) return;

	char **keywords = E.syntax->keywords;

	char *scs = E.syntax->singleline_comment_start;
	char *mcs = E.syntax->multiline_comment_start;
	char *mce = E.syntax-> multiline_comment_end;

	int scs_len = scs ? strlen(scs) : 0;
	int mcs_len = mcs ? strlen(mcs) : 0;
	int mce_len = mce ? strlen(mce) : 0;

	int prev_sep = 1;
	int in_string = 0;
	int in_comment = (row->idx > 0 && E.row[row->idx - 1].hl_open_comment);

	int i = 0;
	while (i < row->rsize)
	{
		char c = row->render[i];
		unsigned char prev_hl = (i>0) ? row->hl[i - 1] : HL_NORMAL;

		if (scs_len && !in_string && !in_comment)
		{
			if (!strncmp(&row->render[i], scs, scs_len))
			{
				memset(&row->hl[i], HL_COMMENT, row->rsize - i);
				break;
			}
		}
		
		if (mcs_len && mce_len && !in_string)
		{
			if (in_comment)
			{
				row->hl[i] = HL_MLCOMMENT;
				if (!strncmp(&row->render[i], mce, mce_len))
				{
					memset(&row->hl[i], HL_MLCOMMENT, mce_len);
					i += mce_len;
					in_comment = 0;
					prev_sep = 1;
					continue;
				} else {
					i++;
					continue;
				}
			} else if (!strncmp(&row->render[i], mcs, mcs_len)) {
				memset(&row->hl[i], HL_MLCOMMENT, mcs_len);
				i += mcs_len;
				in_comment = 1;
				continue;
			}
		} else if (!strncmp(&row->render[i], mcs, mcs_len)) {
			memset(&row->hl[i], HL_MLCOMMENT, mcs_len);
			i += mcs_len;
			in_comment = 1;
			continue;
		}

		if(E.syntax->flags & HL_HIGHLIGHT_STRINGS)
		{
			if (in_string)
			{
				row->hl[i] = HL_STRING;
				if (c == '\\' && i + 1 <row->rsize)
				{
					row->hl[i + 1] = HL_STRING;
					i += 2;
					continue;
				}
				if (c == in_string) in_string = 0;
				i++;
				prev_sep = 1;
				continue;
			} else {
				if (c == '"' || c == '\'')
				{
					in_string = c;
					row->hl[i] = HL_STRING;
					i++;
					continue;
				}
			}
		}

		if (E.syntax->flags & HL_HIGHLIGHT_NUMERS)
		{
			if ((isdigit(c) && (prev_sep || prev_hl == HL_NUMBER)) ||
				(c == '.' && prev_hl == HL_NUMBER))
			{
				row->hl[i] = HL_NUMBER;
				i++;
				prev_sep = 0;
				continue;
			}
		}
		
		if (prev_sep)
		{
			int j;
			for (j = 0; keywords[j]; j++)
			{
				int klen = strlen(keywords[j]);
				int kw2 = keywords[j][klen - 1] == '|';
				if (kw2) klen--;

				if (!strncmp(&row->render[i], keywords[j], klen) &&
					is_seperator(row->render[i + klen]) )
					{
						memset(&row->hl[i], kw2 ? HL_KEYWORD2 : HL_KEYWORD1, klen);
						i+= klen;
						break;
					}
			}
			if (keywords[j] != NULL) 
			{
				prev_sep = 0;
				continue;
			}
		}

		prev_sep = is_seperator(c);
		i++;
	}

	int changed = (row->hl_open_comment != in_comment);
	row->hl_open_comment = in_comment;
	if (changed && row->idx + 1 < E.numrows)
		editorUpdateSyntax(&E.row[row->idx + 1]);
}

int editorSyntaxToColor(int hl)
{
	switch (hl)
	{
		case HL_COMMENT:
		case HL_MLCOMMENT: return 36; // Multi line comments are cyan
		case HL_KEYWORD1: return 33; // keyword 1 in yellow 
		case HL_KEYWORD2: return 32; // keyword 2 in green
		case HL_STRING: return 35; // Strings are magenta
		case HL_NUMBER: return 31; // Numbers are red
		case HL_MATCH: return 34; // Forground blue
		default: return 37;
	}
}

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





// Find
void editorFindCallback(char *query, int key)
{
	static int last_match = -1;
	static int direction = 1;

	static int saved_hl_line; 
	static char *saved_hl = NULL;

	if (saved_hl)
	{
		memcpy(E.row[saved_hl_line].hl, saved_hl, E.row[saved_hl_line].rsize);
		free(saved_hl);
		saved_hl = NULL;
	}

	if (key == '\r' || key == '\x1b') 
	{
		last_match = -1;
		direction = 1;
		return;
	} else if (key == ARROW_RIGHT || key == ARROW_DOWN) {
		direction = 1;
	} else if (key == ARROW_LEFT || key == ARROW_UP) {
		direction = -1;
	} else {
		last_match = -1;
		direction = 1;
	}

	if (last_match == -1) direction = 1;
	int current = last_match;
	int i;
	for (i = 0; i<E.numrows; i++)
	{
		current += direction;
		if (current == -1) current = E.numrows - 1;
		else if (current == E.numrows) current = 0;

		erow *row = &E.row[current];
		char *match = strstr(row->render, query);
		if(match) 
		{
			last_match = current;
			E.cy = current;
			E.cx = editorRowRxToCx(row, match - row->render);
			E.rowoff = E.numrows;

			saved_hl_line = current;
			saved_hl = malloc(row->size);
			memcpy(saved_hl, row->hl, row->rsize);
			memset(&row->hl[match - row->render], HL_MATCH, strlen(query));
			break;
		}
	}
}

void editorFind()
{
	int saved_cx = E.cx;
	int saved_cy = E.cy;
	int saved_coloff = E.coloff;
	int saved_rowoff = E.rowoff;

	char *query = editorPrompt("Search: %s (ESC/Arrows/Enter)", editorFindCallback);
	
	if (query) {
		free(query);
	} else {
		E.cx = saved_cx;
		E.cy = saved_cy;
		E.coloff = saved_coloff;
		E.rowoff = saved_rowoff;
	}
}

// Append buffer 
// Solves issue of flicering effect by having 1 large write
// function instead of small ones.
struct abuf {
	char *b;
	int len;
};

#define ABUF_INIT {NULL, 0};

void abAppend(struct abuf *ab, const char *s, int len)
{
	char *new = realloc(ab->b, ab->len + len);

	if (new == NULL) return;

	memcpy(&new[ab->len], s, len);

	ab->b = new;
	ab->len += len;
}

void abFree(struct abuf *ab) { free(ab->b); }

// Output

void editorScroll()
{
	E.rx = 0;
	if (E.cy < E.numrows)
	{
		E.rx = editorRowCxToRx(&E.row[E.cy], E.cx);
	} 

	if (E.cy < E.rowoff)
	{
		E.rowoff = E.cy;
	}
	if (E.cy >= E.rowoff + E.screenrows)
	{
		E.rowoff = E.cy - E.screenrows + 1;
	}
	if (E.rx < E.coloff)
	{
		E.coloff = E.rx;
	}
	if (E.rx >= E.coloff + E.screencols)
	{
		E.coloff = E.rx - E.screencols + 1;
	}
}

void editorDrawRows(struct abuf *ab)
{
	int i; 

	for (i = 0; i < E.screenrows; i++)
	{
		int filerow = i + E.rowoff;
		if (filerow >= E.numrows)
		{
			if (E.numrows == 0 && i == E.screenrows / 3)
			{
				char welcome[80];
				int welcomelen = snprintf(welcome, sizeof(welcome),
								"tEdit editor -- verison %s", TEDIT_VERSION);
				if(welcomelen > E.screencols) welcomelen = E.screencols;
				int padding = (E.screencols - welcomelen) / 2;
				if (padding)
				{
					abAppend(ab, "~", 1);
					padding--;
				}
				while (padding--) abAppend(ab, " ", 1);
				abAppend(ab, welcome, welcomelen);
			} else {
				abAppend(ab, "~", 1);
			}
		} else {
			int len = E.row[filerow].rsize - E.coloff;
			if (len < 0) len = 0;
			if (len > E.screencols) len = E.screencols;
			char *c = &E.row[filerow].render[E.coloff];
			unsigned char *hl = &E.row[filerow].hl[E.coloff];
			int current_color = -1;
			for (int j = 0; j<len; j++)
			{
				if (iscntrl(c[j]))
				{
					char sym = (c[j] <= 26) ? '@' + c[j] : '?';
					abAppend(ab, "\x1b[7m", 4);
					abAppend(ab, &sym, 1);
					abAppend(ab, "\x1b[m", 3);
					if (current_color != 1)
					{
						char buf[16];
						int clen = snprintf(buf, sizeof(buf), "\x1b[%dm", current_color);
						abAppend(ab, buf, clen);
					}
				} else if (hl[j] == HL_NORMAL) {
					if (current_color != -1)
					{
						abAppend(ab, "\x1b[39m", 5);
						current_color = -1;
					}
					abAppend(ab, &c[j], 1);
				} else {
					int color = editorSyntaxToColor(hl[j]);
					if (color != current_color)
					{
						current_color = color;
						char buf[16];
						int clen = snprintf(buf, sizeof(buf), "\x1b[%dm", color);
						abAppend(ab, buf, clen);
					}
					abAppend(ab, &c[j], 1);
				}
			}
			abAppend(ab, "\x1b[39m", 5);
		}
		
		abAppend(ab, "\x1b[K", 3);
		abAppend(ab, "\r\n", 2);
	}
}

void editorDrawStatusBar(struct abuf *ab)
{
	abAppend(ab, "\x1b[7m", 4);
	char status[80], rstatus[80];
	int len = snprintf(status, sizeof(status), "%.20s - %d lines %s",
		E.filename ? E.filename : "[No Name]", E.numrows,
		E.dirty ? "(modified)" : " ");
	int rlen = snprintf(rstatus, sizeof(rstatus), "%s | %d/%d",
		E.syntax ? E.syntax->filetype : "no ft" ,E.cy + 1, E.numrows);
	if(len > E.screencols) len = E.screencols;
	abAppend(ab, status, len);
	while (len < E.screencols)
	{
		if (E.screencols - len == rlen) 
		{
			abAppend(ab, rstatus, rlen);
			break;
		} else {
			abAppend(ab, " ", 1);
			len++;
		}
	}
	abAppend(ab, "\x1b[m", 3);
	abAppend(ab, "\r\n", 2);
}

void editorDrawMessageBar(struct abuf *ab)
{
	abAppend(ab, "\x1b[K", 3);
	int msglen = strlen(E.statusmsg);
	if(msglen > E.screencols) msglen = E.screencols;
	if(msglen && time(NULL) - E.statusmsg_time < 5)
		abAppend(ab, E.statusmsg, msglen);
}

void editorRefreshScreen()
{
	editorScroll();

	struct abuf ab = ABUF_INIT;

	abAppend(&ab, "\x1b[?25l", 6);
	abAppend(&ab, "\x1b[H", 3);

	editorDrawRows(&ab);
	editorDrawStatusBar(&ab);
	editorDrawMessageBar(&ab);

	char buf[32];
	snprintf(buf, sizeof(buf), "\x1b[%d;%dH", (E.cy - E.rowoff) + 1, 
												(E.rx + E.coloff) + 1);
	abAppend(&ab, buf, strlen(buf));

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

// Input

char *editorPrompt(char *prompt, void (*callback)(char *, int))
{
	size_t bufsize = 128;
	char *buf = malloc(bufsize);

	size_t buflen = 0;
	buf[0] = '\0';

	while (1)
	{
		editorSetStatusMessage(prompt, buf);
		editorRefreshScreen();

		int c = editorReadKey();
		if (c == DEL_KEY || c == CTRL_KEY('h') || c == BACKSPACE)
		{
			if (buflen != 0) buf[--buflen] = '\0';
		} else if (c == '\x1b') {
			editorSetStatusMessage("");
			if(callback) callback(buf, c);
			free(buf);
			return NULL;
		} else if (c == '\r') {
			if (buflen != 0)
			{
				editorSetStatusMessage("");
				if(callback) callback(buf, c);
				return buf;
			}
		} else if (!iscntrl(c) && c < 128) {
			if (buflen == bufsize - 1) 
			{
				bufsize *= 2;
				buf = realloc(buf, bufsize);
			}
			buf[buflen++] = c;
			buf[buflen] = '\0';
		}
		if (callback) callback(buf, c);
	}
}

void editorMoveCursor(int key)
{
	erow *row = (E.cy >= E.numrows) ? NULL : &E.row[E.cy];

	switch (key)
	{
		case ARROW_LEFT:
			if (E.cx != 0)
			{
				E.cx--;
			} else if (E.cy > 0) {
				E.cy--;
				E.cx = E.row[E.cy].size;
			}
			break;
		case ARROW_RIGHT:
			if (row && E.cx < row->size)
			{
				E.cx++;
			} else if (row && E.cx == row->size) {
				E.cy++;
				E.cx = 0;
			}
			break;
		case ARROW_UP:
			if (E.cy != 0)
			{
				E.cy--;
			}
			break;
		case ARROW_DOWN:
			if (E.cy != E.numrows)
			{
				E.cy++;
			}
			break;
	}

	row = (E.cy >= E.numrows) ? NULL : &E.row[E.cy];
	int rowlen = row ? row->size : 0;
	if (E.cx > rowlen)
	{
		E.cx = rowlen;
	}
}

void editorProcessKeypress()
{
	static int quit_times = TEDIT_QUIT_TIMES;
	static int open_times = TEDIT_OPEN_TIMES;

	int c = editorReadKey();

	switch (c)
	{
		case '\r':
			editorInsertNewline();
			break;
		case CTRL_KEY('q'):
			if (E.dirty && quit_times > 0)
			{
				editorSetStatusMessage("WARNING: File has unsaved changes!! "
										"Press Ctrl-Q %d more times to quit.", quit_times);
				quit_times--;
				return;
			}
			write(STDOUT_FILENO, "\x1b[2J", 4); // Clear the screen
 			write(STDOUT_FILENO, "\x1b[H", 3); 
			exit(0);
			break;

		case CTRL_KEY('o'):
			if (E.dirty && open_times > 0)
			{
				editorSetStatusMessage("WARNING: File has unsaved changes!! "
										"Press Ctrl-O %d more times to ovewrite.", open_times);
				open_times--;
				return;
			}
			editorOpenFromEdit();
			break;

		case CTRL_KEY('s'):
			editorSave();
			break;

		case HOME_KEY:
			E.cx = 0;
			break;

		case END_KEY:
			if (E.cy < E.numrows)
				E.cx = E.row[E.cy].size;
			break;

		case CTRL_KEY('f'):
			editorFind();
			break;

		case BACKSPACE:
		case CTRL_KEY('h'):
		case DEL_KEY:
			if (c == DEL_KEY) editorMoveCursor(ARROW_RIGHT);
			editorDelChar();
			break;

		case PAGE_UP:
		case PAGE_DOWN:
			{
				if (c == PAGE_UP)
				{
					E.cy = E.rowoff;
				} else if (c == PAGE_DOWN) {
					E.cy = E.rowoff + E.screenrows - 1;
					if (E.cy > E.numrows) E.cy = E.numrows;
				}
				
				int times = E.screenrows;
				while (times--)
					editorMoveCursor(c == PAGE_UP ? ARROW_UP : ARROW_DOWN);
			}
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
	quit_times = TEDIT_QUIT_TIMES;
	open_times = TEDIT_OPEN_TIMES;
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
