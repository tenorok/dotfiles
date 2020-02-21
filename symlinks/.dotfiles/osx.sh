export EDITOR='code -n'

alias cat='ccat --bg=dark'
alias updatecask='brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup'

# hub
eval "$(hub alias -s)"

include $DOTFILES/ondir-scripts.sh
