.PHONY: brew subl git bash ssh

all: brew brewcask subl git bash ssh

brew:
	curl -L github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C /usr/local
	brew install git node wget

brewcask:
	brew install phinze/cask/brew-cask
	brew cask install sublime-text webstorm iterm2 gitx mou \
	google-chrome firefox adium skype teamviewer \
	dropbox evernote transmit transmission vlc

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
