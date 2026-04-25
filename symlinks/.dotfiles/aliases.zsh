alias l='ls -lAhG'
alias p="pnpm"
alias getchmod='stat -f "%OLp"'
alias dockerps='docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.RunningFor}}\t{{.Status}}\t{{.Size}}"'

function gitst {
  if [ $(git rev-parse HEAD) = $(git ls-remote $(git rev-parse --abbrev-ref @{u} | sed 's/\// /g') | cut -f1) ]; then
    echo "%F{green}Up to date%f"
  else
    echo "%F{red}Not up to date%f"
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
  include $DOTFILES/work.zsh
else
  include $DOTFILES/home.zsh
fi
