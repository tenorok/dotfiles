.PHONY: brew subl git env bash ssh

all: brew-install brew subl git env bash ssh

pwd = $(shell pwd)

brew-install:
	curl -L github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C /usr/local
	brew install phinze/cask/brew-cask

brew:
	./brew

subl:
	cp Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/
	git clone https://github.com/fman7/frontend-light/ ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/frontend-light

git:
	ln -s ${pwd}/git-completion.bash ~/.git-completion.bash
	ln -s ${pwd}/gitconfig ~/.gitconfig
	ln -s ${pwd}/gitignore ~/.gitignore

env:
	ln -s ${pwd}/ondirrc ~/.ondirrc
	mkdir ~/.nvm

bash:
	ln -s ${pwd}/bash_profile ~/.bash_profile

bash-osx:
	ln -s ${pwd}/bash_osx ~/.bash_osx
	curl -fsSL https://raw.githubusercontent.com/rgcr/m-cli/master/install.sh | sh

ssh:
	[ -d ~/.ssh ] || mkdir ~/.ssh
	[ -f ~/.ssh/config ] || cp -n ssh/config ~/.ssh/config
	chmod 644 ~/.ssh/config
	ssh-keygen -t rsa -C "mail@tenorok.ru" -N "" -f ~/.ssh/id_rsa
	pbcopy < ~/.ssh/id_rsa.pub
	echo -e "\033[0;32mPaste key from your clipboard to https://github.com/settings/ssh"
