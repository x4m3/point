#!/bin/sh
#

rm -rf ~/.vimrc ~/.vim/
echo "removing old vim config and plugins"

ln -s ~/point/vim/vimrc ~/.vimrc
ln -s ~/point/vim/gvimrc ~/.gvimrc
ln -s ~/point/vim/ideavimrc ~/.ideavimrc
echo "config ready"
mkdir -p ~/.vim/
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall

echo "bye"
