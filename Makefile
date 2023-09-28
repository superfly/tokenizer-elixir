CFLAGS ?= -O2 -Wall -Wextra
CFLAGS += -lsodium -I"$(ERTS_INCLUDE_DIR)" -I$(ERL_EI_INCLUDE_DIR) -L"$(ERL_EI_LIBDIR)" -lei

KERNEL_NAME := $(shell uname -s)

PRIV_DIR = $(MIX_APP_PATH)/priv
LIB_NAME = $(PRIV_DIR)/tokenizer_nif.so

CFLAGS += -shared -fPIC -I/usr/local/include/sodium -L/usr/local/lib -Wl,-rpath -Wl,/usr/local/lib

# ifneq ($(CROSSCOMPILE),)
# 	CFLAGS += -Wno-format-truncation -shared -fPIC -fvisibility=hidden -L/usr/lib -Wl,-R/usr/lib
# else
# 	ifeq ($(KERNEL_NAME), Linux)
# 	endif
# 	ifeq ($(KERNEL_NAME), Darwin)
# 		CFLAGS += -dynamiclib -undefined dynamic_lookup -I/opt/homebrew/include -L/opt/homebrew/lib
# 	endif
# 	ifeq ($(KERNEL_NAME), $(filter $(KERNEL_NAME),OpenBSD FreeBSD NetBSD SunOS))
# 		CFLAGS += -Wno-format-truncation -shared -fPIC
# 	endif
# endif

all: $(PRIV_DIR) $(LIB_NAME)

$(LIB_NAME): src/tokenizer_nif.c
	$(CC) $(CFLAGS) $^ -o $@

$(PRIV_DIR):
	mkdir -p $@

clean:
	rm -f $(LIB_NAME)

.PHONY: all clean
