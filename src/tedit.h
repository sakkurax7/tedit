#ifndef TEDIT_H
#define TEDIT_H

#include <stdbool.h>
#include <stddef.h>
#include <termios.h>
#include <time.h>

#define TEDIT_VERSION "1.1.0"
#define CTRL_KEY(k) ((k) & 0x1f)

enum editorKey {
	BACKSPACE = 127,
	ARROW_LEFT = 1000,
	ARROW_RIGHT,
	ARROW_UP,
	ARROW_DOWN,
	DEL_KEY,
	HOME_KEY,
	END_KEY,
	PAGE_UP,
	PAGE_DOWN,
	CTRL_ARROW_LEFT,
	CTRL_ARROW_RIGHT,
	CTRL_ARROW_UP,
	CTRL_ARROW_DOWN
};

enum editorHighlight {
	HL_NORMAL = 0,
	HL_COMMENT,
	HL_MLCOMMENT,
	HL_KEYWORD1,
	HL_KEYWORD2,
	HL_STRING,
	HL_NUMBER,
	HL_MATCH
};

enum editorHighlightFlags {
	HL_HIGHLIGHT_NUMBERS = 1 << 0,
	HL_HIGHLIGHT_STRINGS = 1 << 1
};

struct editorSyntax {
	const char *filetype;
	const char *const *filematch;
	const char *const *keywords;
	const char *singleline_comment_start;
	const char *multiline_comment_start;
	const char *multiline_comment_end;
	int flags;
};

typedef struct editorRow {
	int index;
	int size;
	int render_size;
	char *chars;
	char *render;
	unsigned char *highlight;
	bool open_comment;
} erow;

struct editorSettings {
	int tab_stop;
	int quit_confirmations;
	int open_confirmations;
	bool show_line_numbers;
	bool soft_wrap;
	bool soft_indent;
	bool auto_indent;
};

struct editorConfig {
	int cx;
	int cy;
	int rx;
	int preferred_rx;
	int rowoff;
	int coloff;
	int screenrows;
	int screencols;
	int numrows;
	erow *row;
	int dirty;
	char *filename;
	char statusmsg[80];
	time_t statusmsg_time;
	const struct editorSyntax *syntax;
	struct termios orig_termios;
	struct editorSettings settings;
};

struct abuf {
	char *b;
	size_t len;
};

extern struct editorConfig E;

#define ABUF_INIT \
	{ \
		NULL, 0 \
	}

void die(const char *message);
void initEditor(void);
void editorResetDocument(void);

#endif
