alias sdev="ssh -Y -X tenorok-dev.sas.yp-c.yandex.net"

alias npmw="npm config set registry http://registry.npmjs.org"
alias npmy="npm config set registry http://npm.yandex-team.ru"
alias ynpm='npm --registry http://npm.yandex-team.ru'
alias npm-yandex-deps='npm i --registry="http://npm.yandex-team.ru" && npm run deps --registry="http://npm.yandex-team.ru"'

function kotik_dev() {
    local i="${1:-1}"

    local options="";
    if [ "$2" == "prod" ]; then
        options+="DEV_SOURCE_HOST=yandex.ru"
    fi

    if [ "$3" == "tap" ]; then
        options+=" ECOM_TAP=true"
    fi

    set -x
    eval $options \
    TUNNELER_HOST=ws$i-tunnelerapi.si.yandex-team.ru \
    BUNDLE_FILTER=Beru,Health,Lc,Market,Mg,MM,News,Sport,Weather \
    NODE_ENV=development npx archon kotik --kotik-counters -p $i$i$i$i --rebuild true --data-fetch-timeout 60000 --public
    set +x
}

function kotik_testing() {
    local i="${1:-1}"

    local options="";
    if [ "$2" == "prod" ]; then
        options+="DEV_SOURCE_HOST=yandex.ru"
    fi

    if [ "$3" == "tap" ]; then
        options+=" ECOM_TAP=true"
    fi

    set -x
    eval $options \
    TUNNELER_HOST=ws$i-tunnelerapi.si.yandex-team.ru \
    NODE_ENV=testing \
    npx archon kotik --kotik-counters -p $i$i$i$i --public
    set +x
}
