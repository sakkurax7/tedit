tedit: src/tedit.c
	$(CC) src/tedit.c src/canonical.c src/rowOps.c src/editorOps.c src/fileIO.c -o tedit -Wall -Wextra -pedantic -std=c99 -D_POSIX_C_SOURCE=200809L
