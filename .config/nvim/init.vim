call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'arcticicestudio/nord-vim'
Plug 'joshdick/onedark.vim'

" Initialize plugin system
call plug#end()

syntax on
set nocompatible
filetype plugin on
" Important!!
if has('termguicolors')
  set termguicolors
endif

" The configuration options should be placed before `colorscheme sonokai`.
colorscheme onedark

" Airline
let g:airline_theme='onedark'
"let g:shades_of_purple_airline = 1
"let g:airline_theme='shades_of_purple'
let g:airline_symbols = {}
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰ '
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.dirty='⚡'
let g:airline#extensions#branch#enabled = 1
let g:airline_powerline_fonts = 1

set relativenumber

set smarttab
set cindent
set tabstop=2
set shiftwidth=2

nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

