#!/bin/bash
#

cp ./gpg.conf ~/.gnupg/gpg.conf;
cp ./gpg-agent.conf ~/.gnupg/gpg-agent.conf;
chmod 700 ~/.gnupg/;
chmod 600 ~/.gnupg/*;

mkdir -p ~/.config/systemd/user/;
cp ./systemd-thing ~/.config/systemd/user/gpg-agent.service;

echo "done";
