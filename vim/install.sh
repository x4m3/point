#!/bin/bash

mkdir -p ~/.vim/
ln -s ~/point/vim/vimrc ~/.vimrc
echo "config ready" 

curl -sfLo ~/.vim/autoload/plug.vim --create-dirs \
https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "vim plug installed"
echo "run :PlugInstall to install all the plugins to vim"

echo "bye"
