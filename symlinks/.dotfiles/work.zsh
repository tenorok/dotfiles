alias sdev="ssh -o StrictHostKeyChecking=no tenorok-dev2.klg.yp-c.yandex.net"

alias npmw="npm config set registry http://registry.npmjs.org"
alias npmy="npm config set registry http://npm.yandex-team.ru"
alias ynpm='npm --registry http://npm.yandex-team.ru'
alias npm-yandex-deps='npm i --registry="http://npm.yandex-team.ru" && npm run deps --registry="http://npm.yandex-team.ru"'

export NODE_EXTRA_CA_CERTS=/etc/ssl/certs/YandexInternalCA.pem

alias opencode='NODE_EXTRA_CA_CERTS="$HOME/.config/opencode/YandexInternalRootCA.crt" npm_config_registry=https://npm.yandex-team.ru opencode'

function kotik_dev() {
    local i="${1:-1}"

    local options=""
    if [[ "$2" == "prod" ]]; then
        options+="DEV_SOURCE_HOST=yandex.ru"
    fi

    if [[ "$3" == "tap" ]]; then
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

    local options=""
    if [[ "$2" == "prod" ]]; then
        options+="DEV_SOURCE_HOST=yandex.ru"
    fi

    if [[ "$3" == "tap" ]]; then
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
    rm -rf ~/.pnpm-store
    pnpm store prune
}

function web4_clean {
    arc cleanup
    arc prefetch-files . --filter '**/*.js' --filter '**/*.jsx' --filter '**/*.ts' --filter '**/*.tsx' --filter '**/*.css' --filter '**/*.scss'
    pnpm run deps
    pnpm run build
    node ../../packages/dx-collection/generators/VSCodeSettings/cli.js --paths web4 --hideDotBuild --vsicons --jsonSchema
    $(npm prefix -g)/bin/ts-node $(arc root)/junk/tenorok/projects-settings/src/update-vscode-settings.ts
    ya tool aisuite cursor --preset goods/frontend/coda_oceania
}

function reef_clean {
    arc cleanup
    arc prefetch-files . --filter '**/*.js' --filter '**/*.jsx' --filter '**/*.ts' --filter '**/*.tsx' --filter '**/*.css' --filter '**/*.scss'
    pnpm run deps
    node ../../packages/dx-collection/generators/VSCodeSettings/cli.js --paths reef --hideDotBuild --vsicons --jsonSchema
    $(npm prefix -g)/bin/ts-node $(arc root)/junk/tenorok/projects-settings/src/update-vscode-settings.ts --project reef --whitelist-teams Freshness,Realty,UniSearch,Goods
    ya tool aisuite cursor --preset goods/frontend/coda_oceania
    pnpm run flag:build
}

function inspire_clean {
    arc cleanup
    arc prefetch-files .
    yarn install
    cp -r $(arc root)/junk/tenorok/projects-settings/inspire/vscode/settings.json .vscode/settings.json
}

function alice_clean {
    arc cleanup
    arc prefetch-files . --filter '**/*.js' --filter '**/*.jsx' --filter '**/*.ts' --filter '**/*.tsx' --filter '**/*.css' --filter '**/*.scss'
    pnpm deps
    pnpm build
    node ../../packages/dx-collection/generators/VSCodeSettings/cli.js --paths alice --hideDotBuild --vsicons --jsonSchema
    ya tool aisuite cursor --preset goods/frontend/coda_oceania
}

function yandex_clean {
    rm -rf ~/.yandex-int/kotik/cache/
    rm -rf ~/.yandex-int/.locks/
    rm -rf ~/.yandex-int/logs/
    rm -rf ~/.yandex-int/sandbox-resources/
    cd ~/arcadia && arc gc
    cd ~/arcadia2 && arc gc
    cd ~/arcadia3 && arc gc
    cd ~/arcadia4 && arc gc
    cd ~/arcadia5 && arc gc
}

function arc_clean {
    arc br --merged trunk | xargs arc br -d
}

function arc_mount {
    cd ~/

    arc mount --mount arcadia/ --store store/ --object-store objects/
    arc mount --mount arcadia2/ --store store2/ --object-store objects/
    arc mount --mount arcadia3/ --store store3/ --object-store objects/
    arc mount --mount arcadia4/ --store store4/ --object-store objects/
    arc mount --mount arcadia5/ --store store5/ --object-store objects/

    # Сборка MCP-серверов
    # Docs
    ~/arcadia/ya make -r ~/arcadia/junk/amikita/mcp/docs

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

_wt_worktrees_base() {
  local config="$HOME/.arc/arc-wt.yaml" base
  if [[ -f "$config" ]]; then
    base="$(grep -E '^worktrees_base_path:' "$config" | sed -E 's/^worktrees_base_path:[[:space:]]*//' | tr -d \"\'\" | head -1)"
    if [[ -n "$base" ]]; then
      print -r -- "${base/#\~/$HOME}"
      return
    fi
  fi
  print -r -- "$HOME/arcadia-wt"
}

_wt_add_has_custom() {
  for arg in "${@:2}"; do
    case "$arg" in
      --name|--name=*|--path|--path=*) return 0 ;;
    esac
  done
  return 1
}

_wt_add_branch() {
  local skip=false branch=""
  for arg in "${@:2}"; do
    if $skip; then
      skip=false
      continue
    fi
    case "$arg" in
      --name|--mode|--repo|--path|--base|--store-path|--object-store-path)
        skip=true
        ;;
      --name=*|--mode=*|--repo=*|--path=*|--base=*|--store-path=*|--object-store-path=*)
        ;;
      --*|-*)
        ;;
      *)
        branch="$arg"
        ;;
    esac
  done
  print -r -- "$branch"
}

wt() {
  local oceania=false
  local -a wt_args stripped
  for arg in "$@"; do
    if [[ "$arg" == "--oceania" ]]; then
      oceania=true
    else
      stripped+=("$arg")
    fi
  done
  wt_args=("${stripped[@]}")

  if [[ "$1" == "add" ]] && ! _wt_add_has_custom "$@"; then
    local branch task_key wt_base
    branch="$(_wt_add_branch "$@")"
    if [[ -n "$branch" && "$branch" == *.* ]]; then
      task_key="${branch##*.}"
      wt_base="$(_wt_worktrees_base)"
      wt_args=(add --name "$task_key" --path "$wt_base/$task_key" "${wt_args[@]:1}")
    fi
  fi

  if $oceania && [[ "${wt_args[1]}" == "add" ]] && [[ " ${wt_args[*]} " != *" --cd "* ]]; then
    wt_args=(add --cd "${wt_args[@]:1}")
  fi

  if [[ "${wt_args[1]}" == "cd" || ( "${wt_args[1]}" == "add" && " ${wt_args[*]} " == *" --cd "* ) ]]; then
    local dir output
    output="$(command wt "${wt_args[@]}")" || return
    dir="${output##*$'\n'}"
    if $oceania; then
      dir="$dir/search-interfaces/oceania"
    fi
    builtin cd "$dir" || return
    if $oceania; then
      pnpm install
    fi
  else
    command wt "${wt_args[@]}"
  fi
}
