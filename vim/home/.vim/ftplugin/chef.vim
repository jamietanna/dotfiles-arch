nnoremap <leader>t :w<CR>:Dispatch chef exec rspec %<CR>

let g:projectionist_heuristics = {
	\ '*': {
		\ '*': {
		\   'make': 'rake'
		\ },
		\ 'recipes/*.rb': {
			\ 'type': 'recipe',
			\ 'alternate': 'spec/unit/recipes/{}_spec.rb'
			\ },
		\ 'spec/unit/recipes/*_spec.rb': {
			\ 'type': 'spec',
			\ 'alternate': 'recipes/{}.rb',
			\ 'dispatch': 'rspec {file}'
		\ },
	\ }
\ }
