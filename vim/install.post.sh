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

echo -e "\033[33mWARNING: This next step will max out your CPU while compiling. Please ^C and comment out the following steps if you wish.\033[0m"
read
sudo pacman -S clang cmake
git clone https://github.com/Valloric/YouCompleteMe
(
	cd YouCompleteMe
	./install.sh --clang-completer --system-libclang
)
