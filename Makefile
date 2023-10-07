################################################################################
V ?= 0
ifeq ($(V),1)
Q :=
V := --verbose
else
Q := @
V :=
endif

################################################################################
UPGRADE ?= 1
ifeq ($(UPGRADE),1)
U := --upgrade-all
else
U :=
endif

################################################################################

NIX_BUILD_ARGS := -I nixos-config=$$NIXOS_CONFIG $(V) -j $$(nproc) --cores $$(nproc)
NIXOS_REBUILD_ARGS := $(NIX_BUILD_ARGS) $(U) --fallback
HOME_MANAGER_ARGS := $(NIX_BUILD_ARGS) -f $$HOME_MANAGER_CONFIG

################################################################################

default: help

## Test, then install the configuration.
all: config build build-vm simulate install

################################################################################

.PHONY: rebuild build build-nixos build-user build-vm vm verify simulate  install-nixos install-user install consent config

consent:
	$(Q)# Test if 'sudo' is cached, and prompt for password otherwise.
	$(Q)sudo -n true 2>/dev/null || sudo -v

## Rescan hardware.
config: consent
	$(Q)sudo nixos-generate-config --dir $$TOP

## Recompile but do not switch to the resulting generation.
rebuild: build

## Compile a user and a system installation.
build: build-nixos build-user

## Compile a NixOS root filesystem.
build-nixos:
	$(Q)nixos-rebuild build $(NIXOS_REBUILD_ARGS) --fast

## Compile a Home Manager generation.
build-user:
	$(Q)[[ $$EUID -eq 0 ]] || \
		home-manager build $(HOME_MANAGER_ARGS) -L

## Build a QEMU VM of the image.
build-vm:
	$(Q)nixos-rebuild build-vm $(NIXOS_REBUILD_ARGS)

## Same as `build-nixos`.
nixos: build-nixos

## Same as `build-user`.
user: build-user

## Same as `build-vm`.
vm: build-vm

## Try out a QEMU VM of the image!.
simulate: vm
	$(Q)$$PWD/result/bin/run-$$(hostname)-vm

## Fix corruptions in packages.
repair:
	$(Q)sudo nixos-rebuild build $(NIXOS_REBUILD_ARGS) --fast --repair

## Install a NixOS root filesystem.
install-nixos: config
	$(Q)sudo nixos-rebuild switch $(NIXOS_REBUILD_ARGS) --fast

## Install a Home Manager generation.
install-user: build-user
	$(Q)[[ $$EUID -eq 0 ]] || home-manager switch $(HOME_MANAGER_ARGS) -L

## Deploy the config to the live system.
install: install-nixos install-user

################################################################################

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

################################################################################

.PHONY:  clean mrproper --gc --purge

## Delete unreferenced package files.
clean: --gc
	$(Q)git clean -fd

## Also delete stale generations.
mrproper: --purge
	$(Q)git clean -fdx

--gc:
	$(Q)nix-collect-garbage $(V) -j $$(nproc) --cores $$(nproc)

--purge:
	$(Q)nix-collect-garbage -d $(V) -j $$(nproc) --cores $$(nproc)
