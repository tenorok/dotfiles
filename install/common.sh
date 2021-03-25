for f in $(ls -A symlinks/); do ln -sfn $(pwd)/symlinks/$f ~/$f; done
source ~/.bash_profile

curl https://raw.githubusercontent.com/alecthomas/ondir/master/scripts.sh --output $(pwd)/symlinks/.dotfiles/ondir-scripts.sh
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash --output $(pwd)/symlinks/.dotfiles/git-completion.sh

touch $(pwd)/symlinks/dotfiles/npm.completion.sh
npm completion > $(pwd)/symlinks/dotfiles/npm.completion.sh

curl https://getmic.ro | bash
mv ./micro /usr/local/bin/micro
