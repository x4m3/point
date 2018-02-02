set colorcolumn=80
set number
set modeline
set fileformat = unix
set encoding = utf-8
filetype indent plugin on
syntax on

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
let g:header_auto_add_header = 0
let g:header_field_author = 'Philippe Loctaux'
let g:header_field_author_email = 'loctauxphilippe@gmail.com'
let g:header_field_modified_by = 0
let g:header_field_timestamp = 0
let g:header_field_modified_timestamp = 0

"nerdtree stuff
"open tree if no files are edited
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

"window navigation
"see :help key-notation
map <C-N>m :new<CR>
map <C-N>n :q<CR>
noremap <TAB> <C-W>w

"see tabs as characters
set list
set listchars=tab:>-

" no arrow keys!
" thx http://bondoer.fr
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
