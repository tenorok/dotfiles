autoload -Uz add-zsh-hook

# nvm: автоматически переключать версию Node при наличии .nvmrc
nvm_use() {
    if [[ -f ".nvmrc" ]] && command -v nvm &>/dev/null; then
        nvm use
    fi
}

# Вызвать nvm_use при смене директории
add-zsh-hook chpwd nvm_use
