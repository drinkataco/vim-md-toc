# Vim Markdown TOC Generator

[![Vint](https://github.com/drinkataco/vim-md-toc/workflows/Vint/badge.svg)](https://github.com/drinkataco/vim-md-toc/actions?workflow=Vint)

⚠️  NOTE: This is developing and is not stable

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
- Fix backtick, bracket TOC linking
- Support g:toc_md_smart, g:toc_md_skip_level_1
- Add vader 
- Add vimdoc
