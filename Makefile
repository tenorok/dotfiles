.PHONY: all

all: brew subl git bash ssh

brew:
	curl -L github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C /usr/local
	brew install git node wget

subl:
	ln -s /Applications/Sublime Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl

git:
	cp git-completion.bash ~/.git-completion.bash
	cp gitconfig ~/.gitconfig
	cp gitignore ~/.gitignore

bash:
	cp bash_profile ~/.bash_profile

ssh:
	mkdir ~/.ssh
	cp -n ssh/config ~/.ssh/config
