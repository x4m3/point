echo "install zsh, zsh-completions, oh-my-zsh first!";

echo "removing old zsh config";
rm -rf ~/.zshrc;
rm -rf ~/.zshenv;

echo "setting up new zsh config";
ln -s ~/point/zsh/zshrc ~/.zshrc;
ln -s ~/point/zsh/zshenv ~/.zshenv;

mkdir -p ~/bin # for personal bins
mkdir -p ~/.gems # for gems
mkdir -p ~/.cargo/bin # for cargo
mkdir -p ~/go/bin # for golang

echo "please run 'source ~/.zshrc;' in order to get the config working";
echo "done";
