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
