# UC Davis Philosophy Dissertation Template

A LaTeX dissertation template for UC Davis philosophy PhD students, built on the `memoir` document class with a dual-compilation architecture: each chapter compiles both as part of the full dissertation and as a standalone article.

Adapted and extended by Brandon Hopkins (Philosophy, UC Davis) from an earlier template by the Galois Group (see [Acknowledgements](#acknowledgements)).


## Getting Started

This template is built for local compilation and requires a TeX distribution with `pdflatex` and `biber` (e.g., TeX Live, MacTeX, MiKTeX).

### Overleaf

The template has been tested on Overleaf. Standalone article compilations in the chapter `article/` subdirectories work, provided `french-logic.sty` is placed in the project root directory. The full dissertation does not currently compile on Overleaf; the problem may simply be that the free Overleaf plan times out before the triple-pass build completes, even though the compilation is otherwise correct. Further work would be needed to get top-level compilation working on Overleaf.

This template depends on the [`french-logic`](https://github.com/bphopkins/configs/blob/main/latex/french-logic/french-logic.sty) package, which is **not included in this repository** and must be downloaded separately from the link above.  It bundles the structural packages the template needs (`biblatex` with biber, `hyperref`, `setspace`) together with theorem environments, notation macros, and other content-level features used by the example chapters.  You can keep this dependency or replace it --- see the two paths below.

### With `french-logic` (default)

The `.gitignore` excludes `.sty` files, so `french-logic.sty` must be made available separately:

- **Copy** into the project root: place `french-logic.sty` directly in the project directory.  This works for the full dissertation build.  For standalone article builds, which compile from `chapter/article/` subdirectories two levels down, TeX will not find the file in the project root automatically; you would need to either set `TEXINPUTS=../../:` before the `pdflatex` command or change `\usepackage{french-logic}` to `\usepackage{../../french-logic}` in each article wrapper.
- **Install** in your local texmf tree: copy to `~/texmf/tex/latex/french-logic/french-logic.sty` and run `texhash ~/texmf`
- **Symlink** into the project directory: `ln -s /path/to/french-logic.sty .`

Either way, changes to the `.sty` file take effect on the next compilation with no reinstall needed.

Then build:

```bash
pdflatex dissertation.tex && biber dissertation && pdflatex dissertation.tex && pdflatex dissertation.tex
```

### Without `french-logic`

The template's dual-compilation architecture does not depend on `french-logic`.  The only packages the template structure requires are `biblatex` (with biber backend), `hyperref`, and `setspace`.  Everything else `french-logic` provides --- theorem environments, modal and deontic notation, custom list environments, and so on --- is used only by the example chapter content.

To remove the dependency:

1. In `dissertation.tex` and each article wrapper (`*/article/*-article.tex`), replace:
   ```latex
   \usepackage{french-logic}
   ```
   with:
   ```latex
   \usepackage[backend=biber]{biblatex}
   \usepackage{hyperref}
   \usepackage{setspace}
   ```

2. Add any packages your own content requires (e.g., `amsthm` for theorem environments, `amsmath` for mathematics, `enumitem` for custom lists).

3. Replace the example chapter content and bibliography entries with your own.

Everything else --- the `memoir` class setup, the `\input` structure, the bibliography pipeline (`\addbibresource`, `\printbibliography`, the `\AtEveryBibitem` block), and the triple-pass build command --- works identically without `french-logic`.


## Project Structure

```
dissertation-template/
├── dissertation.tex              Main driver file
├── refs.bib                      Master bibliography (biber backend)
├── .gitignore
├── README.md
│
├── frontmatter/
│   ├── title-page.tex            UC Davis title page
│   ├── abstract.tex
│   └── acknowledgments.tex
│
├── introduction/
│   ├── introduction.tex          Chapter content
│   └── article/
│       └── introduction-article.tex   Standalone article wrapper
│
├── chapter1/ ... chapter3/       Same structure as introduction/
│
└── conclusion/
    ├── conclusion.tex
    └── article/
        └── conclusion-article.tex
```


## Architecture

### Dual-Compilation Model

Each chapter lives in its own directory as a single `.tex` file containing **only content** --- no `\documentclass`, no `\begin{document}`, no preamble.  This file is `\input`ed in two contexts:

1. **Full dissertation:** `dissertation.tex` wraps it in a `\chapter{...}` heading under the `memoir` class.
2. **Standalone article:** A wrapper in the chapter's `article/` subdirectory provides its own `\documentclass{article}` preamble and wraps the content in a `\section{Introduction}` heading.

You write your chapter content once and get both outputs.

### TEX Root Directives

Each chapter file begins with a magic comment:

```latex
% !TEX root = ./article/chapter1-article.tex
```

This tells your editor (TeXShop, VS Code LaTeX Workshop, Emacs AUCTeX, etc.) to compile the standalone article version when you build from within the chapter file.  Frontmatter files point to `../dissertation.tex` instead.

### Section Levels

Because the chapter content sits under `\chapter{...}` in the dissertation and under `\section{Introduction}` in the article, use **`\section`** as the top-level heading in chapter files.  Introductory prose before the first `\section` will fall under the article wrapper's `\section{Introduction}`.

In the dissertation, the hierarchy is:

    \chapter  →  \section  →  \subsection  →  \subsubsection

In the article, it is:

    \section{Introduction}  →  \section{...}  →  \subsection{...}

Both give clean, natural numbering.

### Bibliography

A single `refs.bib` at the project root is shared by all documents:

- `dissertation.tex` references it as `refs.bib`
- Article wrappers reference it as `../../refs.bib` (two levels up from `chapter/article/`)

The bibliography backend is **biber** (not BibTeX).  The `\AtEveryBibitem` block in each preamble suppresses DOI, language, and ISBN fields, and suppresses URLs for non-online entries.

The dissertation uses `\nocite{*}` to print **all** bibliography entries.  Article wrappers print only cited entries.

### Memoir Features

The template uses `memoir`-specific commands:

- `\frontmatter` / `\mainmatter` / `\backmatter` for page numbering and chapter numbering
- `\titlingpage` for the title page
- `\DoubleSpacing` for the main body
- `\tableofcontents*` (starred = unnumbered heading)
- `\setsecnumdepth{subsubsection}` and `\settocdepth{subsection}` for numbering/TOC control


## Build Commands

All builds use the triple-pass pattern: `pdflatex` → `biber` → `pdflatex` → `pdflatex`.

**Full dissertation** (from the project root):

```bash
pdflatex dissertation.tex && biber dissertation && pdflatex dissertation.tex && pdflatex dissertation.tex
```

**Standalone chapter article** (from the chapter's `article/` directory):

```bash
cd chapter1/article
pdflatex chapter1-article.tex && biber chapter1-article && pdflatex chapter1-article.tex && pdflatex chapter1-article.tex
```

### Why three passes?

1. First `pdflatex`: reads the source, generates `.aux` and `.bcf` files, but cross-references and citations are unresolved.
2. `biber`: reads `.bcf`, processes `refs.bib`, outputs `.bbl`.
3. Second `pdflatex`: incorporates the `.bbl`, resolves most references.
4. Third `pdflatex`: resolves any remaining forward references and page numbers.


## Customization

### Changing title, author, department, and committee

Edit three places:

1. **`dissertation.tex`** --- the `\title{...}` and `\author{...}` commands, and the copyright page.
2. **`frontmatter/title-page.tex`** --- the title, author name, department, committee member names, and year.
3. **Each article wrapper** --- the `\title{...}` and `\author{...}` commands.

### Adding a new chapter

1. Create the directory structure:
   ```bash
   mkdir -p chapter4/article
   ```

2. Create `chapter4/chapter4.tex` with the TEX root directive:
   ```latex
   % !TEX root = ./article/chapter4-article.tex

   Introductory prose for this chapter...

   \section{First Section}
   ...
   ```

3. Copy any existing article wrapper to `chapter4/article/chapter4-article.tex` and update the `\title`, the `\input` path (to `../chapter4.tex`), and the `\addbibresource` path (should be `../../refs.bib`).

4. Add to `dissertation.tex` before `\backmatter`:
   ```latex
   \chapter{Fourth Chapter Title}\label{ch:chapter4}
   \input{./chapter4/chapter4.tex}
   ```

### Removing a chapter

Comment out or delete the `\chapter{...}` and `\input{...}` lines in `dissertation.tex`.  Optionally remove the directory.

### Removing the dedication or copyright page

These are clearly marked blocks in `dissertation.tex`.  Delete or comment them out.

### Adding appendices

`memoir` supports appendices via `\appendix` before `\backmatter`:

```latex
\appendix
\chapter{Proofs of Technical Lemmas}\label{app:proofs}
\input{./appendices/proofs.tex}

\backmatter
```

### Changing the article wrapper pattern

The default article wrapper includes a table of contents and wraps chapter content in `\section{Introduction}`.  For simpler chapters that don't need a TOC, you can strip the wrapper down to:

```latex
\begin{document}
\maketitle
\doublespacing
\input{../chapter.tex}
\printbibliography
\end{document}
```


## Acknowledgements

The earliest ancestor of this template was the UC Davis dissertation template maintained by [The Galois Group](https://galois.math.ucdavis.edu/doku.php?id=thesistips), the mathematics graduate student organization at UC Davis, originally created by Tyrell McAllister with updates by Jeff Irion, John Challenor, Will Wright, David Haley, and Greg DePaul. What survives from that template is the frontmatter layout: the title page text and committee signature block, the copyright page, and the optional dedication page. Everything else has been replaced:

- **Document class:** `amsbook` → `memoir`
- **Project structure:** flat directory → chapter subdirectories with a dual-compilation model (each chapter compiles both as part of the dissertation and as a standalone article)
- **Package architecture:** inline preamble → external `french-logic` package
- **Bibliography:** BibTeX with SIAM style → biblatex with biber backend
- **Page styles:** `fancyhdr`-based custom styles → `memoir` built-in styles
- **Frontmatter spacing:** `\bigskip` throughout → precise `\vspace` values; hardcoded year → `\the\year`

The Galois Group template was designed for Overleaf compatibility; see [Overleaf](#overleaf) for the current status of this template on Overleaf.


