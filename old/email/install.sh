# install.sh
#

echo "Install 'vim', 'mutt', 'msmtp', 'offlineimap', 'w3m', 'eog', 'pass', 'python', 'evince', 'feh'"
echo

# mutt
ln -s ~/point/email/mutt-rc ~/.muttrc
ln -s ~/point/email/mutt-mailcap ~/.mutt-mailcap
ln -s ~/point/email/mutt-epitech ~/.mutt-epitech
ln -s ~/point/email/mutt-plcom ~/.mutt-plcom
echo "mutt ready"

echo "done"
