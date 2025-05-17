#!/bin/zsh
export PATH="/Applications/kitty.app/Contents/MacOS:/usr/local/bin:$PATH"

APPEARANCE_MODE="$1"

if [ "$APPEARANCE_MODE" = "dark" ]; then
  KITTY_THEME="Catppuccin-Mocha"
  TMUX_BG="color236"
fi

if [ "$APPEARANCE_MODE" = "light" ]; then
  KITTY_THEME="Catppuccin-Latte"
  TMUX_BG="color253"
fi

if [ -n "$KITTY_THEME" ]; then
  kitty +kitten themes --reload-in=all "$KITTY_THEME"
fi

if [ -n "$TMUX_BG" ]; then
  # Fails if tmux isn't running, that's OK
  tmux set -g window-style "bg=$TMUX_BG" || true
fi

LAZYGIT_CONFIG=~/.config/lazygit/config.yml
yq eval ".git.paging.pager = \"delta --paging=never --$APPEARANCE_MODE -s\"" "$LAZYGIT_CONFIG" > "${LAZYGIT_CONFIG}.tmp" && mv "${LAZYGIT_CONFIG}.tmp" "$LAZYGIT_CONFIG"
