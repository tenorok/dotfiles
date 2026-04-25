sudo -v # ask for password only at the beginning

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

brew update
brew upgrade

brew install zsh zsh-completions
echo $(brew --prefix)/bin/zsh | sudo tee -a /etc/shells
chsh -s $(brew --prefix)/bin/zsh

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source $DIR/brew-applications.sh

for i in ${!APPLICATIONS[@]}; do
    brew install ${APPLICATIONS[$i]}
done

brew cleanup

# Damaged App Fix
# https://dev.to/pixelrena/installing-chromium-on-mac-apple-m2-pro-tutorial-4i4i
xattr -cr /Applications/Chromium.app

mkdir ~/.nvm

# Sublime Text 4
ST_PACKAGES=~/Library/Application\ Support/Sublime\ Text/Packages
rm -rf "$ST_PACKAGES/User/"
if git ls-remote https://github.com/fman7/frontend-light/ &>/dev/null; then
    git clone https://github.com/fman7/frontend-light/ ./preferences/SublimeText/frontend-light
fi
ln -s $(pwd)/preferences/SublimeText/User/ "$ST_PACKAGES/"
