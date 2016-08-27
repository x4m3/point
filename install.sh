#!/bin/bash
#

mkdir -p ~/.gnupg/;

cp ./gpg.conf ~/.gnupg/gpg.conf;
cp ./gpg-agent.conf ~/.gnupg/gpg-agent.conf;
chmod 700 ~/.gnupg/;
chmod 600 ~/.gnupg/*;

echo "done";
