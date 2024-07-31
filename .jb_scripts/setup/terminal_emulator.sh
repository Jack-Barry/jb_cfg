#!/usr/bin/env bash
############################################################
# Installs my terminal emulator of choice
# Useful docs for kitty
# Tabs     https://sw.kovidgoyal.net/kitty/overview/#tabs
# Windows https://sw.kovidgoyal.net/kitty/overview/#windows
#
# Useful commands
# > kitty +kittens themes
# 'cmd'+','         -> Edit config
# 'shift'+'cmd'+',' -> Reload config
############################################################
if [ ! -d "/Applications/kitty.app/" ]; then
  echo "Kitty not already installed, installing it..."
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
  echo "✅ Installed Kitty terminal emulator"

  # Set and use custom icon for kitty
  ICON_PATH="$HOME/.config/kitty/kitty-dark.icns"
  kitty +runpy 'from kitty.fast_data_types import cocoa_set_app_icon; import sys; cocoa_set_app_icon(*sys.argv[1:]); print("OK")' "$ICON_PATH" /Applications/kitty.app
  rm /var/folders/*/*/*/com.apple.dock.iconcache
  killall Dock
  echo "✅ Now using custom icon for Kitty"
else
  echo "✅ Kitty terminal emulator already installed"
fi
