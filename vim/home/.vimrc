runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

""" General settings

set tabstop=4
set shiftwidth=4
" tab master race
set noexpandtab

" need syntax highlighting
syntax on

au BufRead,BufNewFile *.md set filetype=markdown
