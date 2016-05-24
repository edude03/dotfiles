call plug#begin('~/.vim/plug')
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-sensible'
Plug 'bling/vim-airline'
call plug#end()

set number
let g:airline_powerline_fonts = 1

" Use spaces instead of tab char
set expandtab

" Intend by 2 chars
set shiftwidth=2

" Turn on autoindent
set autoindent

