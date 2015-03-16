#!/bin/bash

mkdir -p $HOME/.vim
cd $HOME/.vim
git clone https://github.com/junegunn/vim-plug
mkdir -p $HOME/.vim/autoload
ln -s $HOME/.vim/vim-plug/plug.vim autoload/plug.vim

echo "To install, run \`:PlugInstall\` inside Vim"
echo -e "\033[33mWARNING: This next step will max out your CPU while compiling. Please ^C and comment out the following steps if you wish.\033[0m"
read
