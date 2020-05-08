# Clean this up

tedit: src/tedit.c
	$(CC) src/tedit.c src/canonical.c src/rowOps.c src/editorOps.c src/fileIO.c src/find.c src/input.c src/output.c src/appendBuffer.c src/syntaxHighlighting.c -o tedit -Wall -Wextra -Wno-incompatible-pointer-types -pedantic -std=c99 -D_POSIX_C_SOURCE=200809L
