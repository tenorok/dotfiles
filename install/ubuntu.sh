sudo -v # ask for password only at the beginning
sudo chown -R $(whoami) /usr/local

ln -sfn ${pwd}/tmux.conf ~/.tmux.conf
sudo apt-get install software-properties-common
sudo apt-get update
add-apt-repository ppa:git-core/ppa
add-apt-repository ppa:gophers/archive
add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main restricted universe multiverse"
sudo apt-get update -y
sudo apt-get install -y git git-lfs tmux ag ondir golang

# activate glob expanding
shopt -s globstar

NVM_DIR=$DOTFILES/nvm curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
source $NVM_DIR/nvm.sh
source $NVM_DIR/bash_completion
source ~/.bash_profile
nvm install --lts
nvm use default

go get -u github.com/gokcehan/lf
ln -sfn $(HOME)/projects/go/bin/lf /usr/local/bin/micro

curl https://getmic.ro | bash
mv ./micro /usr/local/bin/micro
