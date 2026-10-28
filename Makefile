CC := clang
INCDIR := inc
CFLAGS := -Wall -Werror -Wextra -Wpedantic -I$(INCDIR) -c
CFLAGS_DBG := $(CFLAGS) -g -fsanitize=address
LFLAGS :=
LFLAGS_DBG := $(LFLAGS) -lasan

SRCDIR := src
BINDIR := bin
OBJDIR := $(BINDIR)/obj
OBJREL := $(OBJDIR)/release
OBJDBG := $(OBJDIR)/debug
BUILDD := $(BINDIR)/build
RELDIR := $(BUILDD)/release
DBGDIR := $(BUILDD)/debug

TGTNAM := mylsbootstrap
TGTREL := $(RELDIR)/$(TGTNAM)
TGTDBG := $(DBGDIR)/$(TGTNAM)

SRCS := $(shell find $(SRCDIR) -name "*.c")
OBJSREL := $(patsubst $(SRCDIR)/%.c,$(OBJREL)/%.o,$(SRCS))
OBJSDBG := $(patsubst $(SRCDIR)/%.c,$(OBJDBG)/%.o,$(SRCS))

.PHONY: all re clean fclean debug

all: $(TGTREL)

debug: $(TGTDBG)

$(OBJREL)/%.o:$(SRCDIR)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) $< -o $@

$(OBJDBG)/%.o:$(SRCDIR)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS_DBG) $< -o $@

$(TGTREL): $(OBJSREL)
	@mkdir -p $(@D)
	$(CC) $^ -o $@

$(TGTDBG): $(OBJSDBG)
	mkdir -p $(@D)
	$(CC) $(LFLAGS_DBG) $^ -o $@

clean:
	rm -rf $(OBJDIR)

fclean:
	rm -rf $(BINDIR)

re: fclean all
