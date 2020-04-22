// Includes

#include <ctype.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <termios.h>
#include <unistd.h>

// Defines
#define CTRL_KEY(k) ((k) & 0x1f)

// DATA

struct editorConfig {
	int screenrows;
	int screencols;

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

char editorReadKey()
{
	int nread;
	char c;

	while ((nread = read(STDIN_FILENO, &c, 1)) != 1)
	{
		if (nread == -1 && errno != EAGAIN) die("read");
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

// Output
void editorDrawRows()
{
	int i; 

	for (i = 0; i < E.screenrows; i++)
	{
		write(STDOUT_FILENO, "~\r\n", 3);
	}
}

void editorRefreshScreen()
{
	write(STDOUT_FILENO, "\x1b[2J", 4);
	write(STDOUT_FILENO, "\x1b[H", 3);

	editorDrawRows();

	write(STDOUT_FILENO, "\x1b[H", 3);
}

// Input

void editorProcessKeypress()
{
	char c = editorReadKey();

	switch (c)
	{
		case CTRL_KEY('q'):
			write(STDOUT_FILENO, "\x1b[2J", 4); // Clear the screen
 			write(STDOUT_FILENO, "\x1b[H", 3); 
			exit(0);
			break;
	}
}

// Init

void initEditor()
{
	if (getWindowSize(&E.screenrows, &E.screencols) == -1) die("getWindwowSize");
}

int main() 
{
	enableRawMode(); 
	initEditor();

	while (1) 
	{
		editorRefreshScreen();
		editorProcessKeypress();
	}

	return 0;

}
