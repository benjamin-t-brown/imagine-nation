ODT = $(shell find . -name "*.odt")
TXT = $(ODT:.odt=.txt)
EMP = $(ODT:.odt=)

all: $(EMP) bin/out.lua
	echo "done"

.PHONY: $(ODT)

%:
	odt2txt.exe --width=70 --output=$*.txt $*.odt
	node compile-text.js $*.txt
	rm -f $(TXT)

bin/out.lua:
	lua.exe bin/pack.lua . > bin/out.lua

cleantxt:
	rm -f $(TXT)
	rm -f bin/out.lua

cleanlua:
	echo 'clean lua'

clean: cleantxt
	