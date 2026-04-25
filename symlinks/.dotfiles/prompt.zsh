setopt PROMPT_SUBST
autoload -U colors && colors

PROMPT_VCS="git"

prompt_vcs_color() {
  local vcs_status="$($PROMPT_VCS status --no-ahead-behind 2>/dev/null)"
  if [[ $vcs_status =~ "nothing to commit" ]]; then
    echo "%F{green}"
  else
    echo "%F{magenta}"
  fi
}

prompt_vcs_state() {
  local branch=$(prompt_vcs_branch $PROMPT_VCS)
  local remote_branch
  if [[ $PROMPT_VCS = "git" ]]; then
    remote_branch="@{u}"
  else
    remote_branch="arcadia/$(arc info 2>/dev/null | grep 'remote:' | sed -e 's/remote: \(.*\)/\1/')"
  fi

  local commit_local=$($PROMPT_VCS rev-parse $branch 2>/dev/null)
  local commit_remote=$($PROMPT_VCS rev-parse $remote_branch 2>/dev/null)

  if [[ ${#commit_local} -gt 0 && ${#commit_remote} -gt 0 && $commit_local = $commit_remote ]]; then
    echo ""
    return
  elif [[ ${#commit_local} -gt 0 && -z $commit_remote ]]; then
    echo " ⛢"
    return
  fi

  local commit_base=$($PROMPT_VCS merge-base $branch $remote_branch 2>/dev/null)

  if [[ ${#commit_local} -gt 0 && ${#commit_base} -gt 0 && $commit_local = $commit_base ]]; then
    echo " ↻"
  elif [[ ${#commit_remote} -gt 0 && ${#commit_base} -gt 0 && $commit_remote = $commit_base ]]; then
    echo " ↑"
  elif [[ ${#commit_local} -gt 0 && ${#commit_remote} -gt 0 && ${#commit_base} -gt 0 ]]; then
    echo " ⇅"
  fi
}

prompt_vcs_branch() {
  $1 branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

prompt_git_branch() {
  if [[ $(prompt_vcs_branch "git") ]]; then
    PROMPT_VCS="git"
    return 0
  fi
  return 1
}

prompt_arc_branch() {
  if [[ $(prompt_vcs_branch "arc") ]]; then
    PROMPT_VCS="arc"
    return 0
  fi
  return 1
}

prompt_vcs_ps1() {
  local vcs_info=""
  if prompt_git_branch || prompt_arc_branch; then
    vcs_info+=$(prompt_vcs_color)
    vcs_info+=" "$(prompt_vcs_branch $PROMPT_VCS)
    vcs_info+=$(prompt_vcs_state)
    vcs_info+="%f"
  fi
  echo $vcs_info
}

prompt_build() {
  local p=""
  local vcs_part=$(prompt_vcs_ps1)

  # На сервере — показываем хост
  if [[ -f /usr/bin/hostnamectl ]]; then
    p+="%F{cyan}%m%f "
  fi

  p+="%F{yellow}%~%f${vcs_part} "

  # Перенос строки, если строка слишком длинная
  local plain_vcs=$(echo "$vcs_part" | sed 's/%F{[^}]*}//g; s/%f//g')
  if (( ${#PWD} + ${#plain_vcs} > 70 )); then
    p+=$'\n'
  fi

  p+="%f› "
  PROMPT=$p

  # Заголовок вкладки терминала: только имя текущей директории (без суффикса (-zsh))
  print -Pn "\e]0;%1~\a"
}

add-zsh-hook precmd prompt_build
