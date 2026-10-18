export JB_CFG_SCRIPTS_DIR="$HOME/.jb_cfg_utils/scripts"
export JB_CFG_SHELL_HELPERS_DIR="$HOME/.jb_cfg_utils/shell_helpers"
export JB_CFG_PROFILE="default"
export JB_CFG_LOGS_DIR="$HOME/.jb_cfg_utils/logs"
export JB_CFG_BREW_UPGRADE_LOG_PATH="$JB_CFG_LOGS_DIR/brew-upgrade.log"

# A `.zshenv_untracked` file can be used to set environment variables that are not intended to be tracked by version control.
# This is where you can set the profile env var JB_CFG_PROFILE to select a custom profile that lives under `~/.jb_cfg_profiles/<PROFILE_NAME>`
[[ -f ~/.zshenv_untracked ]] && . ~/.zshenv_untracked

# Source dir of the profile named in JB_CFG_PROFILE
export JB_CFG_PROFILE_DIR="$HOME/.jb_cfg_profiles/$JB_CFG_PROFILE"

# Dir for the current profile, which is a symlink to JB_CFG_PROFILE_DIR
export JB_CFG_CURRENT_PROFILE_DIR="$HOME/.jb_cfg_profiles/current"

# Load profile-specific .zshenv if it exists -- keep this at the bottom
if [[ -f "$JB_CFG_PROFILE_DIR/.zshenv" ]] then
    . "$JB_CFG_PROFILE_DIR/.zshenv"
fi
