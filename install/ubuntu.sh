sudo -v # ask for password only at the beginning
sudo chown -R $(whoami) /usr/local

sudo apt-get install -y software-properties-common
sudo apt-get update
add-apt-repository ppa:git-core/ppa
add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main restricted universe multiverse"
sudo apt-get update -y
sudo apt-get install -y git git-lfs tmux silversearcher-ag ondir golang zsh zsh-autosuggestions zsh-syntax-highlighting

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
source $NVM_DIR/nvm.sh
nvm install --lts
nvm use default

go install github.com/gokcehan/lf@latest

curl https://getmic.ro | bash
mv ./micro /usr/local/bin/micro

chsh -s $(which zsh)

if [[ -d ~/yandex ]]; then
    echo 'Copy token from https://oauth.yandex-team.ru/authorize?response_type=token&client_id=630b6794f55a4d9abaa4511eb06d2c5e'
    echo 'And paste it to $HOME/.config/surfwax/token'
fi
