" File              : .vimrc
" Author            : Philippe Loctaux <loctauxphilippe@gmail.com>
" Date              : 09.12.2017
" Last Modified Date: 27.12.2017
" Last Modified By  : Philippe Loctaux <loctauxphilippe@gmail.com>

let g:name = 'Philippe Loctaux'
let g:mail = 'loctauxphilippe@gmail.com'

set colorcolumn=80
syntax on
set number

"macros and maps
map <F2> aPhilippe Loctaux <loctauxphilippe@gmail.com><ESC><CR>
map <F3> aSigned-off-by: Philippe Loctaux <loctauxphilippe@gmail.com><ESC><CR>
map <F4> :AddHeader<CR>
map <F5> :NERDTreeToggle<CR>
map <F6> :UndotreeToggle<cr>

"vim-plug stuff
call plug#begin('~/.vim/plugged')

Plug 'alpertuna/vim-header'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'godlygeek/tabular'
Plug 'mbbill/undotree'

call plug#end()

"vim-header stuff
let g:header_field_author = g:name
let g:header_field_author_email = g:mail
let g:header_auto_add_header = 0

"nerdtree stuff
"open tree if no files are edited
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

"window navigation
"see :help key-notation
map <C-N>m :new<CR>
map <C-N>n :q<CR>
noremap <TAB> <C-W>w
