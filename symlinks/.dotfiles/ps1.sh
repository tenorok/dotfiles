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
if [[ -f "/usr/bin/hostnamectl" ]]; then
  PS1+="\[$CYAN\]\h "
fi
PS1+="\[$YELLOW\]\w"
PS1+="\[\$(git_color)\]\$(git_branch)\$(git_state)"
PS1+="\[$GRAY\] › "
export PS1
