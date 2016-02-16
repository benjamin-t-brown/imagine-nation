ODT = $(shell find . -name "*.odt")
TXT = $(ODT:.odt=.txt)
EMP = $(ODT:.odt=)

all: $(EMP)
	echo "done"

.PHONY: $(ODT)

%:
	odt2txt.exe --width=70 --output=$*.txt $*.odt
	node compile-text.js $*.txt

clean:
	rm -f $(TXT)