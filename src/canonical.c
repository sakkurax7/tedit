/*
 *  Canonical mode, or cooked mode makes it so that every character that 
 *  is entered gets echoed. We obviously don't want this for a text editor, 
 *  so we must enter raw mode, which makes the terminal not echo everything
 *  that's typed. When the script starts it should enter raw mode, and when
 *  it ends it should exit so the user isn't stuck in raw mode.
 */

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include "tedit.h"

void disableRawMode()
{
	if (tcsetattr(STDIN_FILENO, TCSAFLUSH, &E.orig_termios) == -1)
		die("tcsetattr");
}

void enableRawMode(struct editorConfig E) 
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