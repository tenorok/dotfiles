# Dotfiles

Быстрая настройка окружения на новой машине MacOS и Ubuntu.

## Установка

### MacOS

Перед установкой в MacOS необходимо наличие [OS X Developer Tools](https://developer.apple.com/technologies/tools/).

```
./install/common.sh

# Генерация ssh-ключа
./install/ssh-keygen.sh
# Генерация ssh-ключа с нестандартной почтой и именем файла
./install/ssh-keygen.sh tenorok@yandex-team.ru id_yandex

./install/osx.sh
```

### Ubuntu

```
./install/common.sh
./install/ubuntu.sh
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
