########################################
### Environment
########################################
export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR=nvim
export VISUAL="$EDITOR"
export AWS_PAGER=cat
# tmux draws icons only when the locale is UTF-8. Set it if nothing else did.
export LANG="${LANG:-en_US.UTF-8}"

# Homebrew: static paths, so no `brew` subprocess at startup.
# Also lets Automator scripts find brew.
export HOMEBREW_PREFIX=/opt/homebrew
export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"
PATH="$HOME/.tmux/plugins/tmux-open-nvim/scripts:${PATH}"

# Lazygit reads theme.yml on top of config.yml.
# handle_appearance_change.sh writes theme.yml when macOS appearance changes.
if [[ -f "$XDG_CONFIG_HOME/lazygit/theme.yml" ]]; then
  export LG_CONFIG_FILE="$XDG_CONFIG_HOME/lazygit/config.yml,$XDG_CONFIG_HOME/lazygit/theme.yml"
fi

########################################
### Oh My Zsh
########################################
# Oh My Zsh runs compinit. zsh reads fpath only when compinit runs,
# so every completion directory must be in fpath before this source line.
fpath=(
  "$HOME/.jb_cfg_utils/shell_helpers"
  "$HOMEBREW_PREFIX/share/zsh/site-functions"
  $fpath
)
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""   # Starship draws the prompt
plugins=(zsh-autosuggestions zsh-syntax-highlighting)
# Allow additional OMZ plugins to be loaded
if [[ -f "$JB_CFG_PROFILE_DIR/omz_plugins.zsh" ]]; then
  . "$JB_CFG_PROFILE_DIR/omz_plugins.zsh"
fi
source "$ZSH/oh-my-zsh.sh"

########################################
### Tools
########################################
# fnm (Node): always on, it switches versions per directory.
eval "$(fnm env --use-on-cd --version-file-strategy=recursive --resolve-engines)"

# Opts into loading rbenv (Ruby) and/or pyenv (Python) when applicable.
source "$JB_CFG_SHELL_HELPERS_DIR/optional_runtimes.zsh"

# 1Password CLI completion
eval "$(op completion zsh)"; compdef _op op

eval "$(starship init zsh)"

# fzf: Ctrl+R searches all history from every directory.
# The two empty variables turn off fzf's Ctrl+T and Alt+C bindings.
if (( $+commands[fzf] )); then
  FZF_CTRL_T_COMMAND= FZF_ALT_C_COMMAND= source <(fzf --zsh)
fi

# Up/Down: commands from this project only (a git repo and all its worktrees).
# Keep this after Oh My Zsh and fzf, so its key bindings win.
source "$JB_CFG_SHELL_HELPERS_DIR/cmds_from_project_history.zsh"

########################################
### Begin Preferences
########################################
# Actually clear when hitting Ctrl+l
function clear_screen() {
  clear
  zle reset-prompt
}
zle -N clear_screen
bindkey '^L' clear_screen
########################################
### End Preferences
########################################

########################################
### Begin Aliases
########################################
# Git for .jb_cfg (machine config repo)
alias jbcfg='git --git-dir="$HOME/.jb_cfg/" --work-tree="$HOME"'
alias lg_jbcfg='lazygit --git-dir="$HOME/.jb_cfg/" --work-tree="$HOME"'
alias jbcfg_link_profile="$JB_CFG_SCRIPTS_DIR/link_profile.sh"
alias jbcfg_update='jbcfg pull && jbcfg_link_profile'

# Fix macOS clock sync issues
alias sync_clock='sudo sntp -sS time.apple.com'

# Print all terminal colors
function print_term_colors() {
  for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}

function set_colorscheme_light() {
  echo 'Setting theme in macOS'
  osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to false'
  echo 'Setting theme in kitty'
  kitty +kitten themes --reload-in=all Catppuccin-Latte
  echo 'Setting theme in tmux'
  # Fails if tmux isn't running, that's OK
  tmux set -g window-style 'bg=color253' || true
}

function set_colorscheme_dark() {
  echo 'Setting theme in macOS'
  osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
  echo 'Setting theme in kitty'
  kitty +kitten themes --reload-in=all Catppuccin-Mocha
  echo 'Setting theme in tmux'
  # Fails if tmux isn't running, that's OK
  tmux set -g window-style 'bg=color236' || true
}

