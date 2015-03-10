runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

""" General settings

set tabstop=4
set shiftwidth=4
" tab master race
set noexpandtab

set ignorecase smartcase

" need syntax highlighting
syntax on

" force markdown syntax
au BufRead,BufNewFile *.md set filetype=markdown


" use comma as a leader - more convenient than \
let mapleader = ","

" resume at our last position (:help last-position-jump)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
