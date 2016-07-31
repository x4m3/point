#!/bin/bash
#

cp ./gpg.conf ~/.gnupg/gpg.conf
cp ./gpg-agent.conf ~/.gnupg/gpg-agent.conf
chmod 600 ~/.gnupg/*;
echo "done"
