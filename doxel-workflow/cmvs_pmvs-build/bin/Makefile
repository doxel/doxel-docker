PREFIX ?= /usr/local
SHELL := /bin/bash

all: clean build

clean:
	find . -maxdepth 1 -type l -exec rm \{} \;

build:
	docker run --rm=true -it cmvs_pmvs-build find /home/doxel/local/bin/ -type f -printf '%f\0' \
	| parallel --gnu --null ln -sf docker-cmvspmvs {}

install:
	find -maxdepth 1 -name 'docker-cmvspmvs' -o -type l -exec install \{} ${PREFIX}/bin/\{} \;

uninstall:
	find -maxdepth 1 -name 'docker-cmvspmvs' -o type l -exec rm ${PREFIX}/bin/\{} \;

.PHONY: all clean build install uninstall
