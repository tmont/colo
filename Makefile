PREFIX ?= /usr/local/bin
completionDir = /etc/bash_completion.d

install: colo colo_completion.bash
	cp colo $(PREFIX)/colo
	cp colo_completion.bash $(completionDir)/colo

uninstall:
	rm -f $(PREFIX)/colo
	rm -f $(completionDir)/colo

.PHONY: install uninstall
