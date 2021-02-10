#!/bin/bash
#

rm -f ~/.gitconfig
echo "removed old git config"

ln -s ~/point/git/gitconfig ~/.gitconfig

echo ""
echo "done"
