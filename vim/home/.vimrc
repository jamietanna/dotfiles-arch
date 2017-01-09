" vim: foldmethod=marker:foldlevel=0 textwidth=80 wrap
" -----------------------------------------------------------------------------
" vimrc
"	My configuration settings for Vim
" -----------------------------------------------------------------------------
" Location: $HOME/.vimrc
" -----------------------------------------------------------------------------

" -----------------------------------------------------------------------------
" => Build functions for Vim plugins
" -----------------------------------------------------------------------------
" {{{
" }}}

" -----------------------------------------------------------------------------
" => Vim plugins
" -----------------------------------------------------------------------------
" {{{
call plug#begin('~/.vim/plugged')
	" -------------------------------------------------------------------------
	" => Appearance
	" -------------------------------------------------------------------------
	" {{{
	Plug 'morhetz/gruvbox'
	" }}}

	" -------------------------------------------------------------------------
	" => Project navigation
	" -------------------------------------------------------------------------
	" {{{
	" }}}

	" -------------------------------------------------------------------------
	" => Source control
	" -------------------------------------------------------------------------
	" {{{
	Plug 'Airblade/vim-gitgutter'
	Plug 'Tpope/vim-fugitive'
	" }}}

	" -------------------------------------------------------------------------
	" => Editing
	" -------------------------------------------------------------------------
	" {{{
	" better search and replace
	Plug 'tpope/vim-abolish'
	" essential for TeX editing
	Plug 'lervag/vimtex'
	" }}}

	" -------------------------------------------------------------------------
	" => Snippets
	" -------------------------------------------------------------------------
	"  {{{
	Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
	" }}}

	" -------------------------------------------------------------------------
	" => Completion
	" -------------------------------------------------------------------------
	"  {{{
	Plug 'Shougo/neocomplete.vim' "{{{
	let g:neocomplete#enable_at_startup = 1
	let g:neocomplete#enable_smart_case = 1
	"}}}
	" }}}

	" -------------------------------------------------------------------------
	" => Tags
	" -------------------------------------------------------------------------
	"  {{{
	Plug 'majutsushi/tagbar' , { 'on': ['Tagbar'] }
	Plug 'Xolox/vim-easytags' | Plug 'Xolox/vim-misc'
	" }}}

	" -------------------------------------------------------------------------
	" => Wildignore
	"  Plugins that ignore certain filetypes for us
	" -------------------------------------------------------------------------
	" {{{
	Plug 'vim-scripts/gitignore'
	" TODO remove this; it can be done manually, without another dependency!
	Plug 'johnantoni/vim-wildignore'
	" }}}

	" -------------------------------------------------------------------------
	" => Language-specific
	" -------------------------------------------------------------------------
	"  {{{
	" essential for TeX editing
	Plug 'lervag/vimtex'
	" }}}

	" -------------------------------------------------------------------------
	" => TODO Uncategorised
	" -------------------------------------------------------------------------
	" {{{
	Plug 'scrooloose/syntastic'
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-dispatch'
	" Plug 'tpope/vim-markdown'
	Plug 'ludwig/split-manpage.vim'
	" }}}
call plug#end()
" }}}

" -----------------------------------------------------------------------------
" => Global settings
" -----------------------------------------------------------------------------
" {{{
" There's no way in hell we're using any text-editor without syntax
" highlighting. Looking at you, nano.
syntax on

" let us use custom filetypes
filetype plugin on

set tabstop=4
set shiftwidth=4
" tab master race
set noexpandtab

