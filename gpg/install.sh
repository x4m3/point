#!/bin/bash
#

mkdir ~/.gnupg/ -p
mv ~/.gnupg/gpg.conf ~/.gnupg/gpg.conf.backup
ln -s ~/point/gpg/gpg.conf ~/.gnupg/

echo "done";
