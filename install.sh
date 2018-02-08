#!/bin/bash
#

if [ "$1" == "git" ] ; then
	cd git
	./install.sh
fi

if [ "$1" == "vim" ] ; then
	cd vim
	./install.sh
fi

if [ "$1" == "gpg" ] ; then
	cd gpg 
	./install.sh
fi

if [ "$1" == "zsh" ] ; then
	cd zsh 
	./install.sh
fi

if [ "$1" == "i3" ] ; then
	cd i3
	./install.sh
fi

if [ "$1" == "xinitrc" ] ; then
	ln -s ~/point/xinitrc ~/.xinitrc
	echo "linked"
fi
