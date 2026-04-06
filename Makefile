# Build everything: all chapter articles + the full dissertation.
#
# LaTeX editors ignore this file entirely — they follow % !TEX root
# directives instead. This is only used when you explicitly run `make`.
#
# Usage:
#   make              Build all chapter articles and the dissertation
#   make articles     Build all chapter articles only
#   make dissertation Build the full dissertation only
#   make chapter1     Build just chapter 1's article
#   make clean        Remove build artifacts

CHAPTERS := chapter1 chapter2 chapter3

# Triple-pass build pattern: pdflatex -> biber -> pdflatex -> pdflatex
define build
	cd $(1) && pdflatex $(2) && biber $(basename $(2)) && pdflatex $(2) && pdflatex $(2)
endef

.PHONY: all articles dissertation $(CHAPTERS) clean

all: articles dissertation

articles: $(CHAPTERS)

$(CHAPTERS):
	$(call build,$@/article,$@-article.tex)

dissertation:
	$(call build,.,dissertation.tex)

clean:
	rm -f *.aux *.bbl *.bcf *.blg *.log *.out *.run.xml *.toc *.lof *.lot
	@for ch in $(CHAPTERS); do \
		rm -f $$ch/article/*.aux $$ch/article/*.bbl $$ch/article/*.bcf \
		      $$ch/article/*.blg $$ch/article/*.log $$ch/article/*.out \
		      $$ch/article/*.run.xml; \
	done
