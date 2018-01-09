# install.sh
#

echo "Install packages 'mutt', 'msmtp', 'offlineimap', 'w3m' and 'eog'"
echo

echo "Copying the configuration file for offlineimap"
cp ./offlineimap-rc ~/.offlineimaprc
chmod 600 ~/.offlineimaprc
mkdir -p ~/email/gmail
chmod 700 ~/email -R

echo "Copying the configuration file for msmtprc"
cp ./msmtprc ~/.msmtprc
chmod 600 ~/.msmtprc

echo "Copying the configuration files for mutt"
cp ./mutt-rc ~/.muttrc
cp ./mutt-mailcap ~/.mutt-mailcap
chmod 600 ~/.muttrc

echo "Now edit the files for the passwords"
