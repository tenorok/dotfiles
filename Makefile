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
	mkdir ~/.ssh
	cp -n ssh/config ~/.ssh/config
