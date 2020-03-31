sudo -v # ask for password only at the beginning

[ -d ~/.ssh ] || mkdir ~/.ssh
[ -f ~/.ssh/config ] || cp -n ssh/config ~/.ssh/config
[ -f ~/.ssh/rc ] || cp -n ssh/rc ~/.ssh/rc
chmod 644 ~/.ssh/config
ssh-keygen -t rsa -C "mail@tenorok.ru" -N "" -f ~/.ssh/id_rsa
pbcopy < ~/.ssh/id_rsa.pub
echo -e "\033[0;32mPaste key from your clipboard to https://github.com/settings/ssh"

cp ./preferences/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/
git clone https://github.com/fman7/frontend-light/ ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/frontend-light

curl -L github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C /usr/local
brew install phinze/cask/brew-cask

brew update
brew upgrade

brew install bash
echo "/usr/local/bin/bash" | sudo tee -a /etc/shells
chsh -s /usr/local/bin/bash

brew install git \
    git-lfs \
    bash-completion@2 \
    nvm \
    go \
    wget \
    ondir \
    hub \
    ccat \
    ag \
    tree \
    m-cli \
    sublime-text \
    iterm2 \
    xscope \
    transmit \
    chromium \
    skype \
    teamviewer \
    yandexdisk \
    dropbox \
    transmission \
    vlc \
    appzapper \
    imageoptim \
    imagealpha \
    spectacle \
    apptivate \
    clipy

brew cleanup
