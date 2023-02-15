alias sdev="ssh -Y -X tenorok-dev.man.yp-c.yandex.net"
alias sdev2="ssh -Y -X tenorok-dev2.vla.yp-c.yandex.net"

alias npmw="npm config set registry http://registry.npmjs.org"
alias npmy="npm config set registry http://npm.yandex-team.ru"
alias ynpm='npm --registry http://npm.yandex-team.ru'
alias npm-yandex-deps='npm i --registry="http://npm.yandex-team.ru" && npm run deps --registry="http://npm.yandex-team.ru"'
alias p="pnpm"

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

function web4_clean {
    arc cleanup
    arc prefetch-files .
    pnpm run deps
    pnpm run build
}

function goods_clean {
    arc cleanup
    arc prefetch-files .
    pnpm i
    pnpm build
}

function yandex_clean {
    rm -rf ~/.yandex-int/kotik/cache/
    rm -rf ~/.yandex-int/.locks/
    rm -rf ~/.yandex-int/logs/
    rm -rf ~/.yandex-int/sandbox-resources/
    cd ~/arc/arcadia && arc gc
    cd ~/arc/arcadia2 && arc gc
}

function arc_mount {
    cd ~/arc/
    arc mount --mount arcadia/ --store store/ --object-store objects/
    arc mount --mount arcadia2/ --store store2/ --object-store objects/
    cd -
}

function arcstc {
    arc status -s $PWD | grep -E '^(.U|U.|AA|DD) ' | cut -d ' ' -f 2
}

function arcprune {
    arc checkout trunk
    arc pull -r
    arc branch --merged | grep -v trunk | xargs -L 1 arc branch -d
}
