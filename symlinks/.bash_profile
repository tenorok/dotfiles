export PROFILE=~/.bash_profile

export LANG=ru_RU.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export TERM=xterm-color
export COLORTERM=truecolor
export MICRO_TRUECOLOR=1
export CLICOLOR=1
export LSCOLORS=dxfxcxdxbxegedabagacdx

export DISPLAY=:0.0

export GOPATH=$HOME/projects/go
export GO15VENDOREXPERIMENT=1

export DOTFILES=$HOME/.dotfiles
export MICRO_CONFIG_HOME=$HOME/.micro

include() {
  [[ -f "$1" ]] && source "$1"
}

include $DOTFILES/ps1.sh
include $DOTFILES/aliases.sh

# GIT
gitDefault

# NVM нужно инициализировать до использования NPM
export NVM_DIR=~/.nvm
export NVM_NODEJS_ORG_MIRROR=https://nodejs.org/dist/
include $NVM_DIR/nvm.sh
include $NVM_DIR/bash_completion

# NPM
NPMDefault

# Ruby
include ~/.rvm/scripts/rvm

include $DOTFILES/git-completion.sh
include /usr/local/etc/profile.d/bash_completion.sh
include $DOTFILES/runjs.completion.sh
include $DOTFILES/npm.completion.sh

# Путь считывается в конце после всех добавлений.
export PATH=./bin:$PATH:$GOPATH/bin
export ORIGINAL_PATH=$PATH

# Если ubuntu.
if [[ -f "/usr/bin/hostnamectl" ]]; then
  include $DOTFILES/ubuntu.sh
else
  include $DOTFILES/osx.sh
fi
