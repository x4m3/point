echo "INSTALL HTTP://OHMYZ.SH";

echo "removing old zsh config";
rm -rf ~/.zshrc;

echo "setting up new zsh config";
ln -s ~/point/zsh/zshrc ~/.zshrc;

echo "ready";
echo "install ruby also for jekyll" ;
echo "please run 'source ~/.zshrc;' in order to get the config working";
echo "done";
