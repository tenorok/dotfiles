# Dotfiles

Быстрая настройка окружения на новой машине MacOS и Ubuntu. Shell: **zsh**.

## Установка

### MacOS

Перед установкой в MacOS необходимо наличие [OS X Developer Tools](https://developer.apple.com/technologies/tools/).

```
./install/before.sh

# Генерация ssh-ключа
./install/ssh-keygen.sh
# Генерация ssh-ключа с нестандартной почтой и именем файла
./install/ssh-keygen.sh tenorok@yandex-team.ru id_yandex

./install/osx.sh
./install/after.sh
```

### Ubuntu

```
./install/before.sh
./install/ubuntu.sh
./install/after.sh
```

Для избежания ошибки ENOSPC в больших проектах:
1. Открыть `sudo micro /etc/sysctl.conf`
2. Добавить в конец строку `fs.inotify.max_user_watches=524288`
3. Выполнить `sudo sysctl -p`

Для подключения VSCode нужно разрешить форвардинг:
1. Открыть `sudo micro /etc/ssh/sshd_config`
2. Расскомментировать строку `AllowTcpForwarding yes`

Если после пересоздания машины с тем же хостом нужно локально выполнить: `ssh-keygen -R <host>`.

Для переключения на рабочее окружение нужно создать директорию `mkdir ~/yandex`.

## Структура конфигурации zsh

| Файл | Когда загружается | Назначение |
|------|-------------------|------------|
| `~/.zshenv` | Всегда (в т.ч. неинтерактивный shell) | PATH, LANG, DOTFILES, NVM_DIR |
| `~/.zprofile` | Login shell (Terminal/iTerm, SSH) | brew shellenv |
| `~/.zshrc` | Интерактивный shell | История, плагины, prompt, aliases |

Модули в `~/.dotfiles/`:
- `prompt.zsh` — кастомный PROMPT с git/arc статусом
- `aliases.zsh` — алиасы, gitDefault, NPMDefault
- `osx.zsh` / `ubuntu.zsh` — настройки, специфичные для ОС
- `home.zsh` / `work.zsh` — домашнее/рабочее окружение
- `chpwd-hooks.zsh` — автовыбор Node через nvm при смене директории
- `completions.zsh` — compinit, FPATH, git/arc/runjs completions
- `secrets.zsh` — загрузка API-ключей из `~/.secrets/env/`

## Секреты

Переменные окружения с токенами **не хранятся в репозитории**. При открытии shell `secrets.zsh` читает файлы из `~/.secrets/env/`: имя файла = имя переменной, содержимое — одна строка со значением (с переводом строки в конце или без — оба варианта работают).

```sh
mkdir -p ~/.secrets/env
chmod 700 ~/.secrets/env
printf '%s' 'значение' > ~/.secrets/env/ИМЯ_ПЕРЕМЕННОЙ
chmod 600 ~/.secrets/env/*
```

Переопределение каталога: `ENV_SECRETS_DIR`.

### Work (`~/yandex` есть)

Типичные файлы:

- `ANTHROPIC_AUTH_TOKEN`
- `ELIZA_TOKEN`
- `PAID_NPM_PACKAGE_REGISTRY_TOKEN`
- `TANKER_API_TOKEN`

`ANTHROPIC_BASE_URL` для Eliza задаётся в `secrets.zsh` (не в файлах).

### Home (`~/yandex` нет)

Типичные файлы:

- `OPENROUTER_API_KEY`
- `ANTHROPIC_AUTH_TOKEN` (если нужен тот же ключ, что и для OpenRouter)

`ANTHROPIC_BASE_URL` для OpenRouter задаётся в `secrets.zsh`.

### HashiCorp Vault (только home)

Распечатка личного Vault — отдельно от env-файлов: `vault_unseal` в `home.zsh`, ключи в `~/.secrets/vault.json`. После миграции с `env.zsh` ключ OpenRouter в Vault можно не использовать для shell; достаточно файла `~/.secrets/env/OPENROUTER_API_KEY`.

### Обновление ключа в текущем shell

```
# отредактировать файл, затем:
load_env_secrets
```

### Ротация

Если токены когда-либо попадали в git — перевыпустить их в соответствующих сервисах.

## Atom

Сохранить установленные плагины в файл:
```
apm list --installed --bare > atom/packages.txt
```

Установить плагины из файла:
```
apm install --packages-file atom/packages.txt
```
