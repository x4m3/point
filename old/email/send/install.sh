#!/bin/sh
#

echo "install 'msmtp'"

# msmtp
ln -s ~/point/email/send/msmtprc ~/.msmtprc
chmod 600 ~/.msmtprc

echo "done"
