set fdm=indent
set et ts=4 sw=4

" Use Dispatch to save our file, and run our unittests
nnoremap <leader>t :w<CR>:Dispatch python -m unittest discover<CR>
