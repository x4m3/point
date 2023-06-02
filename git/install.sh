#!/bin/bash
#

rm -f ~/.gitconfig
echo "removed old git config"

ln -s ~/point/git/gitconfig ~/.gitconfig

echo "install git-delta https://dandavison.github.io/delta/"

echo ""
echo "done"
