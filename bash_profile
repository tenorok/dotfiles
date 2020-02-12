export PROFILE=~/.bash_profile

export LANG=ru_RU.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export TERM=xterm-color
export COLORTERM=truecolor
export MICRO_TRUECOLOR=1
export CLICOLOR=1
export LSCOLORS=dxfxcxdxbxegedabagacdx

export EDITOR='subl -w'
export DISPLAY=:0.0

export GOPATH=$HOME/projects/go
export GO15VENDOREXPERIMENT=1

RED="\033[0;31m"
PURPLE="\033[0;35m"
CYAN="\033[0;36m"
YELLOW="\033[0;33m"
GREEN="\033[0;32m"
GRAY="\e[0m"

function git_color {
  local git_status="$(git status 2> /dev/null)"

  if [[ ! $git_status =~ "working tree clean" ]]; then
    echo -e $PURPLE # Dirty state
  elif [[ $git_status =~ "nothing to commit" ]]; then
    echo -e $GREEN # Clean state
  else
    echo -e $GRAY
  fi
}

function git_state {
  local commit_local=$(git rev-parse @ 2> /dev/null)
  local commit_remote=$(git rev-parse @{u} 2> /dev/null)
  local commit_base=$(git merge-base @ @{u} 2> /dev/null)

  if [[ ${#commit_local} -gt 0 && ${#commit_remote} -gt 0 && $commit_local = $commit_remote ]]; then
    echo ""
  elif [[ ${#commit_local} -gt 0 && ${#commit_base} -gt 0 && $commit_local = $commit_base ]]; then
    echo " ↻" # Need to rebase
  elif [[ ${#commit_local} -gt 0 && -z $commit_remote ]]; then
    echo " ⛢" # Untracked branch
  elif [[ ${#commit_remote} -gt 0 && ${#commit_base} -gt 0 && $commit_remote = $commit_base ]]; then
    echo " ↑" # Need to push
  elif [[ ${#commit_local} -gt 0 && ${#commit_remote} -gt 0 && ${#commit_base} -gt 0 ]]; then
    echo " ⇅" # Crash history (Need to force push or pull)
  fi
}

function git_branch {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/'
}

PS1=""
# Если на сервере.
if [[ $(git config core.editor) = vim ]]; then
  PS1+="\[$CYAN\]\h "
fi
PS1+="\[$YELLOW\]\w"
PS1+="\[\$(git_color)\]\$(git_branch)\$(git_state)"
PS1+="\[$GRAY\] › "
export PS1

alias l='ls -lAhG'
alias cat='ccat --bg=dark'
alias getchmod='stat -f "%OLp"'
alias updatecask='brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup'
alias dockerps='docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.RunningFor}}\t{{.Status}}"'

function gitst {
  if [ $(git rev-parse HEAD) = $(git ls-remote $(git rev-parse --abbrev-ref @{u} | sed 's/\// /g') | cut -f1) ]; then
    echo -e $GREEN"Up to date"
  else
    echo -e $RED"Not up to date"
  fi
}

# git
function gitDefault {
  export GIT_AUTHOR_NAME=tenorok
  export GIT_AUTHOR_EMAIL=mail@tenorok.ru
  export GIT_COMMITTER_NAME=tenorok
  export GIT_COMMITTER_EMAIL=mail@tenorok.ru
  export GITHUB_HOST=github.com
}
gitDefault

# NVM
export NVM_DIR=~/.nvm
[ -f ~/.nvm/nvm.sh ] && source ~/.nvm/nvm.sh

# NPM
function NPMDefault {
  npm config set registry https://registry.npmjs.org/
}
NPMDefault

# Ruby Version Manager
[ -f ~/.rvm/scripts/rvm ] && source ~/.rvm/scripts/rvm
# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

source ~/.git-completion.bash
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
source ~/runjs.completion.sh
source ~/npm.completion.sh

export PATH=$GOPATH/bin:$PATH
export ORIGINAL_PATH=$PATH

[ -f ~/.bash_osx ] && source ~/.bash_osx
[ -f ~/.bash_aliases ] && source ~/.bash_aliases
