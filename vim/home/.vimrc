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
	Plug 'morhetz/gruvbox'
	Plug 'scrooloose/syntastic'
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
au BufRead,BufNewFile TODO,*.md set filetype=markdown tabstop=2 spell spelllang=en autoindent

au FileType gitcommit set spell spelllang=en

" highlight matches
set hlsearch
" and make sure we can toggle it with a <leader>CR
" why <leader>? because some plugins / etc expect us to be able to <CR>
:nnoremap <leader><CR> :nohlsearch<cr>

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

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1

let g:EclimCompletionMethod = 'omnifunc'

augroup myvimrc
au!
    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

" fix our SignColumn - make sure we have proper colour highlighting!
hi clear SignColumn

set background=dark
colorscheme gruvbox

" allow us to save a file if we forgot to open with sudo
cmap w!! w !sudo tee > /dev/null %
