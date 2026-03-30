# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

UC Davis PhD dissertation template using LaTeX `memoir` class with a dual-compilation architecture. Each chapter compiles both as part of the full dissertation and as a standalone article. Domain: philosophy / modal logic / deontic logic.

## Build Commands

All builds use the triple-pass pattern: `pdflatex` -> `biber` -> `pdflatex` -> `pdflatex`.

**Full dissertation** (from project root):
```bash
pdflatex dissertation.tex && biber dissertation && pdflatex dissertation.tex && pdflatex dissertation.tex
```

**Standalone chapter article** (from chapter's `article/` directory):
```bash
cd chapter1/article
pdflatex chapter1-article.tex && biber chapter1-article && pdflatex chapter1-article.tex && pdflatex chapter1-article.tex
```

## Prerequisites

- TeX distribution with `pdflatex` and `biber` (TeX Live, MacTeX, or MiKTeX)
- The `french-logic` package (excluded by `.gitignore`; must be symlinked or installed in local texmf)

## Architecture

### Dual-Compilation Model

Chapter content files (e.g., `chapter1/chapter1.tex`) contain **only content** -- no `\documentclass`, no preamble, no `\begin{document}`. Each is `\input`ed in two contexts:

1. **dissertation.tex** wraps it in `\chapter{...}` under `memoir`
2. **article wrappers** (`chapter1/article/chapter1-article.tex`) provide their own `\documentclass{article}` preamble

### TEX Root Directives

Each chapter file starts with `% !TEX root = ./article/<name>-article.tex` (builds the standalone article from the editor). Frontmatter files point to `../dissertation.tex`.

### Section Levels

Use `\section` as the top-level heading inside chapter content files. In the dissertation this nests under `\chapter`; in the article wrapper it nests under the wrapper's `\section{Introduction}`.

### Bibliography

Single `refs.bib` at project root, shared by all documents. Article wrappers reference it as `../../refs.bib`. The dissertation uses `\nocite{*}` (prints all entries); articles print only cited entries.

### Adding a New Chapter

1. `mkdir -p chapterN/article`
2. Create `chapterN/chapterN.tex` with `% !TEX root = ./article/chapterN-article.tex` directive
3. Copy an existing article wrapper to `chapterN/article/chapterN-article.tex`, update `\title`, `\input` path, and `\addbibresource` path (`../../refs.bib`)
4. Add `\chapter{...}\label{ch:chapterN}` and `\input{./chapterN/chapterN.tex}` to `dissertation.tex` before `\backmatter`

### Changing Title/Author/Committee

Must be updated in three places: `dissertation.tex`, `frontmatter/title-page.tex`, and each article wrapper.
