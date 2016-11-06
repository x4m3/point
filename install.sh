echo "removing old zsh config";
rm -rf ~/.my-zsh/ ~/.zshrc;

echo "install zsh , ruby, git, and ohmyzsh (cause ohmyzsh is <3)";
cp -r ./my-zsh/ ~/.my-zsh;
ln -s ~/.my-zsh/zsh-config ~/.zshrc;

echo "please run 'source ~/.zshrc;' in order to get the config working";
echo "done";
