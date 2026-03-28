CC ?= cc
TARGET := tedit

SRC := $(wildcard src/*.c)
OBJ := $(SRC:.c=.o)
DEP := $(OBJ:.o=.d)

CPPFLAGS += -D_POSIX_C_SOURCE=200809L -D_DEFAULT_SOURCE -D_BSD_SOURCE -D_GNU_SOURCE
CFLAGS ?= -std=c17 -Wall -Wextra -Wpedantic -Wshadow -Wstrict-prototypes -Wconversion
LDFLAGS ?=

.PHONY: all clean format

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(OBJ) $(LDFLAGS) -o $@

src/%.o: src/%.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -MMD -MP -c $< -o $@

clean:
	rm -f $(OBJ) $(DEP) $(TARGET)

-include $(DEP)
