# Matt Gormley
# 
# Makefile for LaTeX and Bibtex.  Change the NAME and BIB parameters
# to be the name of the .tex and .bib files respectively.

NAME=reappointment
BIB=mypapers
PDFS=$(NAME).pdf
PDFLIST=$(addprefix build/,$(PDFS))

# All the pdfs in the fig directory.
figures=$(wildcard fig/*.pdf)

all: $(PDFLIST)

$(PDFLIST): build/%.pdf : %.tex
	latexmk -outdir=build -auxdir=build -pdf $<

# Run latexmk and contiuously rebuild. (NAME)
serve: $(NAME).tex $(BIB).bib
	latexmk -outdir=build -auxdir=build -pdf -pvc -bibtex $(NAME).tex

# Run latexmk and contiuously rebuild. Do not stop on errors.
se: $(NAME).tex $(BIB).bib
	latexmk -outdir=build -auxdir=build -pdf -pvc -xelatex -interaction=nonstopmode $(NAME).tex

split:
	pdftk build/$(NAME).pdf cat 3-4 output build/1-cv.pdf
	pdftk build/$(NAME).pdf cat 5-14 output build/2-goals.pdf
	pdftk build/$(NAME).pdf cat 15-18 output build/3-pubs.pdf
	pdftk build/$(NAME).pdf cat 22-24 output build/5-teaching.pdf
	pdftk build/$(NAME).pdf cat 25-30 output build/6-contributions.pdf
	pdftk build/$(NAME).pdf cat 31-32 output build/7-professional.pdf
	pdftk build/$(NAME).pdf cat 33 output build/8-external.pdf
	pdftk build/$(NAME).pdf cat 34 output build/9-service.pdf
	pdftk build/$(NAME).pdf cat 35 output build/10-other.pdf
	pdftk build/$(NAME).pdf cat 36-37 output build/11-advising.pdf

build/4-recent-pubs.pdf: recent-pubs/*.pdf
	pdftk recent-pubs/*.pdf cat output build/4-recent-pubs.pdf

# Clean up the various extra files created by pdflatex
# and by AucTex in Aquamacs. 
clean:
	rm -f $(NAME).aux $(NAME).bbl $(NAME).blg $(NAME).log \
		$(NAME).rel $(NAME).toc $(NAME).synctex.gz \
		$(NAME).out $(NAME).pdf \
		$(NAME).fls $(NAME).fdb_latexmk \
		$(NAME).loa $(NAME).lof $(NAME).lot \
		 _region_.* *~
	rm -rf auto/
	rm -rf build/

clean-biber:
	rm -rf `biber --cache`

# The phony targets ensure that this will run even if a file named
# clean or all is accidently created.
.PHONY: all
.PHONY: clean
.PHONY: serve
.PHONY: serve-cv
.PHONY: serve-bi
.PHONY: serve-co
