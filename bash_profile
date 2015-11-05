export PROFILE=~/.bash_profile

export LANG=ru_RU.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export TERM=xterm-color
export CLICOLOR=1
export LSCOLORS=dxfxcxdxbxegedabagacdx

export EDITOR='subl -w'
export PATH=./node_modules/.bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:bin

RED="\033[0;31m"
PURPLE="\033[0;35m"
CYAN="\033[0;36m"
YELLOW="\033[0;33m"
GREEN="\033[0;32m"
GRAY="\e[0m"

function git_color {
  local git_status="$(git status 2> /dev/null)"

  if [[ ! $git_status =~ "working directory clean" ]]; then
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
alias cat='ccat --bg dark'

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
  export GIT_COMMITTER_NAME=Artem Kurbatov
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

export NODE_PATH=./node_modules:$(npm root -g)

alias edital='open -a "Sublime Text" ~/.bash_profile'
alias saveal='source ~/.bash_profile && echo ".bash_profile has started"'

alias edithosts='open -a "Sublime Text" /private/etc/hosts'

alias showall='defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder'
alias hideall='defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder'
alias getchmod='stat -f "%OLp"'
alias count='ls | wc -l'

alias updatecask='brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup'

function makedmg() {
    DIR=$1;
    VOL=$2;
    hdiutil create $DIR -type SPARSEBUNDLE -size 5000m -fs HFS+J -volname $VOL -encryption
}

jailmount()
{
    JAIL=${1}
    FOLDER=${2:-"/home/$USER"}
    echo -e "\033[33m===> MOUNT JAIL: \033[31m$JAIL \033[0m"
    mkdir -p /mount/$JAIL
    jailunmount $JAIL
    sshfs $USER@$JAIL:$FOLDER /mount/$JAIL -oauto_cache,reconnect,volname=$1
}

jailunmount()
{
    JAIL=${1}
    umount /mount/$1 >/dev/null
}

# Tmux
alias tm="tmux -2 -S /tmp/tm-`whoami`"
alias tms="tm a -t"

# Tmux session alias for pair-programming
function tm-pair
{
    if [ ${2} ]; then
        tmux -2 -S /tmp/tm-${1} attach -t ${2}
    elif [ ${1} ]; then
        tmux -2 -S /tmp/tm-`whoami` new -s ${1}
    else
        echo 'Usage:'
        echo 'tm-pair feature_name # Create session'
        echo 'tm-pair user_name feature_name # Attach to session'
    fi
}

source ~/.git-completion.bash

[ -f ~/.bash_osx ] && source ~/.bash_osx
[ -f ~/.bash_aliases ] && source ~/.bash_aliases
