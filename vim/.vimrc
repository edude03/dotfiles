call plug#begin('~/.vim/plug')
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-sensible'
"Plug 'tpope/vim-unimpaired'
Plug 'bling/vim-airline'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'tyrannicaltoucan/vim-quantum'
Plug 'ekalinin/Dockerfile.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'altercation/vim-colors-solarized'
Plug 'airblade/vim-gitgutter'
Plug 'vim-syntastic/syntastic'
Plug 'davidklsn/vim-sialoquent'
Plug 'zanglg/nova.vim'
Plug 'KeitaNakamura/neodark.vim'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'tpope/vim-fugitive'
Plug 'nvie/vim-flake8'
Plug 'tell-k/vim-autopep8'
Plug 'derekwyatt/vim-scala'
Plug 'Valloric/YouCompleteMe'
Plug 'tpope/vim-endwise'
Plug 'b4b4r07/vim-hcl'
Plug 'rust-lang/rust.vim'
Plug 'leafgarland/typescript-vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'Yggdroot/indentLine'
Plug 'LnL7/vim-nix'
call plug#end()

" Enable Line Numbers
set number
let g:airline_powerline_fonts = 1
" Show the name of the buffers in the tabline
let g:airline#extensions#tabline#enabled = 1

" Use spaces instead of tab char
set expandtab

" Intend by 2 chars
set shiftwidth=2
set tabstop=2

" Turn on autoindent
set autoindent

" Set color scheme
set background=dark
let g:airline_theme='quantum'
let g:quantum_italics=1
set termguicolors
colorscheme quantum

" Recommended defaults for Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_highlighting=1

" Map Nerdtree to \n
 map <Leader>n <plug>NERDTreeTabsToggle<CR>
 
 imap <Tab> <C-P>


