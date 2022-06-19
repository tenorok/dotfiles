sudo -v # ask for password only at the beginning

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

brew update
brew upgrade

brew install bash
echo $(brew --prefix)/bin/bash | sudo tee -a /etc/shells
chsh -s $(brew --prefix)/bin/bash # set default shell

brew tap homebrew/cask-fonts

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source $DIR/brew-applications.sh

for i in ${!APPLICATIONS[@]}; do
    brew install ${APPLICATIONS[$i]}
done

brew cleanup

mkdir ~/.nvm
cp ./preferences/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/
git clone https://github.com/fman7/frontend-light/ ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/frontend-light
