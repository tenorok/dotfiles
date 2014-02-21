export TERM=xterm-color
export CLICOLOR=1
export LSCOLORS=dxfxcxdxbxegedabagacdx

export EDITOR='subl -w'
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
GRAY="\[\e[0m\]"

PS1="\$(date +%H:%M) $YELLOW\w$GREEN\$(parse_git_branch)$GRAY \$ "

alias l='ls -lAhG'

alias edital='open -a "Sublime Text" ~/.bash_profile'
alias saveal='source ~/.bash_profile && echo ".bash_profile has started"'

alias edithosts='open -a "Sublime Text" /private/etc/hosts'

alias showall='defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder'
alias hideall='defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder'

alias st2sn='open "/Users/tenor/Library/Application Support/Sublime Text/Packages/User/"'

function makedmg() {
    DIR=$1;
    VOL=$2;
    hdiutil create $DIR -type SPARSEBUNDLE -size 5000m -fs HFS+J -volname $VOL -encryption
}

source ~/.git-completion.bash
