if exists('g:autoloaded_md_toc')
  finish
endif
let g:autoloaded_mdtoc = 1

" For each level, contains the regexp that matches at that level only.
let s:levelRegexpDict = {
  \ 1: '\v^(#[^#]@=|.+\n\=+$)',
  \ 2: '\v^(##[^#]@=|.+\n-+$)',
  \ 3: '\v^###[^#]@=',
  \ 4: '\v^####[^#]@=',
  \ 5: '\v^#####[^#]@=',
  \ 6: '\v^######[^#]@='
  \ }

" Matches any header level of any type.
let s:headersRegexp = '\v^(#|.+\n(\=+|-+)$)'

""
" Returns the line number of the first header before `line`, called the
" current header.
"
" If there is no current header, return `0`.
"
" @param a:1 The line to look the header of. Default value: `getpos('.')`.
function! s:GetHeaderLineNum(...) abort
  if a:0 == 0
    let l:l = line('.')
  else
    let l:l = a:1
  endif
  while(l:l > 0)
    if join(getline(l:l, l:l + 1), "\n") =~ s:headersRegexp
      return l:l
    endif
    let l:l -= 1
  endwhile
  return 0
endfunction

""
" - if line is inside a header, return the header level (h1 -> 1, h2 -> 2, etc.).
"
" - if line is at top level outside any headers, return `0`.
function! s:GetHeaderLevel(...) abort
  if a:0 == 0
    let l:line = line('.')
  else
    let l:line = a:1
  endif
  let l:linenum = s:GetHeaderLineNum(l:line)
  if l:linenum !=# 0
    return s:GetLevelOfHeaderAtLine(l:linenum)
  else
    return 0
  endif
endfunction

""
" Return list of headers and their levels.
function! s:GetHeaderList(...) abort
  let l:bufnr = bufnr('%')
  let l:fenced_block = 0
  let l:front_matter = 0
  let l:header_list = []
  let l:vim_markdown_frontmatter = get(g:, 'vim_markdown_frontmatter', 0)
  let l:skip_level = -1
  let l:ignore_regex = a:1

  for i in range(1, line('$'))
    let l:lineraw = getline(i)
    let l:l1 = getline(i+1)
    let l:line = substitute(l:lineraw, '#', "\\\#", 'g')
    " exclude lines in fenced code blocks
    if l:line =~# '````*' || l:line =~# '\~\~\~\~*'
      if l:fenced_block == 0
        let l:fenced_block = 1
      elseif l:fenced_block == 1
        let l:fenced_block = 0
      endif
    " exclude lines in frontmatters
    elseif l:vim_markdown_frontmatter == 1
      if l:front_matter == 1
        if l:line ==# '---'
          let l:front_matter = 0
        endif
      elseif i == 1
        if l:line ==# '---'
          let l:front_matter = 1
        endif
      endif
    endif

    " match line against header regex
    if join(getline(i, i + 1), "\n") =~# s:headersRegexp && l:line =~# '^\S'
      let l:is_header = 1
    else
      let l:is_header = 0
    endif

    if l:is_header ==# 1 && l:fenced_block ==# 0 && l:front_matter ==# 0
      " sanitise text
      if match(l:line, '^#') > -1
        let l:line = substitute(l:line, '\v^#*[ ]*', '', '')
        let l:line = substitute(l:line, '\v[ ]*#*$', '', '')
      endif

      let l:line = substitute(l:line, '`', '', 'g')

      " sanitise link
      let l:link = substitute(tolower(l:line), '\v[ ]+', '-', 'g')
      let l:link = substitute(l:link, "\\%#=0[^[:alnum:]\u00C0-\u00FF\u0400-\u04ff\u4e00-\u9fbf\u3040-\u309F\u30A0-\u30FF\uAC00-\uD7AF _-]", '', 'g')

      " append line to list
      let l:level = s:GetHeaderLevel(i)

      " Based on a REGEX pattern, we can skip headers and their children
      if ignore_regex != -1
        if l:skip_level != -1 && l:skip_level < l:level
          continue
        elseif l:line =~# l:ignore_regex
          let l:skip_level = l:level
          continue
        else
          let l:skip_level = -1
        endif
      endif

      " add link object
      let l:item = {
            \ 'level': l:level,
            \ 'text': l:line,
            \ 'link': l:link,
            \ 'lnum': i,
            \ 'bufnr': bufnr
            \}
      let l:header_list = l:header_list + [l:item]
    endif
  endfor

  return l:header_list
endfunction

""
" Returns the level of the header at the given line.
"
" If there is no header at the given line, returns `0`.
"
" @param linenum - the line number to get level from
function! s:GetLevelOfHeaderAtLine(linenum) abort
  let l:lines = join(getline(a:linenum, a:linenum + 1), "\n")
  for l:key in keys(s:levelRegexpDict)
    if l:lines =~ get(s:levelRegexpDict, l:key)
      return l:key
    endif
  endfor
  return 0
endfunction

