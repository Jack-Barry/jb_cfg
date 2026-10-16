#!/bin/zsh
# The background app runs this script when macOS appearance changes.
# $1 is "dark" or "light".
export PATH="/opt/homebrew/bin:$PATH"

APPEARANCE_MODE="$1"

case "$APPEARANCE_MODE" in
  dark)  TMUX_BG="color236" ;;
  light) TMUX_BG="color253" ;;
  *)     echo "usage: $0 dark|light" >&2; exit 1 ;;
esac

# Fails if tmux isn't running, that's OK
tmux set -g window-style "bg=$TMUX_BG" 2>/dev/null || true

# Lazygit reads theme.yml on top of config.yml (see LG_CONFIG_FILE in ~/.zshrc).
# config.yml stays unchanged, so the dotfiles repo shows no change on each switch.
# Do not add theme.yml to the dotfiles repo.
cat > "$HOME/.config/lazygit/theme.yml" <<YAML
git:
  paging:
    pager: delta --paging=never --$APPEARANCE_MODE -s
YAML
