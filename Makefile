PREFIX ?= $(HOME)/.local
BIN_DIR := $(PREFIX)/bin

PROG_NAME := foobar
PROG_VERSION := $(shell cat ./VERSION | tr -d '[:space:]')

SRC_DIR := ./src
BUILD_DIR := ./build

ARGS += -collection:src=$(SRC_DIR)
ARGS += -out:$(BUILD_DIR)/$(PROG_NAME)
ARGS += -build-mode:exe
ARGS += -vet
ARGS += -disallow-do
ARGS += -warnings-as-errors
ARGS += -use-separate-modules
ARGS += -define:PROG_NAME=$(PROG_NAME)
ARGS += -define:PROG_VERSION=$(PROG_VERSION)
ifneq ($(NON_NIX),1)
	ARGS += -define:RAYLIB_SYSTEM=true
endif

.PHONY: release debug install clean mkdir

debug: mkdir
	odin build $(SRC_DIR) $(ARGS) -debug

release: mkdir
	odin build $(SRC_DIR) $(ARGS) -o:speed

install:
	install -Dm755 $(BUILD_DIR)/$(PROG_NAME) -t $(BIN_DIR)

clean:
	rm -r $(BUILD_DIR)

mkdir:
ifeq ($(wildcard $(BUILD_DIR)/.),)
	mkdir -p $(BUILD_DIR)
endif
