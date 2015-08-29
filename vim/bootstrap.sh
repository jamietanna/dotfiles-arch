#!/usr/bin/env bash

mkdir -p $HOME/.vim
cd $HOME/.vim

mkdir -p $HOME/.vim/autoload
if [[ ! -e $HOME/.vim/vim-plug ]];
then
	git clone https://github.com/junegunn/vim-plug
	ln -s $HOME/.vim/vim-plug/plug.vim autoload/plug.vim
fi

echo -e "\033[33mWARNING: This next step will max out your CPU and memory while compiling. Press <CR> to continue.\033[0m"
read

vim +PlugInstall +qall
