# ------------------------------------------------------------------------------

V ?= 0

ifeq ($(V),1)
Q :=
V := --verbose
else
Q := @
V :=
endif

# ------------------------------------------------------------------------------

UPGRADE ?= 1

ifeq ($(UPGRADE),1)
U := --upgrade-all
else
U :=
endif

# ------------------------------------------------------------------------------

NIX_BUILD_ARGS := -I nixos-config=$$NIXOS_CONFIG $(V) -j $$(nproc) --cores $$(nproc)

# ------------------------------------------------------------------------------

default: help

# ------------------------------------------------------------------------------

.PHONY: help

## This help screen.
help:
		@printf "Available targets:\n\n"
		@awk '/^[a-zA-Z\-\_0-9%:\\]+/ { \
		  helpMessage = match(lastLine, /^## (.*)/); \
		  if (helpMessage) { \
			helpCommand = $$1; \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
	  gsub("\\\\", "", helpCommand); \
	  gsub(":+$$", "", helpCommand); \
			printf "  \x1b[32;01m%-35s\x1b[0m %s\n", helpCommand, helpMessage; \
		  } \
		} \
		{ lastLine = $$0 }' $(MAKEFILE_LIST) 2>/dev/null | sort -u
		@printf "\n"

