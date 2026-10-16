#!/usr/bin/env bash
### Can be run to completely set up a new machine
GIT_DIR="$HOME/.jb_cfg"
BACKUP_DIR="$HOME/.config_backup"

function jbcfg {
    git --git-dir="$GIT_DIR/" --work-tree="$HOME" "$@"
}

if [ ! -d "$GIT_DIR" ]; then
    echo " Cloning config repo..."
    git clone --bare https://github.com/Jack-Barry/jb_cfg "$GIT_DIR"
else
    echo " Repo already exists, attempting to pull latest"
    jbcfg pull
fi

echo "Backing up files that the repo will replace..."
jbcfg ls-tree -r --name-only HEAD | while IFS= read -r file; do
    if [[ -e "$HOME/$file" || -L "$HOME/$file" ]]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$file")"
        mv "$HOME/$file" "$BACKUP_DIR/$file"
        echo "Moved $file to $BACKUP_DIR/$file"
    fi
done

echo "🏗  Populating $HOME with config from repo..."
CHECKOUT_RESULT=$(jbcfg checkout 2>&1)
CHECKOUT_STATUS=$?
if [[ $CHECKOUT_STATUS -ne 0 ]]; then
    echo "$CHECKOUT_RESULT"
    echo "❌ Encountered some trouble, bailing"
    exit 1
fi

echo "✅ Config files installed, ready to set things up"
"$HOME/.jb_cfg_utils/scripts/setup.sh"

jbcfg config status.showUntrackedFiles no
