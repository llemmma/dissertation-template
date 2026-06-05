# UC Davis Philosophy Dissertation Template

A LaTeX dissertation template for UC Davis philosophy PhD students, built on the `memoir` document class with a dual-compilation architecture: each chapter compiles both as part of the full dissertation and as a standalone article, and can additionally be presented as a beamer slide deck. Logic notation is supplied by a small, self-contained package, `philogic`, that ships with the template.

**Is this template for you?** It is built around one specific workflow — **dual compilation**, where each chapter is at once a dissertation chapter, a standalone article, and (optionally) a slide deck — together with a small, reusable **logic-notation package** (`philogic`) you can grow into your own house style. It is designed for **local compilation**; it is *not* recommended on Overleaf, which times out on the full dissertation (see [Overleaf](#overleaf)).

If you'd rather have a **conventional, Overleaf-compatible** dissertation template — one without this template's dual-compilation workflow or bundled logic package — use the [Galois Group template](https://galois.math.ucdavis.edu/doku.php?id=thesistips) that this one descends from instead.  The two also rest on different document classes: this one uses **`memoir`**, whose built-in control over frontmatter, sectioning, and spacing keeps layout customization straightforward, whereas the Galois template uses the leaner but more rigid **`amsbook`**, which takes more manual work to bend to a custom layout.

Adapted and extended by [Brandon Hopkins](https://bphopkins.net) (Philosophy, UC Davis) from an earlier template by the Galois Group (see [Acknowledgements](#acknowledgements)). This repository and its documentation are works in progress — if you have questions or concerns, please get in touch.


## Contents

- [Getting Started](#getting-started)
  - [Creating your own repository](#creating-your-own-repository)
  - [The `philogic` package](#the-philogic-package)
  - [Quick build](#quick-build)
  - [Installing `philogic` in your texmf tree (optional)](#installing-philogic-in-your-texmf-tree-optional)
  - [Overleaf](#overleaf)
- [Project Structure](#project-structure)
- [Architecture](#architecture)
  - [Dual-Compilation Model](#dual-compilation-model)
  - [The `philogic` package and the `slim` option](#the-philogic-package-and-the-slim-option)
  - [Beamer presentations](#beamer-presentations)
  - [TEX Root Directives](#tex-root-directives)
  - [Section Levels](#section-levels)
  - [Bibliography](#bibliography)
  - [Memoir Features](#memoir-features)
- [Build Commands](#build-commands)
  - [Why three passes?](#why-three-passes)
  - [Building everything at once (Makefile)](#building-everything-at-once-makefile)
  - [Finding `philogic.sty` from subdirectories](#finding-philogicsty-from-subdirectories)
- [Customization](#customization)
  - [Changing title, author, department, and committee](#changing-title-author-department-and-committee)
  - [Adding a new chapter](#adding-a-new-chapter)
  - [Removing a chapter](#removing-a-chapter)
  - [Removing the dedication or copyright page](#removing-the-dedication-or-copyright-page)
  - [Adding appendices](#adding-appendices)
  - [Making slides](#making-slides)
  - [Extending or replacing `philogic`](#extending-or-replacing-philogic)
  - [Changing the article wrapper pattern](#changing-the-article-wrapper-pattern)
- [Acknowledgements](#acknowledgements)


## Getting Started

This template is built for local compilation and requires a TeX distribution with `pdflatex` and `biber` (e.g., TeX Live, MacTeX, MiKTeX). Beamer (for the slide decks) ships with all of these.

### Creating your own repository

To turn this template into your own dissertation repo:

- **Use this template** (recommended): Click the green "Use this template" button on the GitHub repository page.  This creates a fresh repository under your own account with the same files but no shared history.
- **Clone and change the remote**: If you're comfortable with git, you can clone this repo and then update the remote URL to point at your own empty repository.
- **Download the zip**: On the GitHub page, click Code → Download ZIP.  This gives you the files without any git history; run `git init` in the extracted directory to start fresh.

### The `philogic` package

The template's logic notation lives in **`philogic.sty`**, in the project root.  It is **bundled with the template** — there is nothing to download or install, and a plain `make` builds everything out of the box.

`philogic` is a deliberately small *core*: it loads the math-typesetting packages and defines the notation a logic dissertation actually needs (set theory, object languages, the consequence and forcing turnstiles, models and frames, named systems, axioms and rules), with commentary showing how to grow it into your own house style.  It is meant to be read and edited, not treated as a black box.  If your work isn't in logic at all, you can [replace it wholesale](#extending-or-replacing-philogic).

The package takes one option, `slim`, used by the beamer decks and useful for journal/conference submissions — see [the `slim` option](#the-philogic-package-and-the-slim-option).

### Quick build

From the project root:

```bash
make              # all chapter articles, all beamer decks, and the dissertation
make dissertation # just the full dissertation
make chapter1     # just chapter 1's standalone article
make chapter1-beamer  # just chapter 1's slide deck
```

Or build the full dissertation by hand (also from the root, where `philogic.sty` lives):

```bash
pdflatex dissertation.tex && biber dissertation && pdflatex dissertation.tex && pdflatex dissertation.tex
```

The standalone article and beamer builds live two directories down, so building *them* by hand needs TeX to be told where `philogic.sty` is — `make` handles this for you, or see [Finding `philogic.sty` from subdirectories](#finding-philogicsty-from-subdirectories).

### Installing `philogic` in your texmf tree (optional)

You do **not** need to install anything for `make` to work.  But installing `philogic.sty` in your local texmf tree makes TeX find it automatically from *any* directory — which is convenient in two situations:

1. **Editor builds of standalone articles or slide decks.**  When your editor (TeXstudio, VS Code, Emacs, …) compiles a chapter via its `% !TEX root`, it runs from a subdirectory two levels below the root and will not find the bundled `philogic.sty` there on its own.
2. **A single source of truth.**  If you keep adapting `philogic` across several projects over the years, a texmf copy lets every document share one canonical version instead of drifting copies.

To install it, place `philogic.sty` in your personal *texmf tree* and refresh TeX's file database.  Where that tree lives depends on your distribution:

| Distribution (OS)   | Personal texmf tree    |
|---------------------|------------------------|
| TeX Live (Linux)    | `~/texmf`              |
| MacTeX (macOS)      | `~/Library/texmf`      |
| TeX Live (Windows)  | `%USERPROFILE%\texmf`  |

Not sure which applies? Run `kpsewhich -var-value TEXMFHOME` to print the exact path.  Then create a `tex/latex/philogic/` subfolder inside that tree, copy `philogic.sty` into it, and rebuild the database with `mktexlsr` (also available as `texhash`).  For example, on Linux:

```bash
mkdir -p ~/texmf/tex/latex/philogic
cp philogic.sty ~/texmf/tex/latex/philogic/
mktexlsr
```

On macOS the steps are identical, with `~/Library/texmf` in place of `~/texmf`.

**MiKTeX** (common on Windows) manages its trees differently: put `philogic.sty` in `<root>\tex\latex\philogic\`, then register that root and refresh the database via *MiKTeX Console → Settings → Directories*, or on the command line with `initexmf --register-root=<root>` followed by `initexmf --update-fndb`.

Changes to the installed file take effect on the next compilation, with no reinstall needed.  If you keep *both* this texmf copy and the one in the project root, the **project-root copy takes precedence** for any build that can see it (such as the dissertation build run from the root), so installing in texmf mainly helps editor builds of the subdirectory documents.  For a single source of truth, keep just one copy.

### Overleaf

**Overleaf is not recommended for this template — build locally instead** (see [Quick build](#quick-build)).  The full dissertation runs `pdflatex` three times plus `biber`, and on Overleaf this reliably exceeds the compile-time limit: the timeout is hit at the **dissertation level**.  The source is correct — this is a platform time limit, not a bug — and a local TeX distribution has no such limit, building the whole dissertation in seconds.

Smaller pieces fare better: since `philogic.sty` ships in the project root, a single chapter's standalone article or slide deck is small enough that it may still compile on Overleaf.  But the complete dissertation is the usual goal, and for that you'll want to compile locally.

If you specifically want a template that works on Overleaf, use the `amsbook`-based [Galois Group template](https://galois.math.ucdavis.edu/doku.php?id=thesistips) that this one descends from — it is Overleaf-compatible.  (`amsbook` is leaner than the `memoir` class used here, but more rigid to customize — see [Acknowledgements](#acknowledgements).)


## Project Structure

```
dissertation-template/
├── dissertation.tex              Main driver file
├── philogic.sty                  Bundled logic-notation package
├── refs.bib                      Master bibliography (biber backend)
├── Makefile                      Builds articles, beamer decks, and the dissertation
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
├── chapter1/
│   ├── chapter1.tex              Chapter content
│   ├── article/
│   │   └── chapter1-article.tex  Standalone article wrapper
│   └── beamer/
│       └── chapter1-beamer.tex   Standalone slide deck
│
├── chapter2/ ... chapter3/       Same structure as chapter1/
│
└── conclusion/
    ├── conclusion.tex
    └── article/
        └── conclusion-article.tex
```

(The `introduction/` and `conclusion/` directories have article wrappers but no `beamer/` folder, since navigational prose doesn't slide naturally.  Add one by copying a chapter's `beamer/` directory if you want it.)


## Architecture

### Dual-Compilation Model

Each chapter lives in its own directory as a single `.tex` file containing **only content** --- no `\documentclass`, no `\begin{document}`, no preamble.  This file is `\input`ed in two contexts:

1. **Full dissertation:** `dissertation.tex` wraps it in a `\chapter{...}` heading under the `memoir` class.
2. **Standalone article:** A wrapper in the chapter's `article/` subdirectory provides its own `\documentclass{article}` preamble and wraps the content in a `\section{Introduction}` heading.

You write your chapter content once and get both outputs.  A third output, slides, is handled separately --- see [Beamer presentations](#beamer-presentations).

### The `philogic` package and the `slim` option

`philogic.sty` is organized in two layers:

- **Notation** (always loaded): the math packages and all the logic macros.  These load no matter how the package is called, so the *same* macros are available in the dissertation, in the standalone articles, and on slides.
- **Structure** (skipped under the `slim` option): `biblatex` (with `csquotes`), `hyperref`, `setspace`, the custom list environments, and the `amsthm` theorem environments.

The dissertation and the article wrappers load the package in full:

```latex
\usepackage{philogic}
```

The beamer decks load it with `slim`:

```latex
\usepackage[slim]{philogic}
```

`slim` exists because beamer already provides its own theorem blocks and `hyperref`, and conference/journal classes provide their own bibliography and theorem environments.  Loading those a second time causes "command already defined" and option-clash errors.  `slim` strips exactly that structural layer, leaving the notation, so the file is safe to load inside such a host class.  When you submit a chapter to a journal whose class owns the structure, load `philogic` with `slim` there too.

### Beamer presentations

Each substantive chapter (`chapter1`–`chapter3`) has a `beamer/` subdirectory with a standalone slide deck (e.g. `chapter1/beamer/chapter1-beamer.tex`).  Unlike the article wrappers, the decks do **not** `\input` the chapter content: prose and `\section` headings don't map onto frames.  Instead each deck is a hand-built adaptation that presents the chapter's key definitions and results as beamer blocks --- reusing the very same `philogic` notation macros and the shared `refs.bib`.  Treat them as worked examples of turning a chapter into a talk.

Because the decks run under `slim`, beamer owns the theorem environments.  beamer predefines `theorem`, `corollary`, `lemma`, `definition`, `example`, and `proof` (among others), but not `proposition` or `remark`; a deck that needs one of those simply declares it, e.g. `\newtheorem{proposition}{Proposition}` (see `chapter2/beamer/chapter2-beamer.tex`).  Avoid the name `note` for a theorem environment — beamer already uses `\note` for speaker notes.

### TEX Root Directives

Each chapter file begins with a magic comment:

```latex
% !TEX root = ./article/chapter1-article.tex
```

This tells your editor (TeXstudio, TeXShop, VS Code LaTeX Workshop, Emacs AUCTeX, etc.) to compile the standalone article version when you build from within the chapter file.  Frontmatter files point to `../dissertation.tex` instead.  (Editor builds of these subdirectory documents need to find `philogic.sty`; see [Installing in your texmf tree](#installing-philogic-in-your-texmf-tree-optional).)

### Section Levels

Because the chapter content sits under `\chapter{...}` in the dissertation and under `\section{Introduction}` in the article, use **`\section`** as the top-level heading in chapter files.  Introductory prose before the first `\section` will fall under the article wrapper's `\section{Introduction}`.

In the dissertation, the hierarchy is:

    \chapter  →  \section  →  \subsection  →  \subsubsection

In the article, it is:

    \section{Introduction}  →  \section{...}  →  \subsection{...}

Both give clean, natural numbering.

### Bibliography

A single `refs.bib` at the project root is shared by every document:

- `dissertation.tex` references it as `refs.bib`
- Article wrappers and beamer decks reference it as `../../refs.bib` (two levels up)

The bibliography backend is **biber** (not BibTeX), loaded by `philogic` via `biblatex`.  The `\AtEveryBibitem` block in the dissertation and each article wrapper suppresses DOI, language, and ISBN fields, and suppresses URLs for non-online entries (the beamer decks omit this tweak).

The dissertation uses `\nocite{*}` to print **all** bibliography entries.  Article wrappers and beamer decks print only cited entries.  (In `slim` mode `philogic` does not load `biblatex`, so the beamer decks load it themselves --- see any deck's preamble.)

### Memoir Features

The template uses `memoir`-specific commands:

- `\frontmatter` / `\mainmatter` / `\backmatter` for page numbering and chapter numbering
- `\titlingpage` for the title page
- `\DoubleSpacing` for the main body (the article wrappers use `setspace`'s `\doublespacing` instead, supplied by `philogic`)
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

**Chapter slide deck** (from the chapter's `beamer/` directory):

```bash
cd chapter1/beamer
pdflatex chapter1-beamer.tex && biber chapter1-beamer && pdflatex chapter1-beamer.tex && pdflatex chapter1-beamer.tex
```

The article and beamer commands above assume TeX can find `philogic.sty` from those subdirectories — see [Finding `philogic.sty` from subdirectories](#finding-philogicsty-from-subdirectories).  Using `make` avoids the issue entirely.

### Why three passes?

1. First `pdflatex`: reads the source, generates `.aux` and `.bcf` files, but cross-references and citations are unresolved.
2. `biber`: reads `.bcf`, processes `refs.bib`, outputs `.bbl`.
3. Second `pdflatex`: incorporates the `.bbl`, resolves most references.
4. Third `pdflatex`: resolves any remaining forward references and page numbers.

### Building everything at once (Makefile)

The repository includes a `Makefile` that builds all chapter articles, all beamer decks, and the full dissertation in one command.  LaTeX editors completely ignore this file --- it only runs when you explicitly type `make` in a terminal, so it will never interfere with the normal workflow.

```bash
make                  # Build all chapter articles, beamer decks, and the dissertation
make articles         # Build all chapter articles only
make beamer           # Build all chapter beamer decks only
make dissertation     # Build the full dissertation only
make chapter1         # Build just chapter 1's article
make chapter1-beamer  # Build just chapter 1's beamer deck
make clean            # Remove build artifacts
```

**Platform support:** `make` is available out of the box on Linux and macOS (via Xcode Command Line Tools).  On Windows it is not installed by default; the easiest route is to use WSL (Windows Subsystem for Linux), which provides `make` along with a full Linux environment.

**If you add or remove chapters**, update the `CHAPTERS` list at the top of the `Makefile` (it drives both the article and the beamer targets).  If you'd rather not maintain this file, you can safely delete it --- nothing in the LaTeX build chain depends on it.

### Finding `philogic.sty` from subdirectories

`philogic.sty` lives in the project root.  The full-dissertation build runs there, so it finds the package with no configuration.  The standalone article and beamer builds run two directories down and need to be pointed at the root.  You have three options:

- **Use `make`** (simplest): the Makefile prepends the project root to `TEXINPUTS` automatically, so every target just works.
- **Set `TEXINPUTS` yourself** for a manual subdirectory build:

  ```bash
  cd chapter1/article
  TEXINPUTS="../../:$TEXINPUTS" pdflatex chapter1-article.tex && biber chapter1-article && \
  TEXINPUTS="../../:$TEXINPUTS" pdflatex chapter1-article.tex && \
  TEXINPUTS="../../:$TEXINPUTS" pdflatex chapter1-article.tex
  ```

  (This is POSIX-shell syntax — Linux, macOS, WSL, or Git Bash.  On native Windows `cmd`/PowerShell the variable syntax and the path separator differ — `;` rather than `:` — so prefer `make` or a texmf install there.)

- **Install `philogic.sty` in your texmf tree** so it's found everywhere, including from your editor — see [Installing in your texmf tree](#installing-philogic-in-your-texmf-tree-optional).  This is the most convenient option if you build standalone articles or decks from an editor.


## Customization

### Changing title, author, department, and committee

Edit these places:

1. **`dissertation.tex`** --- the `\title{...}` and `\author{...}` commands, and the copyright page.
2. **`frontmatter/title-page.tex`** --- the title, author name, department, committee member names, and year.
3. **Each article wrapper** --- the `\title{...}` and `\author{...}` commands.
4. **Each beamer deck** --- the `\title`, `\subtitle`, `\author`, and `\institute` commands.

### Adding a new chapter

1. Create the directory structure:
   ```bash
   mkdir -p chapter4/article chapter4/beamer
   ```

2. Create `chapter4/chapter4.tex` with the TEX root directive:
   ```latex
   % !TEX root = ./article/chapter4-article.tex

   Introductory prose for this chapter...

   \section{First Section}
   ...
   ```

3. Copy an existing article wrapper to `chapter4/article/chapter4-article.tex` and update the `\title`, the `\input` path (to `../chapter4.tex`), and the `\addbibresource` path (it should remain `../../refs.bib`).  Optionally copy a `beamer/` deck the same way.

4. Add to `dissertation.tex` before `\backmatter`:
   ```latex
   \chapter{Fourth Chapter Title}\label{ch:chapter4}
   \input{./chapter4/chapter4.tex}
   ```

5. Add `chapter4` to the `CHAPTERS` list in the `Makefile` so `make` builds its article and deck.

### Removing a chapter

Comment out or delete the `\chapter{...}` and `\input{...}` lines in `dissertation.tex`, and remove the chapter from `CHAPTERS` in the `Makefile`.  Optionally remove the directory.

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

### Making slides

Each chapter's `beamer/` deck is a standalone beamer presentation that loads `philogic` with the `slim` option and reuses the shared `refs.bib`.  To start a deck for a new chapter, copy an existing one, update the title block, and adapt the chapter's definitions and results into frames.  See [Beamer presentations](#beamer-presentations) for how `slim` interacts with beamer's theorem environments.  The decks use the built-in `Madrid` theme; change `\usetheme{...}` to taste.

### Extending or replacing `philogic`

`philogic.sty` is yours to edit.  It ends with a short section of patterns (new operators, blackboard names, composed symbols) showing how to extend it; add your own macros alongside them.

If your dissertation isn't in logic, you can drop the dependency entirely.  The template's architecture needs only three structural packages: `biblatex` (with the biber backend), `hyperref`, and `setspace`.  To remove `philogic`:

1. In `dissertation.tex` and each wrapper, replace `\usepackage{philogic}` (or `\usepackage[slim]{philogic}` in the decks) with the packages you actually use, e.g.:
   ```latex
   \usepackage[backend=biber]{biblatex}
   \usepackage{hyperref}
   \usepackage{setspace}
   ```
2. Add whatever your own content requires (`amsthm` for theorem environments, `amsmath` for mathematics, `enumitem` for custom lists, …).
3. Replace the example chapter content and bibliography entries with your own.

Everything else --- the `memoir` class setup, the `\input` structure, the bibliography pipeline, and the triple-pass build --- works unchanged.

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
- **Project structure:** flat directory → chapter subdirectories with a dual-compilation model (each chapter compiles both as part of the dissertation and as a standalone article, with an optional beamer deck)
- **Package architecture:** inline preamble → a bundled `philogic` package (a trimmed, general-purpose core of the author's larger personal `french-logic` package)
- **Bibliography:** BibTeX with SIAM style → biblatex with biber backend
- **Page styles:** `fancyhdr`-based custom styles → `memoir` built-in styles
- **Frontmatter spacing:** `\bigskip` throughout → precise `\vspace` values; hardcoded year → `\the\year`

The Galois Group template is Overleaf-compatible (made so in 2024); see [Overleaf](#overleaf) for the current status of this template on Overleaf.
