echo "INSTALL HTTP://OHMYZ.SH";

echo "removing old zsh config";
rm -rf ~/.zshrc;
rm -rf ~/.zshenv;

echo "setting up new zsh config";
ln -s ~/point/zsh/zshrc ~/.zshrc;
ln -s ~/point/zsh/zshenv ~/.zshenv;

mkdir ~/.gems -p # for gems

echo "please run 'source ~/.zshrc;' in order to get the config working";
echo "done";
