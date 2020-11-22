" vim: foldmethod=marker:foldlevel=0 textwidth=80 wrap
" -----------------------------------------------------------------------------
" vimrc
"	My configuration settings for Vim
" -----------------------------------------------------------------------------
" Location: $HOME/.vimrc
" -----------------------------------------------------------------------------

" -----------------------------------------------------------------------------
" => Vim plugins
" -----------------------------------------------------------------------------
" {{{
call plug#begin('~/.vim/plugged')
	" -------------------------------------------------------------------------
	" => Appearance
	" -------------------------------------------------------------------------
	" {{{
	Plug 'gruvbox-community/gruvbox'
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
	Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets' "{{{
	let g:UltiSnipsSnippetDirectories=["mysnippets"]
	" better key bindings for UltiSnipsExpandTrigger
	let g:UltiSnipsExpandTrigger = "<tab>"
	let g:UltiSnipsJumpForwardTrigger = "<tab>"
	let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
	let g:UltiSnipsListSnippets = "<c-l>"

	let g:snips_author = "Jamie Tanna"
	"  }}}
	" }}}

	" -------------------------------------------------------------------------
	" => Completion
	" -------------------------------------------------------------------------
	"  {{{
	Plug 'vim-ruby/vim-ruby', { 'for': 'ruby'}
	" https://github.com/vim-ruby/vim-ruby/issues/357
	packadd! matchit
	Plug 'Shougo/deoplete.nvim' "{{{
	let g:deoplete#enable_at_startup = 1
	Plug 'roxma/nvim-yarp'
	Plug 'roxma/vim-hug-neovim-rpc'
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

	" Ruby/Chef {{{
	Plug 'tpope/vim-rake' | Plug 'tpope/vim-projectionist'
	" }}}

	" }}}

	" -------------------------------------------------------------------------
	" => Linting
	" -------------------------------------------------------------------------
	" {{{
	Plug 'w0rp/ale'
	" }}}

	" -------------------------------------------------------------------------
	" => TODO Uncategorised
	" -------------------------------------------------------------------------
	" {{{
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-dispatch'
	" Plug 'tpope/vim-markdown'
	Plug 'ludwig/split-manpage.vim'
	Plug 'junegunn/fzf' | Plug 'junegunn/fzf.vim'
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
" Asciicasts are just JSON files
au BufRead,BufNewFile *.cast set filetype=json
" }}}

" -----------------------------------------------------------------------------
" => Aesthetics
" -----------------------------------------------------------------------------
" {{{
" fix our SignColumn - make sure we have proper colour highlighting!
hi clear SignColumn

set termguicolors " Enable true color support
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

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

nnoremap <leader>< :cprev<cr>
nnoremap <leader>> :cnext<cr>
nnoremap <leader>l :copen<cr>
nnoremap <leader>t :w<cr>:Dispatch<cr>
nnoremap <leader>y "+y

" -----------------------------------------------------------------------------
" => Plugin Settings
" -----------------------------------------------------------------------------
" {{{

" -----------------------------------------------------------------------------
" => Vimtex
" -----------------------------------------------------------------------------
" {{{
let g:vimtex_view_method = 'mupdf'
let g:tex_flavor = 'latex'
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

if filereadable(expand("~/.vimrc.local"))
	source ~/.vimrc.local
endif

nnoremap <leader>< :cprev<CR>
nnoremap <leader>> :cnext<CR>
nnoremap <leader>l :copen<CR>

" Modified version of Doug Ireton's ftdetect/chef {{{
" Licensed under the Apache License, Version 2.0 (the "License");
" you may not use this file except in compliance with the License.
" You may obtain a copy of the License at

"     http://www.apache.org/licenses/LICENSE-2.0

" Unless required by applicable law or agreed to in writing, software
" distributed under the License is distributed on an "AS IS" BASIS,
" WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
" See the License for the specific language governing permissions and
" limitations under the License.

autocmd BufNewFile,BufRead * if expand('%:p') =~'**/*/.*cookbook.*/.*\(attributes\|definitions\|libraries\|providers\|recipes\|resources\)/.*\.rb' | set filetype=ruby.chef | endif
autocmd BufNewFile,BufRead * if expand('%:p') =~'**/*/.*cookbook.*/metadata\.rb' | set filetype=ruby.chef | endif
autocmd BufNewFile,BufRead * if expand('%:p') =~'**/*/.*cookbook.*/templates/' | set filetype=eruby.chef | endif
" }}}

" TODO: It looks like we need this to be set before referencing it, otherwise it
" doesn't work?
let g:projectionist_heuristics = {}

call deoplete#custom#option('smart_case', 1)
" }}}
