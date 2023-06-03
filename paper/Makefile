SHELL=/usr/bin/env bash

all:
	mkdir -p build
	pdflatex -output-directory=build paper.tex > /dev/null 2>&1
	bibtex build/paper                         > /dev/null 2>&1
	pdflatex -output-directory=build paper.tex > /dev/null 2>&1
	pdflatex -output-directory=build paper.tex > /dev/null 2>&1

verbose:
	mkdir -p build
	pdflatex -output-directory=build paper.tex
	bibtex build/paper
	pdflatex -output-directory=build paper.tex
	pdflatex -output-directory=build paper.tex

appendix:
	mkdir -p build
	pdflatex -output-directory=build supplementary.tex

quick:
	pdflatex paper

clean:
	@rm -rf build
