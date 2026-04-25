setopt PROMPT_SUBST
autoload -U colors && colors

VCS="git"

_vcs_color() {
  local vcs_status="$($VCS status --no-ahead-behind 2>/dev/null)"
  if [[ $vcs_status =~ "nothing to commit" ]]; then
    echo "%F{green}"
  else
    echo "%F{magenta}"
  fi
}

_vcs_state() {
  local branch=$(_vcs_branch $VCS)
  local remote_branch
  if [[ $VCS = "git" ]]; then
    remote_branch="@{u}"
  else
    remote_branch="arcadia/$(arc info 2>/dev/null | grep 'remote:' | sed -e 's/remote: \(.*\)/\1/')"
  fi

  local commit_local=$($VCS rev-parse $branch 2>/dev/null)
  local commit_remote=$($VCS rev-parse $remote_branch 2>/dev/null)

  if [[ ${#commit_local} -gt 0 && ${#commit_remote} -gt 0 && $commit_local = $commit_remote ]]; then
    echo ""
    return
  elif [[ ${#commit_local} -gt 0 && -z $commit_remote ]]; then
    echo " ⛢"
    return
  fi

  local commit_base=$($VCS merge-base $branch $remote_branch 2>/dev/null)

  if [[ ${#commit_local} -gt 0 && ${#commit_base} -gt 0 && $commit_local = $commit_base ]]; then
    echo " ↻"
  elif [[ ${#commit_remote} -gt 0 && ${#commit_base} -gt 0 && $commit_remote = $commit_base ]]; then
    echo " ↑"
  elif [[ ${#commit_local} -gt 0 && ${#commit_remote} -gt 0 && ${#commit_base} -gt 0 ]]; then
    echo " ⇅"
  fi
}

_vcs_branch() {
  $1 branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

_git_branch() {
  if [[ $(_vcs_branch "git") ]]; then
    VCS="git"
    return 0
  fi
  return 1
}

_arc_branch() {
  if [[ $(_vcs_branch "arc") ]]; then
    VCS="arc"
    return 0
  fi
  return 1
}

_VCSPS1() {
  local vcs_info=""
  if _git_branch || _arc_branch; then
    vcs_info+=$(_vcs_color)
    vcs_info+=" "$(_vcs_branch $VCS)
    vcs_info+=$(_vcs_state)
    vcs_info+="%f"
  fi
  echo $vcs_info
}

_build_prompt() {
  local p=""
  local vcs_part=$(_VCSPS1)

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

add-zsh-hook precmd _build_prompt
