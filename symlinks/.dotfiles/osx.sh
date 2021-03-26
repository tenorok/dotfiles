export EDITOR='code -n'

alias cat='ccat --bg=dark'
alias updatecask='brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup'

# brew
# Intel
[ -f /usr/local/bin/brew ] && eval "$(/usr/local/bin/brew shellenv)"
# M1
[ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# hub
eval "$(hub alias -s)"

include $DOTFILES/ondir-scripts.sh
