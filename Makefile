.PHONY: all

all: brew subl

brew:
	curl -L github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C /usr/local
	brew install git node wget

subl:
	ln -s /Applications/Sublime Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl
