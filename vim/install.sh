#!/bin/bash

rm -rf ~/.vimrc ~/.vim/
echo "removing old vim config and plugins"

mkdir -p ~/.vim/ ~/.vim/backup/ ~/.vim/swap/ ~/.vim/undo/ ~/.vim/autoload/
ln -s ~/point/vim/vimrc-light ~/.vimrc
ln -s ~/point/vim/gvimrc ~/.gvimrc
ln -s ~/point/vim/ideavimrc ~/.ideavimrc
echo "config ready"

echo "dont forget to run :PlugInstall to install all the plugins to vim"

echo "bye"
