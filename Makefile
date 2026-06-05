# Build everything: all chapter articles, all chapter beamer decks, and the
# full dissertation.
#
# LaTeX editors ignore this file entirely — they follow % !TEX root directives
# instead. This is only used when you explicitly run `make`.
#
# Usage:
#   make                Build all chapter articles, beamer decks, and the dissertation
#   make articles       Build all chapter articles only
#   make beamer         Build all chapter beamer decks only
#   make dissertation   Build the full dissertation only
#   make chapter1       Build just chapter 1's article
#   make chapter1-beamer Build just chapter 1's beamer deck
#   make clean          Remove build artifacts

CHAPTERS := chapter1 chapter2 chapter3

# Triple-pass build: pdflatex -> biber -> pdflatex -> pdflatex.
# TEXINPUTS is prepended with the project root ($(CURDIR)) so the bundled
# philogic.sty is found even when building from a subdirectory two levels down.
# (Editor builds don't use this Makefile — see the README for the texmf option.)
define build
	cd $(1) && export TEXINPUTS="$(CURDIR):$$TEXINPUTS" && pdflatex $(2) && biber $(basename $(2)) && pdflatex $(2) && pdflatex $(2)
endef

.PHONY: all articles beamer dissertation $(CHAPTERS) $(CHAPTERS:=-beamer) clean

all: articles beamer dissertation

articles: $(CHAPTERS)

beamer: $(CHAPTERS:=-beamer)

$(CHAPTERS):
	$(call build,$@/article,$@-article.tex)

$(CHAPTERS:=-beamer): %-beamer:
	$(call build,$*/beamer,$*-beamer.tex)

dissertation:
	$(call build,.,dissertation.tex)

clean:
	rm -f *.aux *.bbl *.bcf *.blg *.log *.out *.run.xml *.toc *.lof *.lot
	@for ch in $(CHAPTERS); do \
		rm -f $$ch/article/*.aux $$ch/article/*.bbl $$ch/article/*.bcf \
		      $$ch/article/*.blg $$ch/article/*.log $$ch/article/*.out \
		      $$ch/article/*.run.xml $$ch/article/*.toc \
		      $$ch/beamer/*.aux $$ch/beamer/*.bbl $$ch/beamer/*.bcf \
		      $$ch/beamer/*.blg $$ch/beamer/*.log $$ch/beamer/*.out \
		      $$ch/beamer/*.run.xml $$ch/beamer/*.nav $$ch/beamer/*.snm \
		      $$ch/beamer/*.toc $$ch/beamer/*.vrb; \
	done
