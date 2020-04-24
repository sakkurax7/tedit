// Includes

#define _DEFAULT_SOURCE      // Make GCC not complain about getline()
#define _BSD_SOURCE          // Add feature test macro.
#define _GNU_SOURCE          // Also makes code more portible.

#include <ctype.h>
#include <errno.h>
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <termios.h>
#include <time.h>
#include <unistd.h>

// Defines
#define TEDIT_VERSION "0.0.1"
#define TEDIT_TAB_STOP 8

#define CTRL_KEY(k) ((k) & 0x1f)

enum editorKey {
	ARROW_LEFT = 1000,
	ARROW_RIGHT,
	ARROW_UP,
	ARROW_DOWN,
	DEL_KEY,
	HOME_KEY,
	END_KEY,
	PAGE_UP,
	PAGE_DOWN
};

// DATA

typedef struct erow 
{
	int size;
	int rsize;
	char *chars;
	char *render;
} erow;

struct editorConfig 
{
	int cx, cy; // Cursor x and y position
	int rx;

	int rowoff;
	int coloff;

	int screenrows;
	int screencols;

	int numrows;
	erow *row;

	char *filename;
	char statusmsg[80];
	time_t statusmsg_time;

	struct termios orig_termios;
};

struct editorConfig E;

// Terminal


// Print error message and exit the program
void die(const char *s)
{
	write(STDOUT_FILENO, "\x1b[2J", 4); // This line and next clear the screen
	write(STDOUT_FILENO, "\x1b[H", 3);

	perror(s);
	exit(1);
}

/*
 *  Canonical mode, or cooked mode makes it so that every character that 
 *  is entered gets echoed. We obviously don't want this for a text editor, 
 *  so we must enter raw mode, which makes the terminal not echo everything
 *  that's typed. When the script starts it should enter raw mode, and when
 *  it ends it should exit so the user isn't stuck in raw mode.
 */

void disableRawMode()
{
	if (tcsetattr(STDIN_FILENO, TCSAFLUSH, &E.orig_termios) == -1)
		die("tcsetattr");
}

void enableRawMode() 
{
	if (tcgetattr(STDIN_FILENO, &E.orig_termios) == -1) die("tcgetattr");
	atexit(disableRawMode);

	struct termios raw = E.orig_termios;

			// Unknown is various antiquated flags to turn off
	raw.c_iflag &= ~(BRKINT | ICRNL | INPCK | ISTRIP | IXON); 		
			// Disable unknown, ctrl-m, unknown, unknown, and 
			// ctrl-s, ctrl-q (software flow control)
	raw.c_oflag &= ~(OPOST); 
			// Disable automatic conversion from \n to \r\n
	raw.c_cflag |= (CS8);
			// Unknown
	raw.c_lflag &= ~(ECHO | ICANON | IEXTEN | ISIG); 
			// Flips the bits for echo, canonical mode, ctrl-v,
			// and interrupt signal (ctrl-c, ctrl-z)
	
	// Set timeout for read() so that it returns if if doesn't get any
	// input for a certain amount of time
	raw.c_cc[VMIN] = 0;  // Set minimum number of bytes is needed before
			     // read() can return. 0 Means that it can return
			     // instantly
	raw.c_cc[VTIME] = 1; // Set maximum amount of time to wait before 
			     // read() returns in tenths of seconds.

	tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw);

	if (tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw) == -1) die("tcsetattr");
}

int editorReadKey()
{
	int nread;
	char c;

	while ((nread = read(STDIN_FILENO, &c, 1)) != 1)
	{
		if (nread == -1 && errno != EAGAIN) die("read");
	}

	if (c == '\x1b')
	{
		char seq[3];

		if (read(STDIN_FILENO, &seq[0], 1) != 1) return '\x1b';
		if (read(STDIN_FILENO, &seq[1], 1) != 1) return '\x1b';

		if (seq[0] == '[')
		{
			if (seq[1] >= '0' && seq[1] <= '9') 
			{
				if (read(STDIN_FILENO, &seq[2], 1) != 1) return '\x1b';
				if (seq[2] == '~') 
				{
					switch (seq[1])
					{
						case '1': return HOME_KEY;
						case '3': return DEL_KEY;
						case '4': return END_KEY;
						case '5': return PAGE_UP;
						case '6': return PAGE_DOWN;
						case '7': return HOME_KEY;
						case '8': return END_KEY;
					}
				}
			} else {
				switch (seq[1]) 
				{
					case 'A': return ARROW_UP;
					case 'B': return ARROW_DOWN;
					case 'C': return ARROW_RIGHT;
					case 'D': return ARROW_LEFT;
					case 'H': return HOME_KEY;
					case 'F': return END_KEY;
				}
			}
		} else if (seq[0] == 'O') {
			switch (seq[1]) 
			{
				case 'H': return HOME_KEY;
				case 'F': return END_KEY;
			}
		}

		return '\x1b';
	} else {
		return c;
	}

	return c;
}

