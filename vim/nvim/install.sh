#!/bin/sh
#

rm -rf $HOME/.config/nvim
mkdir -p $HOME/.config/nvim
ln -s $(realpath ./init.lua) $HOME/.config/nvim/init.lua
