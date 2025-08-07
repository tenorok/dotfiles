export EDITOR='micro'

# https://code.visualstudio.com/docs/remote/troubleshooting#_setting-up-the-ssh-agent
if [ -z "$SSH_AUTH_SOCK" ]; then
   # Check for a currently running instance of the agent
   RUNNING_AGENT="`ps -ax | grep 'ssh-agent -s' | grep -v grep | wc -l | tr -d '[:space:]'`"
   if [ "$RUNNING_AGENT" = "0" ]; then
        # Launch a new instance of the agent
        ssh-agent -s &> .ssh/ssh-agent
   fi
   eval `cat .ssh/ssh-agent`
fi

source $NVM_DIR/nvm.sh
source $NVM_DIR/bash_completion

# Автоматически использовать версию Node из .nvmrc
nvm_use_oninit
