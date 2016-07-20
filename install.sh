echo "removing old zsh config";
rm -rf ~/.my-zsh/ ~/.zshrc;

echo "install zsh and ohmyzsh (cause ohmyzsh is <3)";
cp -r ./my-zsh/ ~/.my-zsh;
ln -s ~/.my-zsh/zsh-config ~/.zshrc;
source ~/.zshrc;
echo "done";
