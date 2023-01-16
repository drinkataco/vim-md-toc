# Vim Markdown TOC Generator

[![Vint](https://github.com/drinkataco/vim-md-toc/workflows/Vint/badge.svg)](https://github.com/drinkataco/vim-md-toc/actions?workflow=Vint)

Generate table of contents in your markdown files.

This plugin wouldn't be possible without [perservim/vim-markdown](https://github.com/preservim/vim-markdown) - and was created to distribute basic functionality of that plugin to generate table of contents, and building on that functionality

* [Installation](#installation)
* [Commands](#commands)
  * [:Toc](#toc)
  * [:TocNumbered](#tocnumbered)

## Installation

Install with your favourite plugin manager.

With [vim-plug](https://github.com/junegunn/vim-plug)

```Vimscript
Plug 'drinkataco/vim-md-toc'
```

## Commands

### `:Toc`

Generate Table of Contents

### `:TocNumbered`

Generate Table of Contents, Numbered

## TODO

- Support levels
- Add fences (support /* and \<!--)
- Add :TocUpdate and auto update
- Add vader
- Add vimdoc
