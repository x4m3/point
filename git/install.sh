#!/bin/bash
#

rm -rf ~/.gitconfig ~/.gitignore
echo "removed old git config"
echo ""

ln -s ~/point/git/.gitconfig ~/
ln -s ~/point/git/.gitignore ~/

echo "install msmtp lolcommits"
echo "make sure of the login username "
echo "check the pgp key"
echo ""
echo "done"
