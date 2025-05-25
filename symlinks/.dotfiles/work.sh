alias sdev="ssh -Y -X tenorok-dev.klg.yp-c.yandex.net"
alias sdev2="ssh -Y -X tenorok-dev2.vla.yp-c.yandex.net"

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

function p_clean {
	rm -rf ~/.pnpm-virtual-store/
	pnpm store prune
}

function web4_clean {
    arc cleanup
    arc prefetch-files . --filter '**/*.js' --filter '**/*.jsx' --filter '**/*.ts' --filter '**/*.tsx' --filter '**/*.css' --filter '**/*.scss'
    pnpm run deps
    pnpm run build
    pnpm run generate:vscode-settings --excludeBuild Y --vsicons Y
}

function goods_clean {
    arc cleanup
    arc prefetch-files . --filter '**/*.js' --filter '**/*.jsx' --filter '**/*.ts' --filter '**/*.tsx' --filter '**/*.css' --filter '**/*.scss'
    pnpm i
    pnpm build
}

function ecomcom_clean {
	arc cleanup
	arc prefetch-files .
	pnpm i
}

function yandex_clean {
    rm -rf ~/.yandex-int/kotik/cache/
    rm -rf ~/.yandex-int/.locks/
    rm -rf ~/.yandex-int/logs/
    rm -rf ~/.yandex-int/sandbox-resources/
    cd ~/arcadia && arc gc
    cd ~/arcadia2 && arc gc
    cd ~/arcadia3 && arc gc
}

function arc_clean {
    arc br --merged trunk | xargs arc br -d
}

function arc_mount {
    cd ~/
    arc mount --mount arcadia/ --store store/ --object-store objects/
    arc mount --mount arcadia2/ --store store2/ --object-store objects/
    arc mount --mount arcadia3/ --store store3/ --object-store objects/
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