# Shortcut to open a new tmux session or attach to an existing one
function mux() {
    if [ -n "$TMUX" ]; then
        echo " You're already in a Tmux session "
        return 0
    fi

    if [ -z "$1" ]; then
        tmux attach
    else
        tmux new-session -A -s "$1"
    fi
}

# Simple list of tmux sessions
alias muxls='tmux list-sessions -F "#{session_name}"'

# Autocompletion based on currently open sessions
_mux() {
    local -a sessions
    sessions=($(tmux list-sessions -F "#{session_name}" 2>/dev/null))
    compadd -a sessions
}
compdef _mux mux

# CD into the dir provided or use an autocompleted second argument
function cd_with_subpath() {
    local dir_to_cd_into="$1"
    if [ ! -z "$2" ]; then
        dir_to_cd_into="$dir_to_cd_into/$2"
    fi

    cd "$dir_to_cd_into"
}

# Go to Obsidian Default vault dir
function cdnotes() {
  if [[ -z "$JB_CFG_NOTES_DIR" ]]; then
    echo "JB_CFG_NOTES_DIR is not set. Please set it in your profile."
    return 1
  fi
  cd "$JB_CFG_NOTES_DIR" || return 1
}

function remove_worktrees() {
  if [[ -z "$JB_CFG_WORKTREES_DIR" ]]; then
    echo "JB_CFG_WORKTREES_DIR is not set. Please set it in your profile."
    return 1
  fi

  "$JB_CFG_SCRIPTS_DIR/git/remove_worktrees.sh" "$JB_CFG_WORKTREES_DIR/$1"
}

function list_dirty_repos() {
    for project_dir in */; do
            (
                cd "$(pwd)/$project_dir"
                wd_is_dirty=$(git status --porcelain)

                if [ ! -z "$wd_is_dirty" ]; then
                        echo $project_dir
                fi
            )
    done
}

function fetch_all_repos() {
    for project_dir in */; do
        (
            echo "########################################"
            echo "  Fetching latest for $project_dir..."
            cd "$(pwd)/$project_dir" || exit

            echo "🔎 Checking if a stash is needed..."
            wd_is_dirty=$(git status --porcelain)

            if [ -z "$wd_is_dirty" ]; then
                echo "✨ Working directory clean"
                git fetchtrunk
            else
                echo "🗄 Temporarily stashing changes"
                git add .
                git stash --quiet -m "Temporary stash while fetching latest"
                git fetchtrunk
                git stash pop --quiet
                echo "🗄 Stashed changes reapplied"
            fi

            echo "✅ Fetched latest"
        )
    done
    echo "########################################"
}

function install_latest_node() {
    requested_version="$1"
    if [ -z "$requested_version" ]; then
        echo "Please provide a Node.js version (e.g., 'lts', 'current', '16', '18')"
        return 1
    fi

    actual_version=$(fnm ls-remote --filter "$requested_version" | tail -n 1)
    if [ -z "$actual_version" ]; then
        echo "Encountered an error while trying to resolve the latest Node.js version for '$requested_version'"
        return 1
    fi

    echo "Installing latest Node.js version $1: $actual_version"
    fnm install "$actual_version"
    echo "Defaulting to Node.js version $actual_version"
    fnm default "$actual_version"
    echo "Using Node.js version $actual_version"
    fnm use "$actual_version"
}

# Removes a directory in the background so that you don't have to wait, e.g. node_modules
function rm_in_background() {
    dir_to_remove="$1"
    if [ -z "$dir_to_remove" ]; then
        echo "Please provide a directory to remove"
        return 1
    fi

    echo "Beginning deletion of '$dir_to_remove' in background..."
    rm -rf "$dir_to_remove" &
}

# After updates to Kitty the icon resets when it's quit, this resets it to the custom icon
alias fix_kitty_icon_cache='rm /var/folders/*/*/*/com.apple.dock.iconcache; killall Dock'

# Shortcut to check current AWS identity
function awswhoami() {
    echo "Submitting STS Get Caller Identity request"
    aws sts get-caller-identity --no-cli-pager | jq -r .Arn
}

########################################
### End Aliases
########################################

# Load profile-specific .zshrc if it exists -- keep this at the bottom
if [[ -f "$JB_CFG_PROFILE_DIR/.zshrc" ]]; then
  . "$JB_CFG_PROFILE_DIR/.zshrc"
fi
