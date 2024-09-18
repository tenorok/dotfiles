EMAIL=${1:-mail@tenorok.ru}
KEY_NAME=${2:-id_rsa}

[ -d ~/.ssh ] || mkdir ~/.ssh
[ -f ~/.ssh/config ] || ln -s ssh/config ~/.ssh/config
[ -f ~/.ssh/rc ] || ln -s ssh/rc ~/.ssh/rc
ssh-keygen -t ed25519 -C "$EMAIL" -N "" -f ~/.ssh/$KEY_NAME
pbcopy < ~/.ssh/$KEY_NAME.pub
echo -e "\033[0;32mPaste key from your clipboard to https://github.com/settings/ssh"
