EMAIL=${1:-mail@tenorok.ru}
KEY_NAME=${1:-id_rsa}

[ -d ~/.ssh ] || mkdir ~/.ssh
[ -f ~/.ssh/config ] || cp -n ssh/config ~/.ssh/config
[ -f ~/.ssh/rc ] || cp -n ssh/rc ~/.ssh/rc
chmod 644 ~/.ssh/config
ssh-keygen -t rsa -C "$EMAIL" -N "" -f ~/.ssh/$KEY_NAME
pbcopy < ~/.ssh/$KEY_NAME.pub
echo -e "\033[0;32mPaste key from your clipboard to https://github.com/settings/ssh"
