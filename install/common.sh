for f in $(ls -A symlinks/); do ln -sfn $(pwd)/symlinks/$f ~/$f; done
source ~/.bash_profile

wget -q -O $(pwd)/symlinks/.dotfiles/ondir-scripts.sh https://raw.githubusercontent.com/alecthomas/ondir/master/scripts.sh
wget -q -O $(pwd)/symlinks/.dotfiles/git-completion.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash

NVM_DIR=$DOTFILES/nvm wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
include $NVM_DIR/nvm.sh

touch $(pwd)/symlinks/dotfiles/npm.completion.sh
npm completion > $(pwd)/symlinks/dotfiles/npm.completion.sh

curl https://getmic.ro | bash
mv ./micro /usr/local/bin/micro

go get -u github.com/gokcehan/lf
ln -sfn $(HOME)/projects/go/bin/lf /usr/local/bin/micro
