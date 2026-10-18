#!/usr/bin/env bash
# Points ~/.jb_cfg_profiles/current at the profile named in JB_CFG_PROFILE.
set -euo pipefail
target="$JB_CFG_PROFILE_DIR"
[[ -d "$target" ]] || {
    echo "No profile directory: $target" >&2
    exit 1
}
ln -sfn "$target" "$JB_CFG_CURRENT_PROFILE_DIR"
ln -sfn "$JB_CFG_CURRENT_PROFILE_DIR/.config/nvim/lua/profile" "$HOME/.config/nvim/lua/profile"

[[ -d "$JB_CFG_LOGS_DIR" ]] || {
    echo "No $JB_CFG_LOGS_DIR directory, creating it"
    mkdir -p "$JB_CFG_LOGS_DIR"
}

# Link version controlled workflows from the profile to ~/Library/Services, so they are available in the Services menu.
lib_services_source_dir="$JB_CFG_PROFILE_DIR/Library/Services"
lib_services_dir="$HOME/Library/Services"
mkdir -p "$lib_services_dir"

# Remove links from an earlier run, so a removed workflow leaves no stale link.
find "$lib_services_dir" -maxdepth 1 -type l -lname "$HOME/.jb_cfg_profiles/*" -delete

for workflow in "$lib_services_source_dir"/*.workflow; do
    [[ -e "$workflow" ]] || continue
    ln -sfn "$workflow" "$lib_services_dir/$(basename "$workflow")"
done

# Link version controlled cron job definitions from the profile to ~/Library/LaunchAgents
lib_launchagents_source_dir="$JB_CFG_PROFILE_DIR/Library/LaunchAgents"
lib_launchagents_dir="$HOME/Library/LaunchAgents"
mkdir -p "$lib_launchagents_dir"

# Remove links from an earlier run, so a removed workflow leaves no stale link.
find "$lib_launchagents_dir" -maxdepth 1 -type l -lname "$HOME/.jb_cfg_profiles/*" -delete

for plist in "$lib_launchagents_source_dir"/*.plist; do
    [[ -e "$plist" ]] || continue
    ln -sfn "$plist" "$lib_launchagents_dir/$(basename "$plist")"
done

# The appearance app runs a fixed path in ~/Documents. OneDrive can make ~/Documents
# a symlink, and Git cannot track files under a symlinked folder. So this writes a
# small untracked wrapper there that runs the tracked script.
appearance_dir="$HOME/Documents/Appearance Watcher"
mkdir -p "$appearance_dir"
cat >"$appearance_dir/handle_appearance_change.sh" <<'EOF'
#!/bin/zsh
# Written by jb_cfg link_profile.sh. Edit ~/.jb_cfg_utils/scripts/handle_appearance_change.sh instead.
exec "$HOME/.jb_cfg_utils/scripts/handle_appearance_change.sh" "$@"
EOF
chmod +x "$appearance_dir/handle_appearance_change.sh"
