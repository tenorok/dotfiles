.PHONY: brew subl git bash ssh

all: brew-install brew subl git bash ssh

brew-install:
	curl -L github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C /usr/local
	brew install phinze/cask/brew-cask

brew:
	./brew

subl:
	cp Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/

git:
	cp git-completion.bash ~/.git-completion.bash
	cp gitconfig ~/.gitconfig
	cp gitignore ~/.gitignore

bash:
	cp bash_profile ~/.bash_profile

ssh:
	[ -d ~/.ssh ] || mkdir ~/.ssh
	[ -f ~/.ssh/config ] || cp -n ssh/config ~/.ssh/config
	chmod 644 ~/.ssh/config
	ssh-keygen -t rsa -C "mail@tenorok.ru" -N "" -f ~/.ssh/id_rsa
	pbcopy < ~/.ssh/id_rsa.pub
	echo -e "\033[0;32mPaste key from your clipboard to https://github.com/settings/ssh"
