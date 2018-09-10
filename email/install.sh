# install.sh
#

echo "Install 'vim', 'mutt', 'msmtp', 'offlineimap', 'w3m', 'eog', 'pass', 'python', 'evince', 'feh'"
echo

# email folders
mkdir -p ~/email
chmod 700 ~/email -R
echo "email folders created in ~/email"

# offlineimap
ln -s ~/point/email/offlineimap-rc ~/.offlineimaprc
ln -s ~/point/email/offlineimap.py ~/.offlineimap.py
echo "offlineimap ready"
echo "for automatic syncing, make a cron job"

# msmtp
ln -s ~/point/email/msmtprc ~/.msmtprc
chmod 600 ~/.msmtprc # msmtp requires the config file to be in mod 600 (only me)
rm ~/.msmtp.tls
if [ -e /usr/local/etc/openssl/cert.pem ]
then
	echo "using '/usr/local/etc/openssl/cert.pem' as trust file"
	ln -s /usr/local/etc/openssl/cert.pem ~/.msmtp.tls
else
	echo "using '/etc/ssl/certs/ca-certificates.crt' as trust file"
	ln -s /etc/ssl/certs/ca-certificates.crt ~/.msmtp.tls
fi
echo "msmtp ready"

# mutt
ln -s ~/point/email/mutt-rc ~/.muttrc
ln -s ~/point/email/mutt-mailcap ~/.mutt-mailcap
ln -s ~/point/email/mutt-gmail ~/.mutt-gmail
ln -s ~/point/email/mutt-epitech ~/.mutt-epitech
ln -s ~/point/email/mutt-plcom ~/.mutt-plcom
echo "mutt ready"

echo "done"
