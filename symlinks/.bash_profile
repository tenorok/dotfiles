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

export NVM_DIR=~/.nvm
export NVM_NODEJS_ORG_MIRROR=https://nodejs.org/dist/

# Автоматическое использование nvm при наличии .nvmrc
nvm_use() {
  if [[ -f ".nvmrc" ]]; then
    # Проверяем, что nvm доступен (функция загружена)
    if command -v nvm &> /dev/null; then
      nvm use
    fi
  fi
}

# Автоматическое использование nvm при инициализации (избегая дублирования с ondir)
nvm_use_oninit() {
  case "$PWD" in
    $HOME/arcadia*/*) ;;  # Не вызываем, ondir сделает это
    *) nvm_use ;;         # Вызываем для всех остальных случаев
  esac
}

# Раскрывать глобы
shopt -s globstar

include() {
  [[ -f "$1" ]] && source "$1"
}

init() {
  source ~/.bash_profile
}

include $DOTFILES/ps1.sh
include $DOTFILES/aliases.sh

# Если ubuntu.
if [[ -f "/usr/bin/hostnamectl" ]]; then
  include $DOTFILES/ubuntu.sh
else
  include $DOTFILES/osx.sh
fi

# GIT
gitDefault

# NPM
NPMDefault

# Ruby
include ~/.rvm/scripts/rvm

include $DOTFILES/git-completion.sh
include $DOTFILES/runjs.completion.sh
include $DOTFILES/npm.completion.sh

if command -v arc &> /dev/null
then
  arc completion bash > ~/.arc/completion.bash && source ~/.arc/completion.bash
fi

# Путь считывается в конце после всех добавлений.
export PATH=./bin:node_modules/.bin:$PATH:$GOPATH/bin
export ORIGINAL_PATH=$PATH

include $DOTFILES/env.sh
