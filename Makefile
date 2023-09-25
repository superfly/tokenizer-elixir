CFLAGS ?= -g -O3
CFLAGS += -Wall -I"$(ERTS_INCLUDE_DIR)" -Isrc/tokenizer_nif.c

KERNEL_NAME := $(shell uname -s)

PRIV_DIR = $(MIX_APP_PATH)/priv
LIB_NAME = $(PRIV_DIR)/tokenizer_nif.so

ifneq ($(CROSSCOMPILE),)
	CFLAGS += -Wno-format-truncation -shared -fPIC -fvisibility=hidden -I/usr/local/include 
	LDFLAGS += -lsodium -L/usr/local/lib
else
	ifeq ($(KERNEL_NAME), Linux)
		CFLAGS += -Wno-format-truncation -shared -fPIC -fvisibility=hidden -I/usr/local/include
		LDFLAGS += -lsodium -L/usr/local/lib
	endif
	ifeq ($(KERNEL_NAME), Darwin)
		CFLAGS += -dynamiclib -undefined dynamic_lookup -I/opt/homebrew/include
		LDFLAGS += -lsodium -L/opt/homebrew/lib
	endif
	ifeq ($(KERNEL_NAME), $(filter $(KERNEL_NAME),OpenBSD FreeBSD NetBSD SunOS))
		CFLAGS += -Wno-format-truncation -shared -fPIC -I/usr/local/include
		LDFLAGS += -lsodium -L/usr/local/lib
	endif
endif

calling_from_make:
	mix compile

all: $(PRIV_DIR) $(LIB_NAME)

$(LIB_NAME): src/tokenizer_nif.c
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@

$(PRIV_DIR):
	mkdir -p $@

clean:
	rm -f $(LIB_NAME)

.PHONY: all clean
