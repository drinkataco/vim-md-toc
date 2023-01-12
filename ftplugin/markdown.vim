" Title:       Markdown TOC Generator
" Description: Generate a Table of Contents for you Markdown File
" Maintainer:  Joshua Walwyn <https://github.com/drinkataco>

if exists('g:loaded_mdtoc')
  finish
endif
let g:loaded_mdtoc=1

" Exposes the plugin's functions for use as commands in Vim.
command! -nargs=0 Toc call mdtoc#Toc()
command! -nargs=0 TocNumbered call mdtoc#TocNumbered()
