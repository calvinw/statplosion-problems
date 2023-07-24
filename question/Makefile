SHELL:=/bin/bash
SOURCES=$(shell find . -maxdepth 1 -name "*.Rmd")

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
	@Rscript -e 'library(knitr)' \
	         -e 'library(rmarkdown)' \
	         -e 'library(statplosion)' \
	         -e 'opts_knit[["set"]](progress=FALSE)' \
	         -e 'opts_chunk[["set"]](echo=FALSE)' \
             -e 'example_label<-function(s){}' \
 	         -e 'solution<-T' \
	         -e 'render("$<", "html_document", output_options=list(self_contained=F))'

%.pdf : %.Rmd
	@Rscript -e 'library(knitr)'  \
	         -e 'library(rmarkdown)' \
	         -e 'library(statplosion)' \
	         -e 'opts_knit[["set"]](progress=FALSE)' \
	         -e 'opts_chunk[["set"]](echo=FALSE)' \
             -e 'example_label<-function(s){}' \
	     -e 'solution<-T' \
	         -e 'render("$<","pdf_document", output_options=list(extra_dependencies="float"))'

.PHONY: all clean
