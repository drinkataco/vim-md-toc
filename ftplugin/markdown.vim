" Title:       Markdown TOC Generator
" Description: Generate a Table of Contents for you Markdown File
" Maintainer:  Joshua Walwyn <https://github.com/drinkataco>

if exists('g:loaded_mdtoc')
  finish
endif
let g:loaded_mdtoc = 1

" Get Settings
let g:mdtoc_autoupdate = get(g:, 'mdtoc_autoupdate', 0)
let g:mdtoc_fences = get(g:, 'mdtoc_fences', 1)
let g:mdtoc_fence_style = get(g:, 'mdtoc_fence_style', 'xml')
let g:mdtoc_max_level = get(g:, 'mdtoc_max_level', 0)
let g:mdtoc_ignore_regex = get(g:, 'mdtoc_ignore_regex', 'TODO')

" Exposes the plugin's functions for use as commands in Vim.
command! -nargs=* Toc call mdtoc#Toc(<f-args>)
command! -nargs=* TocNumbered call mdtoc#TocNumbered(<f-args>)
command! -nargs=0 TocDelete call mdtoc#TocDelete()
command! -nargs=0 TocUpdate call mdtoc#TocUpdate()

" Auto call TocUpdate script if set
if g:mdtoc_autoupdate == 1
  augroup mdtoc_autoupdate
    au!
    autocmd BufWritePre *.{md,mdx,mdown,mkd,mkdn,markdown,mdwn} if !&diff | exe ':silent! TocUpdate' | endif
  augroup END
endif
