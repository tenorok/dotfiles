# FPATH: сначала расширяем, потом вызываем compinit

# Локальные completions из репозитория (git-completion.zsh скачивается в before.sh)
fpath=($DOTFILES/completions $fpath)

# Zsh-completions и site-functions от brew
if type brew &>/dev/null; then
    HOMEBREW_PREFIX="$(brew --prefix)"
    fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
    fpath=("$HOMEBREW_PREFIX/share/zsh-completions" $fpath)
fi

# NVM bash_completion корректно грузится под zsh
include $(brew --prefix 2>/dev/null)/opt/nvm/etc/bash_completion.d/nvm

# arc: генерируем zsh-completion при наличии arc
if command -v arc &>/dev/null; then
    local arc_comp_dir="$HOME/.arc"
    mkdir -p "$arc_comp_dir"
    arc completion zsh > "$arc_comp_dir/_arc" 2>/dev/null && fpath=("$arc_comp_dir" $fpath)
fi

# runjs: используем bashcompinit как совместимый слой
if [[ -f "$DOTFILES/runjs.completion.sh" ]]; then
    autoload -Uz bashcompinit && bashcompinit
    source "$DOTFILES/runjs.completion.sh"
fi

# Инициализация completion-системы
autoload -Uz compinit
compinit -u
