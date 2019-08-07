
build: var/mulang/mulang
	./var/mulang/mulang
	cp var/out.sh anytools

var/mulang/mulang:
	mkdir -p var/mulang
	cd var/mulang; git clone 'https://github.com/xsvutils/xsv-mulang.git' ./
	cd var/mulang; make

