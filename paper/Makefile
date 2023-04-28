SHELL=/usr/bin/env bash

all:
	mkdir -p build
	xelatex -output-directory=build paper.tex > /dev/null 2>&1
	biber build/paper                         > /dev/null 2>&1
	xelatex -output-directory=build paper.tex > /dev/null 2>&1
	xelatex -output-directory=build paper.tex > /dev/null 2>&1

verbose:
	mkdir -p build
	xelatex -output-directory=build paper.tex
	biber build/paper
	xelatex -output-directory=build paper.tex
	xelatex -output-directory=build paper.tex

appendix:
	mkdir -p build
	pdflatex -output-directory=build supplementary.tex

quick:
	pdflatex paper

clean:
	@rm -rf build
