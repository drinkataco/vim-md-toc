# Vim Markdown TOC Generator

[![Vint](https://github.com/drinkataco/vim-md-toc/workflows/Vint/badge.svg)](https://github.com/drinkataco/vim-md-toc/actions?workflow=Vint)

Generate table of contents in your markdown files.

This plugin wouldn't be possible without [perservim/vim-markdown](https://github.com/preservim/vim-markdown) - and was created to distribute basic functionality of that plugin to generate table of contents, and building on that functionality

<!-- vim-md-toc -->
* [Installation](#installation)
* [Commands](#commands)
  * [:Toc](#toc)
  * [:TocNumbered](#tocnumbered)
  * [:TocDelete](#tocdelete)
* [Settings](#settings)
  * [g:mdtoc_max_level](#gmdtoc_max_level)
  * [g:mdtoc_fences](#gmdtoc_fences)
  * [g:mdtoc_fence_style](#gmdtoc_fence_style)
* [TODO](#todo)
<!-- vim-md-toc END -->

## Installation

Install with your favourite plugin manager.

With [vim-plug](https://github.com/junegunn/vim-plug)

```Vimscript
Plug 'drinkataco/vim-md-toc'
```

## Commands

### `:Toc`

Generate Table of Contents

Takes an argument, like `:Toc 4` to indicate the maximum level the contents can go. Otherwise, uses the `g:mdtoc_max_level` value (which is set to unlimited).

### `:TocNumbered`

Generate Table of Contents, Numbered

Takes an argument, like `:TocNumbered 4` to indicate the maximum level the contents can go. Otherwise, uses the `g:mdtoc_max_level` value (which is set to unlimited).

### `:TocDelete`

Delete Table of contents, if that table of context is fenced (see [g:mdtoc_fences](#gmdtock_fences))

## Settings

### `g:mdtoc_max_level`

Default: `0` (unlimited)

Set the default max child level of the table of contents.

### `g:mdtoc_fences`

Default: `1`

Whether to add fences to the generated table for contents (comments that indicate the ToC has been generated by this plugin). Fences are used to discover where the table of contents are for updating and deleting with the `:TocUpdate` and `:TocDelete` commands.

### `g:mdtoc_fence_style`

Default: `xml`

By default, as expected by most markdown parsers, fences are added in the style of xml/html comments; `<!-- vim-md-toc -->`. Setting this value to `js` allows the fences to be represented like `/* vim-md-toc */`.

## TODO

- Add :TocUpdate and auto update
- Add regex ignore
- add ignore/max level to fences
- Support levels
- Add vader
- Add vimdoc
