" vim: foldmethod=marker:foldlevel=0 textwidth=80 wrap
" -----------------------------------------------------------------------------
" markdown.vim
"	Markdown-specific Vim settings
" -----------------------------------------------------------------------------
" Location: $HOME/.vim/ftplugin/markdown.vim
" -----------------------------------------------------------------------------

" -----------------------------------------------------------------------------
" => Editing
" -----------------------------------------------------------------------------
"  {{{
" autoindent is really useful when we're doing things like lists
set autoindent
" spelling is essential for writing Markdown
set spell spelllang=en
" }}}

" -----------------------------------------------------------------------------
" => Aesthetics
" -----------------------------------------------------------------------------
" {{{
" Markdown looks better with only two tabs
set tabstop=2
" Corectly format italics and bold in the terminal, if supported
hi markdownItalic cterm=italic
hi markdownBold cterm=bold
hi markdownBoldItalic cterm=bold,italic
" }}}
