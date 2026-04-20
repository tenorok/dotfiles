# Dotfiles

Быстрая настройка окружения на новой машине MacOS и Ubuntu.

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

## Секреты

API-ключи хранятся в личном [HashiCorp Vault](https://developer.hashicorp.com/vault) (KV v2, движок `kv/`).

При каждом открытии shell скрипт `env.sh` автоматически получает ключи из Vault и кэширует их в `~/.cache/openrouter.token` (TTL 7 дней). Если Vault недоступен (не дома / нет VPN / запечатан) — используется кэш.

### Первичная настройка

1. Убедиться, что Vault запущен и распечатан (`vault_unseal`).
2. Войти: `vault login`.
3. Положить ключ OpenRouter:
   ```
   vault kv put kv/openrouter api_key='sk-or-v1-...'
   ```
4. Открыть новый shell — ключ подхватится автоматически.

### Обновление ключа

```
vault kv put kv/openrouter api_key='sk-or-v1-новый-ключ'
load_openrouter_key  # обновить в текущем shell без перезапуска
```

## Atom

Сохранить установленные плагины в файл:
```
apm list --installed --bare > atom/packages.txt
```

Установить плагины из файла:
```
apm install --packages-file atom/packages.txt
```
