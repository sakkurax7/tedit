CC       = gcc
CFLAGS   = -Wall -Wextra -Wno-incompatible-pointer-types -pedantic -std=c99 -D_POSIX_C_SOURCE=200809L
LDFLAGS  = 
OBJFILES = src/tedit.o src/canonical.o src/rowOps.o src/editorOps.o src/fileIO.o src/find.o src/input.o src/output.o src/appendBuffer.o src/syntaxHighlighting.o
TARGET   = tedit

all: $(TARGET)

$(TARGET): $(OBJFILES)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJFILES) $(LDFLAGS)

clean:
	rm -f $(OBJFILES) $(TARGET) *~