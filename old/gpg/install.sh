#!/bin/bash
#

mkdir -p ~/.gnupg/
mv ~/.gnupg/gpg.conf ~/.gnupg/gpg.conf.backup
ln -s ~/point/gpg/gpg.conf ~/.gnupg/

echo "done";
