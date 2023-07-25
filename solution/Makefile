SHELL:=/bin/bash
SOURCES=$(shell find . -name "*.Rmd")

HTML_FILES = $(SOURCES:%.Rmd=%.html)
PDF_FILES = $(SOURCES:%.Rmd=%.pdf)

all : $(HTML_FILES)
	@echo All html files are now up to date

clean :
	@echo Removing html, pdf, files...	
	rm -f $(HTML_FILES) $(PDF_FILES)
	rm -rf *_files 

pdfs: $(PDF_FILES)

htmls: $(HTML_FILES)

%.html : %.Rmd
	quarto render $< --to html

%.pdf : %.Rmd
	quarto render $< --to pdf

.PHONY: all clean
