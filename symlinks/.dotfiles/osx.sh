export EDITOR='code -n'

alias cat='ccat --bg=dark'
alias updatecask='brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup'

# brew
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH=$(brew --prefix)/bin:$PATH

# hub
eval "$(hub alias -s)"

include $DOTFILES/ondir-scripts.sh
