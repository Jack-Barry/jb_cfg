#!/usr/bin/env bash
### Runs through all setup scripts
echo "Performing setup..."
(
    cd "$(dirname "$0")" || exit 1
    ./setup/terminal_emulator.sh
    ./setup/brew_install.sh
    ./setup/oh_my_zsh.sh
    ./setup/fnm.sh
)
echo "🎉 Setup complete!"
