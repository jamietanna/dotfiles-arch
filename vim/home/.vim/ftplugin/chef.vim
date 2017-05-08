let g:projectionist_heuristics = {
	\ 'recipes/*.rb': {
		\ 'alternate': 'spec/unit/recipes/{}_spec.rb'
		\ },
	\ 'spec/unit/recipes/*_spec.rb': {
		\ 'type': 'spec',
		\ 'alternate': 'recipes/{}.rb'
	\ }
\ }
