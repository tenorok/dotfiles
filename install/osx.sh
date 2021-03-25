sudo -v # ask for password only at the beginning

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew update
brew upgrade

brew install bash
echo "/usr/local/bin/bash" | sudo tee -a /etc/shells
chsh -s /usr/local/bin/bash

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source $DIR/brew-applications.sh

for i in ${!APPLICATIONS[@]}; do
    brew install ${APPLICATIONS[$i]}
done

brew cleanup

cp ./preferences/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/
git clone https://github.com/fman7/frontend-light/ ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/frontend-light
