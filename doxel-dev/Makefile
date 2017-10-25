INSTALL_PREFIX ?= /usr/local

all: build

build:
	./build.sh

install:
	install -D bin/* ${INSTALL_PREFIX}/bin/.

.PHONY: build install
