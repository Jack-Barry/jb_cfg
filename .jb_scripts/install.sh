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

CONFLICTING_FILES=$(jbcfg checkout 2>&1 | egrep "\s+\.|README\.md")
if [[ ${#CONFLICTING_FILES[@]} == 0 ]]; then
	echo "👌 Looks like a fresh install"
else
	echo "  Backing up overlapping config files..."
	while IFS= read -r line; do
		file=$(echo "$line" | awk '{$1=$1; print}')
		file_dir=$(dirname "$file")
		mkdir -p "$BACKUP_DIR/$file_dir"
		if [ -f "$file" ]; then
			backup_path="$BACKUP_DIR/$file"
			echo " Copying $file to $backup_path"
			mv "$file" "$backup_path"
		else
			if [ ! -z "$file" ]; then
				echo " File does not exist: '$file'"
			fi
		fi
	done <<<"$CONFLICTING_FILES"
fi

echo "🏗  Populating $HOME with config from repo..."
CHECKOUT_RESULT=$(jbcfg checkout 2>&1)
CHECKOUT_STATUS=$?
if [[ $CHECKOUT_STATUS -ne 0 ]]; then
	echo "$CHECKOUT_RESULT"
	echo "❌ Encountered some trouble, bailing"
	exit 1
fi

echo "✅ Config files installed, ready to set things up"
"$HOME/.jb_scripts/setup.sh"
