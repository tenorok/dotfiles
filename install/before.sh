for f in $(ls -A symlinks/); do ln -sfn $(pwd)/symlinks/$f ~/$f; done
source ~/dotfiles/symlinks/.bash_profile

curl https://raw.githubusercontent.com/alecthomas/ondir/master/scripts.sh --output $(pwd)/symlinks/.dotfiles/ondir-scripts.sh
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash --output $(pwd)/symlinks/.dotfiles/git-completion.sh
