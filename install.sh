#!/bin/bash

mkdir -p ~/.vim/

cp ./vimrc ~/.vim/vimrc
ln -s ~/.vim/vimrc ~/.vimrc;
echo "config copied and linked"

curl -sfLo ~/.vim/autoload/plug.vim --create-dirs \
https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "vim plug installed"

echo "bye"
