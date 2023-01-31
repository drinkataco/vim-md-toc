#!/usr/bin/env bash
cd "$(dirname "${BASH_SOURCE[0]}")" || exit

VIM_CMD=${VIM_CMD:-'vim'}
VIM_FLAGS=${VIM_FLAGS:-'-N'}
VIM_PLUGINS=${VIM_PLUGINS:-'~/.vim/bundle'}

eval "${VIM_CMD}" "${VIM_FLAGS}" -u <(cat << VIMRC
  filetype off
  set rtp+=${VIM_PLUGINS}/vader.vim
  set rtp+=.
  set rtp+=..
  filetype plugin indent on
VIMRC
) -c 'Vader! feature/update.vader'
