#!/bin/sh
#

echo "install 'isync'"

# email folders
mkdir -p ~/.mail
chmod 700 ~/.mail -R
mkdir -p ~/.mail/plcom
mkdir -p ~/.mail/epitech
mkdir -p ~/.mail/aer
mkdir -p ~/.mail/gmail


ln -s ~/point/email/sync/mbsyncrc ~/.mbsyncrc

echo "done"
