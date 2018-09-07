# install.sh
#

echo "make sure that you have:"
echo "sncli-git pass"
echo "and the pgp key for pass"

rm ~/.snclirc
ln -s ~/point/sncli/snclirc ~/.snclirc
echo "done"
