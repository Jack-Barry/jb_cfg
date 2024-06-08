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
else
	echo "✅ Kitty terminal emulator already installed"
fi
