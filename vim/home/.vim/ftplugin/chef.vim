nnoremap <leader>t :w<CR>:Dispatch<CR>

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