" resume at the last position we were on when we last had this file open
" (`:help last-position-jump`)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" ignore our git directory, which forever gets in my way
set wildignore+=**/.git/*
" ignore any generated Java class files
set wildignore+=*.class
" ignore any generated object files
set wildignore+=*.o

set wildignore+=.svn,CVS,.git
"*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,,*.xpm,*.gif,*.pdf,*.bak,*.beam

" }}}

" -----------------------------------------------------------------------------
" => Filetypes
" -----------------------------------------------------------------------------
" {{{
" force markdown syntax
au BufRead,BufNewFile TODO set filetype=markdown
" by default, vim detects .tex files as `plaintex` which doesn't automatically
" start Vimtex; this means that when we use multiple TeX files in a project,
" we now will get Vimtex working in each file out-of-the-box
au BufRead,BufNewFile *.tex set filetype=tex
" }}}

" -----------------------------------------------------------------------------
" => Aesthetics
" -----------------------------------------------------------------------------
" {{{
" fix our SignColumn - make sure we have proper colour highlighting!
hi clear SignColumn

set background=dark
colorscheme gruvbox

" https://github.com/theycallmeswift/dotfiles/blob/master/vimrc#L60
" TODO set wildmode=list:longest,full  " command <Tab> completion, list matches, then longest common part, then all.

" show what command we're currently setting
set showcmd

" zsh-style tabcomplete for files. Way better than bash-style tabbing
set wildmenu

set statusline=%f
" }}}

" -----------------------------------------------------------------------------
" => Searching
" -----------------------------------------------------------------------------
" {{{
" searching is now much easier
" TODO why? what makes them better?
set ignorecase smartcase incsearch

" highlight all instances of search results. Can be toggled off with
" `:nohlsearch` when not required any more
set hlsearch

" }}}

" -----------------------------------------------------------------------------
" => Mappings
" -----------------------------------------------------------------------------
" {{{
" use <space> as leader due to its ergonomic location - meaning that we can
" hit it with either hand - as well as making it much larger, and easier to
" hit, too
let mapleader = "\<Space>"

" and make sure we can toggle it with a <leader>CR
" why <leader>? because some plugins / etc expect us to be able to <CR>
:nnoremap <leader><CR> :nohlsearch<cr>
" it is often useful to be able to quickly switch between having spellcheck
" enabled/disabled
nnoremap <leader>s :set spell!<cr>
" when pasting from external sources, it's great to be able to (un)set `paste`
" to not mess around with line endings and wrapping
nnoremap <leader>p :set paste!<cr>

" allow us to save a file if we forgot to open with sudo
cmap w!! w !sudo tee > /dev/null %
" Allow us to much more easily paste into Vim terminal windows
nnoremap <leader>p :set paste!<cr>
" Allow us to use n<leader>[oO] to create a number of lines above, below the
" current one
nnoremap <leader>o o<esc>
nnoremap <leader>O O<esc>
" }}}

" -----------------------------------------------------------------------------
" => Plugin Settings
" -----------------------------------------------------------------------------
" {{{

" -----------------------------------------------------------------------------
" => Ultisnips
" -----------------------------------------------------------------------------
"  {{{
" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:UltiSnipsListSnippets = "<c-l>"

let g:UltiSnipsSnippetDirectories=["UltiSnips", "mysnippets"]
let g:snips_author = "Jamie Tanna"
"  }}}

" -----------------------------------------------------------------------------
" => Syntastic
" -----------------------------------------------------------------------------
" {{{
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
" }}}

" -----------------------------------------------------------------------------
" => Vimtex
" -----------------------------------------------------------------------------
" {{{
let g:vimtex_view_method = 'mupdf'
" }}}

" -----------------------------------------------------------------------------
" => Vim-Markdown
" -----------------------------------------------------------------------------
" {{{
" TODO why does this break syntax highlighting??
" https://github.com/tpope/vim-markdown/issues/89
" let g:markdown_fenced_languages = ['html', 'css', 'python', 'ruby', 'java', 'xml']
" }}}

" }}}

" -----------------------------------------------------------------------------
" => Editing
" -----------------------------------------------------------------------------
" {{{
" remove trailing whitespace on write
autocmd BufWritePre * :%s/\s\+$//e
" }}}

" -----------------------------------------------------------------------------
" => TODO Uncategorised
" -----------------------------------------------------------------------------
" {{{
augroup myvimrc
au!
    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

" }}}
