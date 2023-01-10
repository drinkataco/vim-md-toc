if exists('g:autoloaded_md_toc')
  finish
endif
let g:autoloaded_mdtoc = 1

function! mdtoc#GenerateToc()
  if &filetype !=# 'markdown'
    echo 'Filetype must be Markdown'
    return
  endif
endfunction
