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
	Plug 'lervag/vimtex'
	Plug 'scrooloose/nerdtree'
	Plug 'vim-scripts/gitignore'
	" Eclim can be installed automagically via the AUR
call plug#end()




""" General settings

set tabstop=4
set shiftwidth=4
" tab master race
set noexpandtab

" searching is now much easier
set ignorecase smartcase incsearch

" There's no way in hell we're using any text-editor without syntax
" highlighting. Looking at you, nano.
syntax on

" force markdown syntax
au BufRead,BufNewFile TODO set filetype=markdown
" by default, vim detects .tex files as `plaintex` which doesn't automatically
" start Vimtex; this means that when we use multiple TeX files in a project,
" we now will get Vimtex working in each file out-of-the-box
au BufRead,BufNewFile *.tex set filetype=tex

au FileType markdown set tabstop=2 spell spelllang=en autoindent
au FileType tex set spell spelllang=en
au FileType gitcommit set spell spelllang=en

" highlight all instances of search results. Can be toggled off with
" `:nohlsearch` when not required any more
set hlsearch
" and make sure we can toggle it with a <leader>CR
" why <leader>? because some plugins / etc expect us to be able to <CR>
:nnoremap <leader><CR> :nohlsearch<cr>
" we want to be able to open up NERDTree in order to browse our location more
" easily. We use `T` over `t` because we're using the command-t plugin which
" hijacks <leader>t
nnoremap <leader>T :NERDTreeToggle<cr>
" it is often useful to be able to quickly switch between having spellcheck
" enabled/disabled
nnoremap <leader>s :set spell!<cr>
" when pasting from external sources, it's great to be able to (un)set `paste`
" to not mess around with line endings and wrapping
nnoremap <leader>p :set paste!<cr>

" resume at the last position we were on when we last had this file open
" (`:help last-position-jump`)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

let g:ycm_path_to_python_interpreter = '/usr/bin/python'
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

let g:vimtex_view_method = 'mupdf'

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

" ignore our git directory, which forever gets in my way
set wildignore+=**/.git/*
" ignore any generated Java class files
set wildignore+=*.class
" ignore any generated object files
set wildignore+=*.o

let NERDTreeRespectWildIgnore=1

" zsh-style tabcomplete for files. Way better than bash-style tabbing
set wildmenu
