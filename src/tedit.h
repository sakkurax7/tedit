#ifndef TEDIT_C_
#define TEDIT_C_

#include <termios.h>

// Defines
#define TEDIT_VERSION "1.0.3"
#define TEDIT_TAB_STOP 8
#define TEDIT_QUIT_TIMES 3
#define TEDIT_OPEN_TIMES 3

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
	PAGE_DOWN
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

#define HL_HIGHLIGHT_NUMERS (1<<0)
#define HL_HIGHLIGHT_STRINGS (1<<1)

// DATA

struct editorSyntax {
	char *filetype;
	char **filematch;
	char **keywords;
	char *singleline_comment_start;
	char *multiline_comment_start;
	char *multiline_comment_end;
	int flags;
};

typedef struct erow 
{
	int idx;
	int size;
	int rsize;
	char *chars;
	char *render;
	unsigned char *hl;
	int hl_open_comment;
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
	int dirty;

	char *filename;
	char statusmsg[80];
	time_t statusmsg_time;

	struct editorSyntax *syntax;
	struct termios orig_termios;
};

struct editorConfig E;


extern struct abuf {
	char *b;
	int len;
};

#define ABUF_INIT {NULL, 0};

void die(const char *s);
void initEditor();


#endif