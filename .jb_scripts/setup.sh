#!/usr/bin/env bash
### Runs through all setup scripts
echo "Performing setup..."
(
	cd $(dirname "$0")
	./setup/terminal_emulator.sh
	./setup/brew_install.sh
	./setup/nvm.sh
)
echo "🎉 Setup complete!"
