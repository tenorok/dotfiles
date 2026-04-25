export LANG=ru_RU.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export TERM=xterm-256color
export COLORTERM=truecolor
export MICRO_TRUECOLOR=1
export CLICOLOR=1
export LSCOLORS=dxfxcxdxbxegedabagacdx

export GOPATH=$HOME/projects/go
export GO15VENDOREXPERIMENT=1

export DOTFILES=$HOME/.dotfiles
export MICRO_CONFIG_HOME=$HOME/.micro

if [[ -x /bin/zsh ]]; then
  export SHELL=/bin/zsh
elif [[ -x /usr/bin/zsh ]]; then
  export SHELL=/usr/bin/zsh
else
  export SHELL=${commands[zsh]:-/bin/zsh}
fi


export NVM_DIR=$HOME/.nvm
export NVM_NODEJS_ORG_MIRROR=https://nodejs.org/dist/

# Дедупликация PATH через zsh-массив path
typeset -U path PATH
path=(./bin node_modules/.bin $HOME/bin $path $GOPATH/bin)
export ORIGINAL_PATH=$PATH
