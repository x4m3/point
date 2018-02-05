echo "removing old zsh config";
rm -rf ~/.my-zsh/ ~/.zshrc;

echo "copying new zsh config";
cp -r ./my-zsh/ ~/.my-zsh;
ln -s ~/.my-zsh/zsh-config ~/.zshrc;

echo "install ruby also for jekyll" ;
echo "please run 'source ~/.zshrc;' in order to get the config working";
echo "done";
