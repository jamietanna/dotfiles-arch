jekyll_promote() {
	set -x
	git mv "_drafts/$1" "_posts/$(date -I)-$1"
	set +x
}

compdef '_path_files -W $PWD/_drafts' jekyll_promote
