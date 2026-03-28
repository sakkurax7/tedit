/*
 * Raw mode setup and escape-sequence decoding for interactive editing.
 */

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <unistd.h>

#include "canonical.h"

static int editorParseCsiSequence(const char *seq, size_t len)
{
	if (len == 1) {
		switch (seq[0]) {
		case 'A':
			return ARROW_UP;
		case 'B':
			return ARROW_DOWN;
		case 'C':
			return ARROW_RIGHT;
		case 'D':
			return ARROW_LEFT;
		case 'H':
			return HOME_KEY;
		case 'F':
			return END_KEY;
		default:
			return '\x1b';
		}
	}

	if (len == 2 && seq[1] == '~') {
		switch (seq[0]) {
		case '1':
		case '7':
			return HOME_KEY;
		case '3':
			return DEL_KEY;
		case '4':
		case '8':
			return END_KEY;
		case '5':
			return PAGE_UP;
		case '6':
			return PAGE_DOWN;
		default:
			return '\x1b';
		}
	}

	int param1 = 0;
	int modifier = 0;
	char final = '\0';

	if (sscanf(seq, "%d;%d%c", &param1, &modifier, &final) == 3 && modifier == 5) {
		switch (final) {
		case 'A':
			return CTRL_ARROW_UP;
		case 'B':
			return CTRL_ARROW_DOWN;
		case 'C':
			return CTRL_ARROW_RIGHT;
		case 'D':
			return CTRL_ARROW_LEFT;
		default:
			return '\x1b';
		}
	}

	return '\x1b';
}

void disableRawMode(void)
{
	if (tcsetattr(STDIN_FILENO, TCSAFLUSH, &E.orig_termios) == -1) {
		die("tcsetattr");
	}
}

void enableRawMode(struct editorConfig *editor)
{
	if (tcgetattr(STDIN_FILENO, &editor->orig_termios) == -1) {
		die("tcgetattr");
	}
	atexit(disableRawMode);

	struct termios raw = editor->orig_termios;

	raw.c_iflag &= (tcflag_t) ~(BRKINT | ICRNL | INPCK | ISTRIP | IXON);
	raw.c_oflag &= (tcflag_t) ~(OPOST);
	raw.c_cflag |= CS8;
	raw.c_lflag &= (tcflag_t) ~(ECHO | ICANON | IEXTEN | ISIG);
	raw.c_cc[VMIN] = 0;
	raw.c_cc[VTIME] = 1;

	if (tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw) == -1) {
		die("tcsetattr");
	}
}

int editorReadKey(void)
{
	char c;

	for (;;) {
		const ssize_t nread = read(STDIN_FILENO, &c, 1);
		if (nread == 1) {
			break;
		}
		if (nread == -1 && errno != EAGAIN) {
			die("read");
		}
	}

	if (c != '\x1b') {
		return c;
	}

	char seq[16];
	size_t len = 0;

	if (read(STDIN_FILENO, &seq[0], 1) != 1) {
		return '\x1b';
	}

	if (seq[0] == 'O') {
		if (read(STDIN_FILENO, &seq[1], 1) != 1) {
			return '\x1b';
		}

		switch (seq[1]) {
		case 'H':
			return HOME_KEY;
		case 'F':
			return END_KEY;
		default:
			return '\x1b';
		}
	}

	if (seq[0] != '[') {
		return '\x1b';
	}

	while (len < sizeof(seq) - 1) {
		if (read(STDIN_FILENO, &seq[len], 1) != 1) {
			return '\x1b';
		}
		if ((seq[len] >= 'A' && seq[len] <= 'Z') || seq[len] == '~') {
			len++;
			break;
		}
		len++;
	}

	seq[len] = '\0';
	return editorParseCsiSequence(seq, len);
}

int getCursorPosition(int *rows, int *cols)
{
	char buf[32];
	size_t i = 0;

	if (write(STDOUT_FILENO, "\x1b[6n", 4) != 4) {
		return -1;
	}

	while (i < sizeof(buf) - 1) {
		if (read(STDIN_FILENO, &buf[i], 1) != 1) {
			break;
		}
		if (buf[i] == 'R') {
			break;
		}
		i++;
	}
	buf[i] = '\0';

	if (buf[0] != '\x1b' || buf[1] != '[') {
		return -1;
	}
	if (sscanf(&buf[2], "%d;%d", rows, cols) != 2) {
		return -1;
	}

	return 0;
}

int getWindowSize(int *rows, int *cols)
{
	struct winsize ws;

	if (ioctl(STDOUT_FILENO, TIOCGWINSZ, &ws) == -1 || ws.ws_col == 0) {
		if (write(STDOUT_FILENO, "\x1b[999C\x1b[999B", 12) != 12) {
			return -1;
		}
		return getCursorPosition(rows, cols);
	}

	*cols = ws.ws_col;
	*rows = ws.ws_row;
	return 0;
}
