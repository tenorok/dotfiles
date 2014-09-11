export TERM=xterm-color
export LANG=ru_RU.UTF-8
export CLICOLOR=1
export LSCOLORS=dxfxcxdxbxegedabagacdx

export EDITOR='subl -w'
export PATH=./node_modules/.bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

RED="\033[0;31m"
PURPLE="\033[0;35m"
CYAN="\033[0;36m"
YELLOW="\033[0;33m"
GREEN="\033[0;32m"
GRAY="\e[0m"

function git_color {
  local git_status="$(git status 2> /dev/null)"

  if [[ ! $git_status =~ "working directory clean" ]]; then
    echo -e $PURPLE
  elif [[ $git_status =~ "Your branch is ahead of" ]]; then
    echo -e $CYAN
  elif [[ $git_status =~ "nothing to commit" ]]; then
    echo -e $GREEN
  else
    echo -e $GRAY
  fi
}

function git_branch {
  local git_status="$(git status 2> /dev/null)"
  local on_branch="On branch ([^${IFS}]*)"
  local on_commit="HEAD detached at ([^${IFS}]*)"

  if [[ $git_status =~ $on_branch ]]; then
    local branch=${BASH_REMATCH[1]}
    echo "$branch"
  elif [[ $git_status =~ $on_commit ]]; then
    local commit=${BASH_REMATCH[1]}
    echo "$commit"
  fi
}

PS1="\[$YELLOW\]\w"
PS1+="\[\$(git_color)\] \$(git_branch)"
PS1+="\[$GRAY\] › "
export PS1

alias l='ls -lAhG'

alias edital='open -a "Sublime Text" ~/.bash_profile'
alias saveal='source ~/.bash_profile && echo ".bash_profile has started"'

alias edithosts='open -a "Sublime Text" /private/etc/hosts'

alias showall='defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder'
alias hideall='defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder'

function makedmg() {
    DIR=$1;
    VOL=$2;
    hdiutil create $DIR -type SPARSEBUNDLE -size 5000m -fs HFS+J -volname $VOL -encryption
}

source ~/.git-completion.bash

[ -f ~/.bash_aliases ] && source ~/.bash_aliases
