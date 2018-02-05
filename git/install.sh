#!/bin/bash
#

ln -s ~/.gitconfig ./gitconfig
ln -s ~/.gitignore_global ./gitignore_global
ln -s ~/.git_template ./git_template/

echo "install msmtp lolcommits"
echo "make sure of the login username "
echo "check the pgp key"
echo ""
echo "to get git credential helper"
echo ""
echo "ubuntu"
echo "1. sudo apt install libgnome-keyring-dev"
echo "2. sudo make --directory=/usr/share/doc/git/contrib/credential/gnome-keyring"
echo "3. git config --global credential.helper /usr/share/doc/git/contrib/credential/gnome-keyring/git-credential-gnome-keyring"
echo ""
echo "arch"
echo "1. sudo pacman -S libgnome-keyring"
echo "2. cd /usr/share/git/credential/gnome-keyring && sudo make"
echo "3. git config --global credential.helper /usr/lib/git-core/git-credential-gnome-keyring"

echo "done"
