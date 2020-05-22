alias sdev="ssh -Y -X tenorok-dev.sas.yp-c.yandex.net"

alias npmw="npm config set registry http://registry.npmjs.org"
alias npmy="npm config set registry http://npm.yandex-team.ru"
alias ynpm='npm --registry http://npm.yandex-team.ru'
alias npm-yandex-deps='npm i --registry="http://npm.yandex-team.ru" && npm run deps --registry="http://npm.yandex-team.ru"'

function turbo_testing() {
    set -e
    git apply --directory=tools/ $DOTFILES/qyp-turbo-testing.patch
    YENV=testing make config
    YENV=testing make build-pages
    git apply -R --directory=tools/ $DOTFILES/qyp-turbo-testing.patch
    echo -e "\ncommand to start templar: ${GREEN}templar_testing {1,2,3}"
    echo -e "${YELLOW}${UNDERLINE}http://$(hostname):1111\n"
}

function templar_dev() {
    local i="${1:-1}"

    local options="";
    if [ "$2" == "prod" ]; then
        options+="TEMPLAR_SOURCE_HOST=yandex.ru"
    fi

    if [ "$3" == "tap" ]; then
        options+=" ECOM_TAP=true"
    fi

    set -x
    eval $options \
    TUNNELER_HOST=ws$i-tunnelerapi.si.yandex-team.ru \
    NODE_ENV=development \
    BUNDLE_FILTER=Beru,Health,Lc,Market,Mg,MM,News,Sport,Weather \
    npx templar start --middleware='./.templar/middleware' --dont-track -p $i$i$i$i --public
    set +x
}

function templar_testing() {
    local i="${1:-1}"

    local options="";
    if [ "$2" == "prod" ]; then
        options+="TEMPLAR_SOURCE_HOST=yandex.ru"
    fi

    if [ "$3" == "tap" ]; then
        options+=" ECOM_TAP=true"
    fi

    set -x
    eval $options \
    TUNNELER_HOST=ws$i-tunnelerapi.si.yandex-team.ru \
    NODE_ENV=testing \
    npx templar start --dont-track -p $i$i$i$i --public
    set +x
}
