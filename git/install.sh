#!/bin/bash
#

rm -rf ~/.gitconfig ~/.gitignore ~/.git_template
echo "removed old git config"
echo ""

ln -s ~/point/git/.gitconfig ~/
ln -s ~/point/git/.gitignore ~/
ln -s ~/point/git/.git_template ~/

echo "install msmtp lolcommits"
echo "make sure of the login username "
echo "check the pgp key"
echo ""
echo "done"
