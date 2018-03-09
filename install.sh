# install.sh
#

echo "Install packages 'mutt', 'msmtp', 'offlineimap', 'w3m' and 'eog'"
echo

echo "edit ~/.offlineimaprc"
cp ./offlineimap-rc ~/.offlineimaprc
chmod 600 ~/.offlineimaprc
mkdir -p ~/email/gmail
chmod 700 ~/email -R

echo "edit ~/.msmtprc"
cp ./msmtprc ~/.msmtprc
chmod 600 ~/.msmtprc

echo "edit ~/.muttrc"
cp ./mutt-rc ~/.muttrc
cp ./mutt-mailcap ~/.mutt-mailcap
chmod 600 ~/.muttrc

echo "done"
