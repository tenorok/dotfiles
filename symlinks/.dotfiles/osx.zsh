export EDITOR='cursor -n'
export GIT_EDITOR='cursor --wait'

alias brewup='brew update && brew upgrade && brew cleanup'

# bat как замена cat
command -v bat &>/dev/null && alias cat='bat --paging=never --style=plain'

# NVM — инициализировать до использования npm
include $(brew --prefix 2>/dev/null)/opt/nvm/nvm.sh

# Автоматически использовать версию Node из .nvmrc при старте shell
nvm_use

# Ollama
export OLLAMA_NUM_PARALLEL=4
export OLLAMA_MAX_LOADED_MODELS=2
export OLLAMA_KEEP_ALIVE=30m
