autoload -Uz add-zsh-hook

# nvm: автоматически переключать версию Node при наличии .nvmrc
nvm_use() {
    if [[ -f ".nvmrc" ]] && command -v nvm &>/dev/null; then
        nvm use
    fi
}

# Вызвать nvm_use при старте shell — кроме каталогов arcadia (там ondir сам вызовет)
nvm_use_oninit() {
    case "$PWD" in
        $HOME/arcadia*/*) ;;
        *) nvm_use ;;
    esac
}

# ondir: запускаем при каждой смене директории через нативный zsh-хук
if command -v ondir &>/dev/null; then
    _ondir_hook() {
        eval "$(ondir "$OLDPWD" "$PWD" 2>/dev/null)"
    }
    add-zsh-hook chpwd _ondir_hook
    # Запуск при инициализации shell (аналог `eval "$(ondir /)"` из ondir-scripts.sh)
    eval "$(ondir / "$PWD" 2>/dev/null)"
fi

# Вызвать nvm_use при смене директории
add-zsh-hook chpwd nvm_use
