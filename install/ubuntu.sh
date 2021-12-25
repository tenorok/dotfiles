sudo -v # ask for password only at the beginning

ln -sfn ${pwd}/tmux.conf ~/.tmux.conf
add-apt-repository ppa:git-core/ppa
add-apt-repository ppa:gophers/archive
add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main restricted universe multiverse"
apt-get update
apt-get install git git-lfs tmux ag ondir golang

# activate glob expanding
shopt -s globstar

NVM_DIR=$DOTFILES/nvm curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
include $NVM_DIR/nvm.sh

go get -u github.com/gokcehan/lf
ln -sfn $(HOME)/projects/go/bin/lf /usr/local/bin/micro

curl https://getmic.ro | bash
mv ./micro /usr/local/bin/micro
