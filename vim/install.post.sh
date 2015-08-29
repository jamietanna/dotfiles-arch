#!/bin/bash

mkdir -p $HOME/.vim/bundle
cd $HOME/.vim/bundle
git clone https://github.com/tpope/vim-pathogen

git clone https://github.com/wincent/command-t
(
	cd command-t
	cd ruby/command-t
	ruby extconf.rb
	make
)

