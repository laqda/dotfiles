execute pathogen#infect()
syntax on
filetype plugin indent on

set number
set updatetime=100
"set signcolumn=yes
set backspace=indent,eol,start

syntax enable
set laststatus=2

" start nerdtree if no file specified

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" vim plug

call plug#begin('~/.vim/plugged')

" theme

Plug 'doums/darcula'

" fzf

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" gui

Plug 'preservim/nerdtree'

" git

Plug 'airblade/vim-gitgutter'

" languages

Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'

call plug#end()

colorscheme darcula

let g:gitgutter_sign_allow_clobber = 1

" shortcuts

map <C-p> :NERDTreeToggle<CR>
map <C-e> :Buffers<CR>
map <C-o> :Files<CR>

