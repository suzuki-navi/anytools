
build: anytools

anytools: var/out.sh
	cp var/out.sh anytools

.PHONY: var/out.sh

var/out.sh: var/mulang/mulang src/main-2.sh
	./var/mulang/mulang

var/mulang/mulang:
	mkdir -p var/mulang
	cd var/mulang; git clone 'https://github.com/xsvutils/xsv-mulang.git' ./
	cd var/mulang; make

src/main-2.sh: src/build-main.sh src/build-parser.pl src/main-template.sh src/list.txt
	bash src/build-main.sh < src/main-template.sh > src/main-2.sh

