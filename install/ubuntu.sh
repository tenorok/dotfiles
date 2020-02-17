sudo -v # ask for password only at the beginning

ln -sfn ${pwd}/tmux.conf ~/.tmux.conf
add-apt-repository ppa:git-core/ppa
add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main restricted universe multiverse"
apt-get update
apt-get install git git-lfs tmux ag ondir
