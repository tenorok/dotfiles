# Dotfiles

Быстрая настройка окружения на новой машине с OS X.

## Установка

Перед установкой необходимо наличие [OS X Developer Tools](https://developer.apple.com/technologies/tools/).

```bash
make
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
