nnoremap <leader>t :w<CR>:Dispatch chef exec rspec %<CR>

let g:projectionist_heuristics = {
	\ 'recipes/*.rb': {
		\ 'alternate': 'spec/unit/recipes/{}_spec.rb'
		\ },
	\ 'spec/unit/recipes/*_spec.rb': {
		\ 'type': 'spec',
		\ 'alternate': 'recipes/{}.rb'
	\ }
\ }
