""
" Title:       Markdown TOC Generator
" Description: Generate a Table of Contents for you Markdown File
" Maintainer:  Joshua Walwyn <https://github.com/drinkataco>

""
" @section Introduction, intro
" This plugin allows you to generate a table of contents for your markdown
" files, based off of the headers.
" With configuration, you can set max children leveling, style (numbered or
" bullet), and ignore patterns.
" The table of contents can be set to auto update on file save with the
" |g:mdtoc_autoupdate| config

if exists('g:loaded_mdtoc')
  finish
endif
let g:loaded_mdtoc = 1

""
" Set markdown files to auto update any table of contents generated with the
" plugin. Requires fences to be enabled with |g:mdtoc_fences| - as is by
" default
"
" Default: 0
let g:mdtoc_autoupdate = get(g:, 'mdtoc_autoupdate', 0)

""
" Fences are comments surrounding the generated table of contents. Keeping
" this enabled allows the |:TocUpdate| and the |:TocDelete| commands to work.
"
" Default: 1
let g:mdtoc_fences = get(g:, 'mdtoc_fences', 1)

""
" Fences can be styles as XML comments (default) and JS comments. The former
" being the default for most parsers.
"
" Default: xml
let g:mdtoc_fence_style = get(g:, 'mdtoc_fence_style', 'xml')

""
" Patterns can be set to be ignored by default, as a regular expression. For
" example; '^Contents$'.
"
" By default, no pattern is enabled.
let g:mdtoc_ignore_regex = get(g:, 'mdtoc_ignore_regex', -1)

" Default list format to use internally. As there are two commands, :Toc and
" :TocNumbered to handle this from a user point this cannot be overwritten.
let g:mdtoc_default_list_format = 'bullets'

""
" Max level of headers to add to the table of contents, with 1 being the top
" level header (which itself is ignored from the table of contents).
"
" By default, no max level is set.
let g:mdtoc_max_level = get(g:, 'mdtoc_max_level', -1)

""
" @usage {}
" Generates a bulleted Table of Contents based off the current markdown files headers.
" Uses the default or global values set for options.
" @usage {} [max_level]
" Generates a Table of Contents based off the current markdown files headers.
" You can pass through a maximum depth value through here too. See
" |g:mdtoc_max_level|.
" @usage {} [max_level] [ignore_pattern]
" Generates a Table of Contents based off the current markdown files headers.
" You can pass through an ignore pattern through here after the max_level. See
" |g:mdtoc_ignore_regex|.
command! -nargs=* Toc call mdtoc#Toc('bullets', <f-args>)

""
" @usage {}
" Generates a numbered Table of Contents based off the current markdown files headers.
" Uses the default or global values set for options.
" @usage {} [max_level]
" Generates a numbered Table of Contents based off the current markdown files headers.
" You can pass through a maximum depth value through here too. See
" |g:mdtoc_max_level|.
" @usage {} [max_level] [ignore_pattern]
" Generates a numbered Table of Contents based off the current markdown files headers.
" You can pass through an ignore pattern through here after the max_level. See
" |g:mdtoc_ignore_regex|.
command! -nargs=* TocNumbered call mdtoc#Toc('numbered', <f-args>)

""
" Delete the generated Table of Contents.
" |g:mdtoc_fences| must be enabled so they can be found.
command! -nargs=0 TocDelete call mdtoc#TocDelete()

""
" Update the Table of Contents previously generated.
" |g:mdtoc_fences| must be enabled so they can be found.
command! -nargs=0 TocUpdate call mdtoc#TocUpdate()

" Auto call TocUpdate script if set
if g:mdtoc_autoupdate == 1
  augroup mdtoc_autoupdate
    au!
    autocmd BufWritePre *.{md,mdx,mdown,mkd,mkdn,markdown,mdwn} if !&diff | exe ':silent! TocUpdate' | endif
  augroup END
endif
