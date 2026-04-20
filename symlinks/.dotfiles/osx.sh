export EDITOR='cursor -n'
export GIT_EDITOR='cursor --wait'

alias brewup='brew update && brew upgrade && brew cleanup'

# brew
# Intel
[ -f /usr/local/bin/brew ] && eval "$(/usr/local/bin/brew shellenv)"
# M1
[ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# bat как замена cat (после инициализации brew, чтобы бинарь был в PATH)
command -v bat &>/dev/null && alias cat='bat --paging=never --style=plain'

# https://docs.brew.sh/Shell-Completion#configuring-completions-in-bash
if type brew &>/dev/null
then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi
fi

# NVM нужно инициализировать до использования NPM
include $(brew --prefix)/opt/nvm/nvm.sh
include $(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm

# Автоматически использовать версию Node из .nvmrc
nvm_use_oninit

include $DOTFILES/ondir-scripts.sh

# Ollama
export OLLAMA_NUM_PARALLEL=4
export OLLAMA_MAX_LOADED_MODELS=2
export OLLAMA_KEEP_ALIVE=30m
