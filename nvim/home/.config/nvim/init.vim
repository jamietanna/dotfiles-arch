call plug#begin('~/.config/nvim/plugged')
Plug 'gruvbox-community/gruvbox'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-dispatch'

Plug 'tpope/vim-abolish'
Plug 'lambdalisue/suda.vim'
Plug 'airblade/vim-gitgutter'

	Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets' "{{{
	let g:UltiSnipsSnippetDirectories=["mysnippets"]
	" better key bindings for UltiSnipsExpandTrigger
	let g:UltiSnipsExpandTrigger = "<tab>"
	let g:UltiSnipsJumpForwardTrigger = "<tab>"
	let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
	let g:UltiSnipsListSnippets = "<c-l>"

	let g:snips_author = "Jamie Tanna"
	"  }}}


Plug 'hrsh7th/cmp-nvim-lsp' | Plug 'hrsh7th/cmp-buffer' | Plug 'hrsh7th/cmp-path' | Plug 'hrsh7th/cmp-cmdline' | Plug 'hrsh7th/nvim-cmp'

Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

Plug 'aklt/plantuml-syntax'

call plug#end()

set background=dark
colorscheme gruvbox

lua << EOF
require'lspconfig'.tsserver.setup{}
require'lspconfig'.solargraph.setup{}
require'lspconfig'.gopls.setup{}
require'lspconfig'.jsonls.setup{
  cmd = { 'vscode-json-languageserver', '--stdio' },
  commands = {
    Format = {
      function()
        vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
      end
      }
    }
}
require'lspconfig'.efm.setup{
  init_options = {documentFormatting = true},
    filetypes = {"sh"},
    settings = {
        rootMarkers = {".git/"},
        languages = {
            sh = {
              {lintCommand = 'shellcheck -f gcc -x', lintSource = 'shellcheck', lintFormats= {'%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m', '%f:%l:%c: %tote: %m'}}
            }
        }
    }
}
EOF


" use <space> as leader due to its ergonomic location - meaning that we can
" hit it with either hand - as well as making it much larger, and easier to
" hit, too
let mapleader = "\<Space>"

" and make sure we can toggle it with a <leader>CR
" why <leader>? because some plugins / etc expect us to be able to <CR>
:nnoremap <leader><CR> :nohlsearch<cr>
" when pasting from external sources, it's great to be able to (un)set `paste`
" to not mess around with line endings and wrapping
nnoremap <leader>p :set paste!<cr>

" allow us to save a file if we forgot to open with sudo
cmap w!! SudaWrite

nnoremap <leader>< :cprev<cr>
nnoremap <leader>> :cnext<cr>
nnoremap <leader>y "+y


set ignorecase

au BufRead,BufNewFile *.html.md.erb set filetype=html.eruby
au BufRead,BufNewFile *.html.erb set filetype=html.eruby

" TODO: ftplugin

" remove trailing whitespace on write
autocmd BufWritePre * :%s/\s\+$//e


nnoremap <leader>f <cmd>lua vim.lsp.buf.formatting()<CR>

" https://certitude.consulting/blog/en/invisible-backdoor/
" https://stackoverflow.com/a/16988346/2257038
syntax match nonascii "[^\x00-\x7F]"
highlight nonascii guibg=Red ctermbg=1

lua <<EOF
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    mapping = {
      -- ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      -- ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      -- ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      -- ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      -- ['<C-e>'] = cmp.mapping({
      --   i = cmp.mapping.abort(),
      --   c = cmp.mapping.close(),
      -- }),
      -- ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'ultisnips' },
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  local lspconfig = require('lspconfig')
  --for key,server in pairs(lspconfig.available_servers()) do
  ----  lspconfig[server].setup {
  ----    capabilities = capabilities
  ----  }
  --end
EOF

set et ts=2 sw=2

augroup myvimrc
au!
    au BufWritePost init.vim,init.lua so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

set lazyredraw
set linebreak


let g:firenvim_config = {
    \ 'localSettings': {
    \ },
    \ 'globalSettings': {
        \ '<C-n>': 'default',
    \ }
\ }
let fc = g:firenvim_config['localSettings']
let fc['.*'] = { 'takeover': 'never' }
" TODO

if exists('g:started_by_firenvim')
  " TODO call LspStop
end

packadd! matchit

set wildignore+=node_modules
