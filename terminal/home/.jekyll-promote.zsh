jekyll_promote() {
	git mv "_drafts/$1" "_posts/$(date -I)-$1"
}

compdef '_path_files -W $PWD/_drafts' jekyll_promote
