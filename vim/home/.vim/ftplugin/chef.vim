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
		\ 'resources/*.rb': {
			\ 'type': 'resource',
			\ 'alternate': 'spec/unit/resources/{}_spec.rb'
			\ },
		\ 'spec/unit/resources/*_spec.rb': {
			\ 'type': 'spec',
			\ 'alternate': 'resources/{}.rb',
			\ 'dispatch': 'rspec {file}'
		\ },
		\ 'providers/*.rb': {
			\ 'type': 'provider',
			\ 'alternate': 'spec/unit/providers/{}_spec.rb'
			\ },
		\ 'spec/unit/providers/*_spec.rb': {
			\ 'type': 'spec',
			\ 'alternate': 'providers/{}.rb',
			\ 'dispatch': 'rspec {file}'
		\ }
	\ }
\ }
