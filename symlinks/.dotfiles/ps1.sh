# https://misc.flogisoft.com/bash/tip_colors_and_formatting
RED="\033[0;31m"
PURPLE="\033[0;35m"
CYAN="\033[0;36m"
YELLOW="\033[0;33m"
GREEN="\033[0;32m"
GRAY="\e[0m"
UNDERLINE="\e[4m"

VCS="git"

function vcs_color {
  local vcs_status="$($VCS status 2> /dev/null)"

  if [[ $vcs_status =~ "nothing to commit" ]]; then
    echo -e $GREEN # Clean state
  else
    echo -e $PURPLE # Dirty state
  fi
}

function vcs_state {
  local branch=$(vcs_branch $VCS)
  local remote_branch;
  if [[ $VCS = "git" ]]; then
    remote_branch="@{u}"
  else
    remote_branch="arcadia/$(arc info 2> /dev/null | grep 'remote:' | sed -e 's/remote: \(.*\)/\1/')"
  fi

  local commit_local=$($VCS rev-parse $branch 2> /dev/null)
  local commit_remote=$($VCS rev-parse $remote_branch 2> /dev/null)
  local commit_base=$($VCS merge-base $branch $remote_branch 2> /dev/null)

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

function vcs_branch {
  $1 branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

function git_branch {
  if [[ $(vcs_branch "git") ]]; then
    VCS="git"
    return 0;
  fi

  return 1;
}

function arc_branch {
  if [[ $(vcs_branch "arc") ]]; then
    VCS="arc"
    return 0;
  fi

  return 1;
}

function VCSPS1 {
  local vcs_info=""

  if git_branch || arc_branch; then
    vcs_info+=$(vcs_color);
    vcs_info+=" "$(vcs_branch $VCS);
    vcs_info+=$(vcs_state);
  fi

  echo $vcs_info;
}

PS1=""
# Если на сервере.
if [[ -f "/usr/bin/hostnamectl" ]]; then
  PS1+="\[$CYAN\]\h "
fi
PS1+="\[$YELLOW\]\w"
PS1+="\$(VCSPS1) "
VCSPS1RESULT=$(VCSPS1)
if [[ ${#PWD}+${#VCSPS1RESULT} -gt 70 ]]; then
  PS1+="\n"
fi
PS1+="\[$GRAY\]› "
export PS1