""
" Insert Table of Contents
function! s:InsertToc(format, ...) abort
  let l:format = a:format

  " Get Max Level
  if empty(a:1)
    let l:max_level = g:mdtoc_max_level
  else
    let l:max_level = a:1
  endif

  " Get Ignore Regex Pattern
  if empty(a:2)
    let l:ignore_regex = g:mdtoc_ignore_regex
  else
    let l:ignore_regex = a:2
  endif

  if (l:max_level !~# '^\d\+$' || l:max_level < 2) && l:max_level != -1
    echohl WarningMsg
    echomsg '[vim-md-toc] Invalid argument, max_level must be an integer more than 1'
    echohl None
    return
  endif

  let l:toc = []
  let l:header_list = s:GetHeaderList(l:ignore_regex)

  if len(l:header_list) == 0
    echom 'InsertToc: No headers.'
    return
  endif

  if l:format ==# 'numbers'
    let l:h2_count = 0
    for header in l:header_list
      if header.level == 2
        let l:h2_count += 1
      endif
    endfor
    let l:max_h2_number_len = strlen(string(l:h2_count))
  else
    let l:max_h2_number_len = 0
  endif

  let l:h2_count = 0

  for header in l:header_list
    let l:level = header.level

    if l:level == 1
      " skip level-1 headers
      continue
    elseif l:max_level != -1 && l:level > l:max_level
      " skip unwanted levels
      continue
    elseif l:level == 2
      " list of level-2 headers can be bullets or numbers
      if l:format ==# 'bullets'
        let l:indent = ''
        let l:marker = '* '
      else
        let l:h2_count += 1
        let l:number_len = strlen(string(l:h2_count))
        let l:indent = repeat(' ', l:max_h2_number_len - l:number_len)
        let l:marker = l:h2_count . '. '
      endif
    else
      let l:indent = repeat(' ', l:max_h2_number_len + 2 * (l:level - 2))
      let l:marker = '* '
    endif

    let l:text = '[' . header.text . ']'
    let l:link = '(#' . header.link . ')'
    let l:line = l:indent . l:marker . l:text . l:link
    let l:toc = l:toc + [l:line]
  endfor

  " Add fences
  if g:mdtoc_fences == 1
    let l:fence_settings = 'format=' . l:format

    if l:max_level != -1
      let l:fence_settings =
            \ l:fence_settings . ' max_level=' . l:max_level
    endif

    if l:ignore_regex != -1
      let l:fence_settings =
            \ l:fence_settings . ' ignore=' . l:ignore_regex
    endif

    if index(['xml', 'html'], g:mdtoc_fence_style) >= 0
      let l:end_fence = '<!-- vim-md-toc END -->'
      let l:start_fence = '<!-- vim-md-toc ' . l:fence_settings . ' -->'
    elseif g:mdtoc_fence_style ==# 'js'
      let l:end_fence = '/* vim-md-toc END */'
      let l:start_fence = '/* vim-md-toc */'
    endif
  endif

  if g:mdtoc_fences == 1
    call append(line('.'), l:end_fence)
  endif

  call append(line('.'), l:toc)

  if g:mdtoc_fences == 1
    call append(line('.'), l:start_fence)
  endif
endfunction

""
" Delete Fenced Table of Contents
"
function! s:DeleteToc() abort
  let l:winview = winsaveview()

  keepjumps normal! gg0

  if index(['xml', 'html'], g:mdtoc_fence_style) >= 0
    let l:fence_pattern_start = '<!-- vim-md-toc'
    let l:fence_pattern_end = '<!-- vim-md-toc END -->'
  elseif g:mdtoc_fence_style ==# 'js'
    let l:fence_pattern_start = '/* vim-md-toc'
    let l:fence_pattern_end = '/* vim-md-toc END */'
  endif

  let l:begin_line = -1
  let l:end_line = -1
  let l:list_format = g:mdtoc_default_list_format
  let l:list_ignore = g:mdtoc_ignore_regex
  let l:list_max_level = g:mdtoc_max_level

  " Search for vim-md-toc pattern
  if search(l:fence_pattern_start, 'Wc') != 0
    let l:begin_line = line('.')

    " Extract fence settings
    let l:fence_settings = split(getline('.'))
    let l:fence_settings = l:fence_settings[1 : len(l:fence_settings) - 2]

    for option in l:fence_settings
      if option =~# '^format='
        let l:list_format = split(option, '=')[1]
      elseif option =~# '^ignore='
        let l:list_ignore = split(option, '=')[1]
      elseif option =~# '^max_level='
        let l:list_max_level = split(option, '=')[1]
      endif
    endfor

    " Search for end of pattern
    if search(l:fence_pattern_end, 'W') != 0
      let l:end_line = line('.')

      silent execute l:begin_line . ',' . l:end_line . 'delete_'
    endif
  endif

  call winrestview(l:winview)

  if l:end_line == -1
    echohl WarningMsg
    echomsg '[vim-md-toc] No fenced table of contents found'
    echohl None
  endif

  return [
        \ l:begin_line,
        \ l:list_format,
        \ l:list_ignore,
        \ l:list_max_level
        \ ]
endfunction

function! mdtoc#Toc(format, ...) abort
  call s:InsertToc(
        \ a:format,
        \ get(a:, 1, ''),
        \ get(a:, 2, '')
        \ )
endfunction

function! mdtoc#TocDelete() abort
  call s:DeleteToc()
endfunction

function! mdtoc#TocUpdate() abort
  let [l:line_number, l:list_format, l:list_ignore, l:list_max_level] = s:DeleteToc()
  let l:winview = winsaveview()

  call cursor(l:line_number - 1, 1)
  call s:InsertToc(
        \ l:list_format,
        \ l:list_max_level,
        \ l:list_ignore
        \ )
  call winrestview(l:winview)
endfunction