int getCursorPosition(int *rows, int *cols)
{
	char buf[32];
	unsigned int i = 0;
	
	if (write(STDOUT_FILENO, "\x1b[6n", 4) != 4) return -1;

	printf("\r\n");
	
	while (i < sizeof(buf) - 1)
	{
		if (read(STDIN_FILENO, &buf[i], 1) != 1) break;
		if (buf[i] == 'R') break;
		i++;
	}
	buf[i] = '\0';

	if (buf[0] != '\x1b' || buf[1] != '[') return -1;
	if (sscanf(&buf[2], "%d;%d", rows, cols) != 2) return -1;

	return 0;
}

int getWindowSize(int *rows, int *cols)
{
	struct winsize ws;

	if (ioctl(STDOUT_FILENO, TIOCGWINSZ, &ws) == -1 || ws.ws_col == 0)
	{
		if (write(STDOUT_FILENO, "\x1b[999C\x1b[999B", 12) != 12) return -1;
		return getCursorPosition(rows, cols);
	} else {
		*cols = ws.ws_col;
		*rows = ws.ws_row;
		return 0;
	}
}

// Row Operations

int editorRowCxToRx(erow *row, int cx)
{
	int rx = 0;
	int j;
	for (j = 0; j< cx; j++)
	{
		if(row->chars[j] == '\t')
			rx += (TEDIT_TAB_STOP - 1) - (rx % TEDIT_TAB_STOP);
		rx++;
	}
	return rx;
}

void editorUpdateRow(erow *row)
{
	int tabs = 0;
	int j;
	for (j = 0; j< row->size; j++)
		if(row->chars[j] == '\t') tabs++;

	free(row->render);
	row->render = malloc(row->size + tabs*(TEDIT_TAB_STOP -1) + 1);

	int idx = 0;
	for (j = 0; j < row->size; j++)
	{
		if(row->chars[j] == '\t')
		{
			row->render[idx++] = ' ';
			while (idx % TEDIT_TAB_STOP != 0) row->render[idx++] = ' ';
		} else {
			row->render[idx++] = row->chars[j];
		}
	}
	row->render[idx] = '\0';
	row->rsize = idx;
}

void editorAppendRow(char *s, size_t len)
{
	E.row = realloc(E.row, sizeof(erow) * (E.numrows + 1));

	int at = E.numrows;
	E.row[at].size = len;
	E.row[at].chars = malloc(len + 1);
	memcpy(E.row[at].chars, s, len);
	E.row[at].chars[len] = '\0';

	E.row[at].rsize = 0;
	E.row[at].render = NULL;
	editorUpdateRow(&E.row[at]);

	E.numrows++;
}


// File I/O

void editorOpen(char *filename)
{
	free(E.filename);
	E.filename = strdup(filename);

	FILE *fp = fopen(filename, "r");
	if (!fp) die ("fopen");
	
	char *line = NULL;
	size_t linecap = 0;
	ssize_t linelen;

	while ((linelen = getline(&line, &linecap, fp)) != -1)
	{
		while (linelen > 0 && (line[linelen - 1] == '\n' ||
								line[linelen - 1] == '\r'))
			linelen--;
		editorAppendRow(line, linelen);	
	}
	free(line);
	fclose(fp);	
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
			abAppend(ab, &E.row[filerow].render[E.coloff], len);
		}
		
		abAppend(ab, "~", 1);

		abAppend(ab, "\x1b[K", 3);
		abAppend(ab, "\r\n", 2);
	}
}

void editorDrawStatusBar(struct abuf *ab)
{
	abAppend(ab, "\x1b[7m", 4);
	char status[80], rstatus[80];
	int len = snprintf(status, sizeof(status), "%.20s - %d lines",
		E.filename ? E.filename : "[No Name]", E.numrows);
	int rlen = snprintf(rstatus, sizeof(rstatus), "%d/%d",
		E.cy + 1, E.numrows);
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
	int c = editorReadKey();

	switch (c)
	{
		case CTRL_KEY('q'):
			write(STDOUT_FILENO, "\x1b[2J", 4); // Clear the screen
 			write(STDOUT_FILENO, "\x1b[H", 3); 
			exit(0);
			break;

		case HOME_KEY:
			E.cx = 0;
			break;

		case END_KEY:
			if (E.cy < E.numrows)
				E.cx = E.row[E.cy].size;
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
	E.filename = NULL;
	E.statusmsg[0] = '\0';
	E.statusmsg_time = 0;
	
	if (getWindowSize(&E.screenrows, &E.screencols) == -1) die("getWindwowSize");
	E.screenrows -= 2;
}

int main(int argc, char *argv[]) 
{
	enableRawMode(); 
	initEditor();
	if (argc >= 2)
	{
		editorOpen(argv[1]);
	}

	editorSetStatusMessage("HELP: Ctrl-Q = quit");

	while (1) 
	{
		editorRefreshScreen();
		editorProcessKeypress();
	}

	return 0;

}