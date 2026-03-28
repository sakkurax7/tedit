#define _POSIX_C_SOURCE 200809L

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "fileIO.h"
#include "input.h"
#include "output.h"
#include "rowOps.h"
#include "syntaxHighlighting.h"
#include "tedit.h"

char *editorRowsToString(size_t *buflen)
{
	size_t total_length = 0;

	for (int row_index = 0; row_index < E.numrows; row_index++) {
		total_length += (size_t)E.row[row_index].size + 1;
	}
	*buflen = total_length;

	char *buffer = malloc(total_length == 0 ? 1 : total_length);
	if (buffer == NULL) {
		die("malloc");
	}

	char *cursor = buffer;
	for (int row_index = 0; row_index < E.numrows; row_index++) {
		memcpy(cursor, E.row[row_index].chars, (size_t)E.row[row_index].size);
		cursor += E.row[row_index].size;
		*cursor++ = '\n';
	}

	return buffer;
}

void editorOpen(const char *filename)
{
	free(E.filename);
	E.filename = strdup(filename);
	if (E.filename == NULL) {
		die("strdup");
	}

	editorSelectSyntaxHighlight();

	FILE *file = fopen(filename, "r");
	if (file == NULL) {
		die("fopen");
	}

	char *line = NULL;
	size_t capacity = 0;
	ssize_t line_length = 0;

	while ((line_length = getline(&line, &capacity, file)) != -1) {
		while (line_length > 0 &&
		       (line[line_length - 1] == '\n' || line[line_length - 1] == '\r')) {
			line_length--;
		}

		editorInsertRow(E.numrows, line, (size_t)line_length);
	}

	free(line);
	fclose(file);
	E.dirty = 0;
}

void editorOpenFromEdit(void)
{
	char *file = editorPrompt("Open file: %s (ESC to cancel)", NULL);
	if (file == NULL) {
		editorSetStatusMessage("Open aborted");
		return;
	}

	editorResetDocument();
	editorOpen(file);
	free(file);
}

void editorSave(void)
{
	if (E.filename == NULL) {
		E.filename = editorPrompt("Save as: %s (ESC to cancel)", NULL);
		if (E.filename == NULL) {
			editorSetStatusMessage("Save aborted");
			return;
		}
		editorSelectSyntaxHighlight();
	}

	size_t len = 0;
	char *buffer = editorRowsToString(&len);

	const int fd = open(E.filename, O_RDWR | O_CREAT, 0644);
	if (fd != -1) {
		if (ftruncate(fd, (off_t)len) != -1 && write(fd, buffer, len) == (ssize_t)len) {
			close(fd);
			free(buffer);
			E.dirty = 0;
			editorSetStatusMessage("%zu bytes written to disk", len);
			return;
		}
		close(fd);
	}

	free(buffer);
	editorSetStatusMessage("Can't save! I/O error: %s", strerror(errno));
}
