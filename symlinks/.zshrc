export PROFILE=~/.zshrc

# История
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=200000
setopt EXTENDED_HISTORY        # записывать timestamp
setopt INC_APPEND_HISTORY      # писать сразу после команды (аналог PROMPT_COMMAND='history -a')
setopt SHARE_HISTORY           # синхронизировать историю между сессиями
setopt HIST_IGNORE_ALL_DUPS    # не хранить дубликаты (аналог erasedups)
setopt HIST_IGNORE_SPACE       # не сохранять команды с ведущим пробелом
setopt HIST_REDUCE_BLANKS      # убирать лишние пробелы (аналог cmdhist)
setopt HIST_VERIFY             # показывать подстановку истории перед выполнением

# Навигация и глобы
setopt AUTO_CD                 # ввод имени папки без cd
setopt AUTO_PUSHD              # cd пушит директории в стек
setopt PUSHD_IGNORE_DUPS       # без дублей в стеке
setopt EXTENDED_GLOB           # расширенные шаблоны (#, ^, ~)
setopt NULL_GLOB               # не выдавать ошибку при пустом glob
setopt INTERACTIVE_COMMENTS    # разрешить комментарии в интерактивном режиме

# Хуки
autoload -Uz add-zsh-hook

# Вспомогательная функция: source только если файл существует
include() { [[ -f "$1" ]] && source "$1" }

# Перезагрузка конфига
init() { source ~/.zshrc }

include $DOTFILES/prompt.zsh
include $DOTFILES/aliases.zsh
include $DOTFILES/chpwd-hooks.zsh

# Определяем OS и подключаем нужный модуль
if [[ -f /usr/bin/hostnamectl ]]; then
  include $DOTFILES/ubuntu.zsh
else
  include $DOTFILES/osx.zsh
fi

# GIT и NPM настройки по умолчанию (функции из aliases.zsh)
gitDefault
NPMDefault

# Ruby (rvm)
include $HOME/.rvm/scripts/rvm

# Completions
include $DOTFILES/completions.zsh

# Secrets / API-ключи (после brew/PATH)
include $DOTFILES/env.zsh
