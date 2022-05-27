call plug#begin('~/.config/nvim/plugged')
Plug 'gruvbox-community/gruvbox'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-dispatch'

Plug 'tpope/vim-abolish'
Plug 'lambdalisue/suda.vim'
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go'

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

Plug 'tpope/vim-projectionist'

call plug#end()

set background=dark
colorscheme gruvbox

lua << EOF
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  local lspconfig = require('lspconfig')
  local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
end
require'lspconfig'.tsserver.setup{
  capabilities = capabilities,
}
require'lspconfig'.solargraph.setup{
  capabilities = capabilities,
}
require'lspconfig'.gopls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}
require'lspconfig'.jsonls.setup{
  capabilities = capabilities,
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
  capabilities = capabilities,
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
require'lspconfig'.html.setup{
  capabilities = capabilities,
  cmd = { 'vscode-html-languageserver', '--stdio' },
}
require'lspconfig'.vimls.setup{
  capabilities = capabilities,
}
require'lspconfig'.terraformls.setup{
  capabilities = capabilities,
}
require'lspconfig'.yamlls.setup{
  capabilities = capabilities,

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

autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()

nnoremap <leader>f <cmd>lua vim.lsp.buf.formatting()<CR>

" https://certitude.consulting/blog/en/invisible-backdoor/
" https://stackoverflow.com/a/16988346/2257038
syntax match nonascii "[^\x00-\x7F]"
highlight nonascii guibg=Red ctermbg=1
syntax match smartquotes "[‘’“”]"
highlight! smartquotes guibg=Red ctermbg=1

lua <<EOF
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    mapping = {
              ['<C-n>'] = cmp.mapping({
            c = function()
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                else
                    vim.api.nvim_feedkeys(t('<Down>'), 'n', true) -- doesn't always work?
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                else
                    fallback()
                end
            end
        }),
        ['<C-p>'] = cmp.mapping({
            c = function()
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                else
                    vim.api.nvim_feedkeys(t('<Up>'), 'n', true)
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                else
                    fallback()
                end
            end
        }),
  --  ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
  --  ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
  --  ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
  --  ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
  --  ['<C-e>'] = cmp.mapping({
  --    i = cmp.mapping.abort(),
  --    c = cmp.mapping.close(),
  --  }),
      ['<Tab>'] = cmp.mapping.confirm({ select = true }),
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

vnoremap <leader>u y0"_DpV:'<,'>!unpack<CR>

let g:projectionist_heuristics = {
      \ "*.go":
      \ {
      \   "*.go": {
      \     "alternate": "{}_test.go",
      \     "type": "source"
      \   },
      \   "*_test.go": {
      \     "alternate": "{}.go",
      \     "type": "test"
      \   }
      \ }
      \ }

nnoremap <leader>r <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <leader>k <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <leader>l :lua vim.diagnostic.open_float()<CR>
nnoremap <leader>, :lua vim.diagnostic.goto_prev()<CR>
nnoremap <leader>. :lua vim.diagnostic.goto_next()<CR>
