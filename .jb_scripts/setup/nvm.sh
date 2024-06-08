#!/usr/bin/env bash
##############################################
# Installs NVM
##############################################
if [! -d "$HOME/.nvm"]; then
	echo "📦 Installing NVM..."
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
	source ~/.zshrc
	nvm install --lts
else
	echo "✅ NVM is already installed"
fi
