" vim config
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

" let g:airline_theme='quantum'
" let g:quantum_italics=1
set termguicolors
" colorscheme quantum

" Oceanic Next settings
syntax enable
colorscheme OceanicNext
let g:airline_theme='oceanicnext'

" Highlight the current line
set cursorline

" Enable indent guide on startup
let g:indent_guides_enable_on_vim_startup = 1

" Enables block folding
set foldmethod=syntax

" Easy clearing of last search term
nnoremap <CR> :noh<CR><CR>

function! s:find_files()
let git_dir = system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
if git_dir !=# '''
call fzf#vim#gitfiles(git_dir, fzf#vim#with_preview('right'))
else
call fzf#vim#files('.', fzf#vim#with_preview('right'))
endif
endfunction
command! ProjectFiles execute s:find_files()
nnoremap <silent> <C-p> :ProjectFiles<CR>
''