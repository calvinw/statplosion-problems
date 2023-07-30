SHELL:=/bin/bash
SOURCES=$(shell find . -name "*.Rmd")
SOURCES=$(shell find . -name "*.Rmd")
SOURCES= solution/ScatterplotSolution.Rmd solution/NormalRightTailSolution.Rmd

HTML_FILES = $(SOURCES:%.Rmd=%.html)
PDF_FILES = $(SOURCES:%.Rmd=%.pdf)

all : $(HTML_FILES)
	@echo All html files are now up to date

clean :
	@echo Removing html, pdf, md files...	
	rm -f $(HTML_FILES) $(PDF_FILES)
	rm -rf *_files question/*_files solution/*_files 

pdfs: $(PDF_FILES)

htmls: $(HTML_FILES)

%.html : %.Rmd
	quarto render $< --to html

%.pdf : %.Rmd
	quarto render $< --to pdf

.PHONY: all clean
