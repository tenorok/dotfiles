alias sdev="ssh -Y -X tenorok-dev.sas.yp-c.yandex.net"

alias npmw="npm config set registry http://registry.npmjs.org"
alias npmy="npm config set registry http://npm.yandex-team.ru"
alias ynpm='npm --registry http://npm.yandex-team.ru'
alias npm-yandex-deps='npm i --registry="http://npm.yandex-team.ru" && npm run deps --registry="http://npm.yandex-team.ru"'

function turbotesting() {
    set -e
    git apply --directory=tools/ $DOTFILES/qyp-turbo-testing.patch
    YENV=testing make config
    YENV=testing make build-pages
    git apply -R --directory=tools/ $DOTFILES/qyp-turbo-testing.patch
    echo -e "\ncommand to start templar: ${GREEN}TUNNELER_HOST=ws1-tunnelerapi.si.yandex-team.ru NODE_ENV=testing npx templar start --dont-track -p 1111 --public"
    echo -e "${YELLOW}${UNDERLINE}http://$(hostname):1111\n"
}
