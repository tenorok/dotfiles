DOTFILES_DIR=$(pwd)
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

shopt -s dotglob nullglob

for src in symlinks/*; do
    f=$(basename "$src")
    dest="$HOME/$f"
    target="$DOTFILES_DIR/$src"

    # Бэкап, если назначение уже существует и не является нашим симлинком
    if [[ -e "$dest" || -L "$dest" ]]; then
        if [[ "$(readlink "$dest")" != "$target" ]]; then
            mkdir -p "$BACKUP_DIR"
            mv "$dest" "$BACKUP_DIR/$f"
            echo "Backed up ~/$f → $BACKUP_DIR/$f"
        fi
    fi

    ln -sfn "$target" "$dest"
done

shopt -u dotglob nullglob

source ~/dotfiles/symlinks/.bash_profile

curl https://raw.githubusercontent.com/alecthomas/ondir/master/scripts.sh --output $(pwd)/symlinks/.dotfiles/ondir-scripts.sh
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash --output $(pwd)/symlinks/.dotfiles/git-completion.sh
