echo "install zsh, zsh-completions, oh-my-zsh first!";

echo "removing old zsh config";
rm -rf ~/.zshrc;
rm -rf ~/.zshenv;

echo "setting up new zsh config";
ln -s ~/point/zsh/zshrc ~/.zshrc;
ln -s ~/point/zsh/zshenv ~/.zshenv;

mkdir -p ~/bin # for personal bins

echo ""
echo "put mac specific config in $HOME/.zshrc-mac"
echo "done, restart terminal";
