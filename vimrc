set colorcolumn=80
syntax on
set number

"macros
let @1 = 'aPhilippe Loctaux <loctauxphilippe@gmail.com>'

"vim-plug stuff
call plug#begin('~/.vim/plugged')

Plug 'alpertuna/vim-header'
Plug 'scrooloose/nerdtree'
Plug 'kien/ctrlp.vim'
Plug 'tpope/vim-fugitive'
Plug 'godlygeek/tabular'

call plug#end()

"vim-header stuff
let g:header_field_author = 'Philippe Loctaux'
let g:header_field_author_email = 'loctauxphilippe@gmail.com'
let g:header_auto_add_header = 0
map <F4> :AddHeader<CR>
