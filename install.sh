#!/bin/bash

cp ./dot-vimrc ~/.vimrc
echo "config copied"

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "vim plug installed"

echo "bye"
