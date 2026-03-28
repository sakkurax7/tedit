#include <ctype.h>
#include <stdlib.h>
#include <string.h>

#include "syntaxHighlighting.h"

const char *const C_HL_extensions[] = {".c", ".cpp", ".h", NULL};
const char *const C_HL_keywords[] = {
	"switch", "if",      "while",    "for",    "break", "continue", "return",
	"else",   "struct",  "union",    "typedef","static","enum",     "class",
	"case",   "int|",    "long|",    "double|","float|","char|",    "unsigned|",
	"signed|","void|",   NULL
};

const struct editorSyntax HLDB[] = {{
	"c",
	C_HL_extensions,
	C_HL_keywords,
	"//",
	"/*",
	"*/",
	HL_HIGHLIGHT_NUMBERS | HL_HIGHLIGHT_STRINGS,
}};

#define HLDB_ENTRIES ((int)(sizeof(HLDB) / sizeof(HLDB[0])))

int is_separator(int c)
{
	return isspace(c) || c == '\0' || strchr(",.()+-/*=~%<>[];", c) != NULL;
}

void editorUpdateSyntax(erow *row)
{
	row->highlight = realloc(row->highlight, (size_t)row->render_size);
	if (row->render_size > 0 && row->highlight == NULL) {
		die("realloc");
	}

	memset(row->highlight, HL_NORMAL, (size_t)row->render_size);

	if (E.syntax == NULL) {
		return;
	}

	const char *const *keywords = E.syntax->keywords;
	const char *single_comment = E.syntax->singleline_comment_start;
	const char *multi_comment_start = E.syntax->multiline_comment_start;
	const char *multi_comment_end = E.syntax->multiline_comment_end;

	const int scs_len = single_comment != NULL ? (int)strlen(single_comment) : 0;
	const int mcs_len = multi_comment_start != NULL ? (int)strlen(multi_comment_start) : 0;
	const int mce_len = multi_comment_end != NULL ? (int)strlen(multi_comment_end) : 0;

	int prev_sep = 1;
	int in_string = 0;
	bool in_comment = row->index > 0 && E.row[row->index - 1].open_comment;

	for (int render_index = 0; render_index < row->render_size;) {
		const char current = row->render[render_index];
		const unsigned char previous_highlight =
			render_index > 0 ? row->highlight[render_index - 1] : HL_NORMAL;

		if (scs_len > 0 && !in_string && !in_comment &&
			strncmp(&row->render[render_index], single_comment, (size_t)scs_len) == 0) {
			memset(&row->highlight[render_index], HL_COMMENT,
			       (size_t)(row->render_size - render_index));
			break;
		}

		if (mcs_len > 0 && mce_len > 0 && !in_string) {
			if (in_comment) {
				row->highlight[render_index] = HL_MLCOMMENT;
				if (strncmp(&row->render[render_index], multi_comment_end, (size_t)mce_len) == 0) {
					memset(&row->highlight[render_index], HL_MLCOMMENT, (size_t)mce_len);
					render_index += mce_len;
					in_comment = false;
					prev_sep = 1;
					continue;
				}

				render_index++;
				continue;
			}

			if (strncmp(&row->render[render_index], multi_comment_start, (size_t)mcs_len) == 0) {
				memset(&row->highlight[render_index], HL_MLCOMMENT, (size_t)mcs_len);
				render_index += mcs_len;
				in_comment = true;
				continue;
			}
		}

		if ((E.syntax->flags & HL_HIGHLIGHT_STRINGS) != 0) {
			if (in_string) {
				row->highlight[render_index] = HL_STRING;
				if (current == '\\' && render_index + 1 < row->render_size) {
					row->highlight[render_index + 1] = HL_STRING;
					render_index += 2;
					continue;
				}
				if (current == in_string) {
					in_string = 0;
				}
				render_index++;
				prev_sep = 1;
				continue;
			}

			if (current == '"' || current == '\'') {
				in_string = current;
				row->highlight[render_index] = HL_STRING;
				render_index++;
				continue;
			}
		}

		if ((E.syntax->flags & HL_HIGHLIGHT_NUMBERS) != 0 &&
			((isdigit((unsigned char)current) && (prev_sep || previous_highlight == HL_NUMBER)) ||
			 (current == '.' && previous_highlight == HL_NUMBER))) {
			row->highlight[render_index] = HL_NUMBER;
			render_index++;
			prev_sep = 0;
			continue;
		}

		if (prev_sep) {
			for (int keyword_index = 0; keywords[keyword_index] != NULL; keyword_index++) {
				const size_t keyword_len = strlen(keywords[keyword_index]);
				const bool is_type_keyword = keywords[keyword_index][keyword_len - 1] == '|';
				const size_t match_len = is_type_keyword ? keyword_len - 1 : keyword_len;

				if (strncmp(&row->render[render_index], keywords[keyword_index], match_len) == 0 &&
					is_separator(row->render[render_index + (int)match_len])) {
					memset(&row->highlight[render_index],
					       is_type_keyword ? HL_KEYWORD2 : HL_KEYWORD1, match_len);
					render_index += (int)match_len;
					prev_sep = 0;
					goto next_character;
				}
			}
		}

		prev_sep = is_separator(current);
		render_index++;

next_character:
		;
	}

	const bool changed = row->open_comment != in_comment;
	row->open_comment = in_comment;
	if (changed && row->index + 1 < E.numrows) {
		editorUpdateSyntax(&E.row[row->index + 1]);
	}
}

int editorSyntaxToColor(int hl)
{
	switch (hl) {
	case HL_COMMENT:
	case HL_MLCOMMENT:
		return 36;
	case HL_KEYWORD1:
		return 33;
	case HL_KEYWORD2:
		return 32;
	case HL_STRING:
		return 35;
	case HL_NUMBER:
		return 31;
	case HL_MATCH:
		return 34;
	default:
		return 37;
	}
}

void editorSelectSyntaxHighlight(void)
{
	E.syntax = NULL;
	if (E.filename == NULL) {
		return;
	}

	const char *extension = strrchr(E.filename, '.');

	for (int db_index = 0; db_index < HLDB_ENTRIES; db_index++) {
		const struct editorSyntax *syntax = &HLDB[db_index];
		for (int match_index = 0; syntax->filematch[match_index] != NULL; match_index++) {
			const bool is_extension = syntax->filematch[match_index][0] == '.';
			if ((is_extension && extension != NULL &&
			     strcmp(extension, syntax->filematch[match_index]) == 0) ||
			    (!is_extension && strstr(E.filename, syntax->filematch[match_index]) != NULL)) {
				E.syntax = syntax;

				for (int row_index = 0; row_index < E.numrows; row_index++) {
					editorUpdateSyntax(&E.row[row_index]);
				}
				return;
			}
		}
	}
}
