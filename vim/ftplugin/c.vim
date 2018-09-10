filetype plugin indent on

" turn on syntax highlighting
syntax on

" force c indentation
setlocal cindent

" define indentation
setlocal tabstop=8
setlocal shiftwidth=8
setlocal softtabstop=8

" show colorbar at column 80
setlocal colorcolumn=80

" insert real tabs, no spaces
setlocal noexpandtab

" highlight leading and trailing spaces
syn match ErrorLeadSpace /^ \+/
syn match ErrorTailSpace / \+$/
