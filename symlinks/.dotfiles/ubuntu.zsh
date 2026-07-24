export EDITOR='micro'
export GIT_EDITOR='micro'

# SSH-агент для VSCode remote (https://code.visualstudio.com/docs/remote/troubleshooting#_setting-up-the-ssh-agent)
if [[ -z "$SSH_AUTH_SOCK" ]]; then
  local running_agent=$(ps -ax | grep 'ssh-agent -s' | grep -v grep | wc -l | tr -d '[:space:]')
  if [[ "$running_agent" = "0" ]]; then
    ssh-agent -s &> .ssh/ssh-agent
  fi
  eval $(cat .ssh/ssh-agent)
fi

# NVM — EXTENDED_GLOB ломает nvm_alias (#* → bad pattern)
setopt NO_EXTENDED_GLOB
source $NVM_DIR/nvm.sh
source $NVM_DIR/bash_completion 2>/dev/null || true
setopt EXTENDED_GLOB

# Автоматически использовать версию Node из .nvmrc при старте shell
nvm_use
