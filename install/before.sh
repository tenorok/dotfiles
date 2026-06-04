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

# arc читает ~/.arc/arc-wt.yaml; каноническая копия — в ~/.dotfiles/.arc/
arc_wt_src="$DOTFILES_DIR/symlinks/.dotfiles/.arc/arc-wt.yaml"
arc_wt_dest="$HOME/.arc/arc-wt.yaml"
mkdir -p "$HOME/.arc"
if [[ -e "$arc_wt_dest" || -L "$arc_wt_dest" ]]; then
    if [[ "$(readlink "$arc_wt_dest")" != "$arc_wt_src" ]]; then
        mkdir -p "$BACKUP_DIR/.arc"
        mv "$arc_wt_dest" "$BACKUP_DIR/.arc/arc-wt.yaml"
        echo "Backed up ~/.arc/arc-wt.yaml → $BACKUP_DIR/.arc/arc-wt.yaml"
    fi
fi
ln -sfn "$arc_wt_src" "$arc_wt_dest"

shopt -u dotglob nullglob

# git-completion для zsh: обёртка + bash-источник
mkdir -p "$(pwd)/symlinks/.dotfiles/completions"
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh \
    --output "$(pwd)/symlinks/.dotfiles/completions/_git"
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash \
    --output "$(pwd)/symlinks/.dotfiles/completions/git-completion.bash"

echo "Restart your terminal to load zsh configuration."
