alias l='ls -lAhG'
alias getchmod='stat -f "%OLp"'
alias dockerps='docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.RunningFor}}\t{{.Status}}"'

function gitst {
  if [ $(git rev-parse HEAD) = $(git ls-remote $(git rev-parse --abbrev-ref @{u} | sed 's/\// /g') | cut -f1) ]; then
    echo -e $GREEN"Up to date"
  else
    echo -e $RED"Not up to date"
  fi
}

function gitDefault {
  export GIT_AUTHOR_NAME=tenorok
  export GIT_AUTHOR_EMAIL=mail@tenorok.ru
  export GIT_COMMITTER_NAME=tenorok
  export GIT_COMMITTER_EMAIL=mail@tenorok.ru
  export GITHUB_HOST=github.com
}

function NPMDefault {
  npm config set registry https://registry.npmjs.org/
}

if [[ -d ~/yandex ]]; then
  include $DOTFILES/work.sh
else
  include $DOTFILES/home.sh
fi
