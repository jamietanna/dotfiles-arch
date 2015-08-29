function! BuildCommandT(info)
    " info is a dictionary with 3 fields
    " - name:   name of the plugin
    " - status: 'installed', 'updated', or 'unchanged'
    " - force:  set on PlugInstall! or PlugUpdate!
    if a:info.status == 'installed' || a:info.force
        !$HOME/dotfiles-arch/vim/install.commandt.sh
    endif
endfunction

function! BuildYCM(info)
    " info is a dictionary with 3 fields
    " - name:   name of the plugin
    " - status: 'installed', 'updated', or 'unchanged'
    " - force:  set on PlugInstall! or PlugUpdate!
    if a:info.status == 'installed' || a:info.force
        !$HOME/dotfiles-arch/vim/install.ycm.sh
    endif
endfunction


call plug#begin('~/.vim/plugged')

Plug 'Wincent/command-t/', { 'do': function('BuildCommandT') }
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
Plug 'Airblade/vim-gitgutter'
Plug 'Tpope/vim-fugitive'
" Eclim can be installed automagically via the AUR

call plug#end()




""" General settings

set tabstop=4
set shiftwidth=4
" tab master race
set noexpandtab

" searching is now much easier
set ignorecase smartcase incsearch

" need syntax highlighting
syntax on

" force markdown syntax
au BufRead,BufNewFile *.md set filetype=markdown

" highlight matches
set hlsearch
" and make sure we can toggle it with a CR
:nnoremap <CR> :nohlsearch<cr>

" use comma as a leader - more convenient than \
let mapleader = ","

" resume at our last position (:help last-position-jump)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

autocmd FileType cpp    let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_files/cpp/.ycm_extra_conf.py'

let g:ycm_semantic_triggers =  {
\   'c' : ['->', '.'],
\   'objc' : ['->', '.'],
\   'ocaml' : ['.', '#'],
\   'cpp,objcpp' : ['->', '.', '::'],
\   'perl' : ['->'],
\   'php' : ['->', '::'],
\   'cs,java,javascript,d,python,perl6,scala,vb,elixir,go' : ['.'],
\   'vim' : ['re![_a-zA-Z]+[_\w]*\.'],
\   'ruby' : ['.', '::'],
\   'lua' : ['.', ':'],
\   'erlang' : [':'],
\ }


let g:EclimCompletionMethod = 'omnifunc'
