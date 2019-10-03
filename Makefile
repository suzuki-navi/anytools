
build: anytools

anytools: var/single-out
	cp var/single-out anytools

var/single-out: FORCE var/mulang/mulang src/main-2.sh
	@ ./var/mulang/mulang

var/mulang/mulang:
	mkdir -p var/mulang
	cd var/mulang; git clone 'https://github.com/suzuki-navi/mulang.git' ./; git checkout 84bbccd
	cd var/mulang; make

src/main-2.sh: src/build-main.sh src/build-parser.pl src/main-template.sh src/list.txt
	bash src/build-main.sh < src/main-template.sh > $@.tmp
	mv $@.tmp $@

FORCE:

