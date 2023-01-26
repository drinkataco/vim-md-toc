" Title:       Markdown TOC Generator
" Description: Generate a Table of Contents for you Markdown File
" Maintainer:  Joshua Walwyn <https://github.com/drinkataco>

if exists('g:loaded_mdtoc')
  finish
endif
let g:loaded_mdtoc = 1

" Get Settings
let g:mdtoc_max_level = get(g:, 'mdtoc_max_level', 0)

" Exposes the plugin's functions for use as commands in Vim.
command! -nargs=* Toc call mdtoc#Toc(<q-args>)
command! -nargs=* TocNumbered call mdtoc#TocNumbered(<q-args>)
