ODT = $(shell find . -name "*.odt")

all: $(ODT)

%.odt: %.txt
	odt2txt.exe --width=-1 --output=$< $@