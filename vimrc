" File              : .vimrc
" Author            : Philippe Loctaux <loctauxphilippe@gmail.com>
" Date              : 09.12.2017
" Last Modified Date: 12.12.2017
" Last Modified By  : Philippe Loctaux <loctauxphilippe@gmail.com>

set colorcolumn=80
syntax on
set number

"macros
let @1 = 'aPhilippe Loctaux <loctauxphilippe@gmail.com>'

"vim-plug stuff
call plug#begin('~/.vim/plugged')

Plug 'alpertuna/vim-header'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'godlygeek/tabular'

call plug#end()

"vim-header stuff
let g:header_field_author = 'Philippe Loctaux'
let g:header_field_author_email = 'loctauxphilippe@gmail.com'
let g:header_auto_add_header = 0
map <F4> :AddHeader<CR>

"nerdtree stuff
map <F5> :NERDTreeToggle<CR>
"open tree if no files are edited
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
