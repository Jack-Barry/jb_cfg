#!/usr/bin/env bash
##############################################
# Installs must-have packages for my workflows
##############################################
echo "📦 Installing Homebrew and favorite packages"

if [[ ! -d "/usr/local/Homebrew" && ! -d "/opt/homebrew" ]]; then
  echo "Homebrew not already installed, installing it..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "✅ Homebrew installed"
else
  echo "Homebrew already installed, updating..."
  brew update
  echo "✅ Homebrew is ready for package management"
fi

# Yes I know I could declare the PACKAGE_LIST all in one go, but I wanted inline
# comments to remember what each of these packages is for
PACKAGE_LIST=()
PACKAGE_LIST+=("1password-cli")                 # 1Password
PACKAGE_LIST+=("fd")                            # Neovim: Neotree
PACKAGE_LIST+=("fnm")                           # Fast Node Manager
PACKAGE_LIST+=("font-jetbrains-mono-nerd-font") # Favorite font
PACKAGE_LIST+=("gh")                            # GitHub CLI
PACKAGE_LIST+=("git-delta")                     # diff viewer (side by side)
PACKAGE_LIST+=("hurl")                          # CLI for API testing
PACKAGE_LIST+=("jq")                            # JSON processor
PACKAGE_LIST+=("lazygit")                       # Git CLI
PACKAGE_LIST+=("neovim")                        # IDE
PACKAGE_LIST+=("powerlevel10k")                 # Terminal theming
PACKAGE_LIST+=("rbenv")                         # Ruby version management
PACKAGE_LIST+=("ripgrep")                       # Neovim: Telescope
PACKAGE_LIST+=("ruby-build")                    # Used with rbenv
PACKAGE_LIST+=("stats")                         # System stats in menu bar
PACKAGE_LIST+=("tmux")                          # Terminal multiplexer
PACKAGE_LIST+=("tree")                          # Pretty printout of dir structures

PACKAGES_TO_INSTALL=()
PACKAGES_TO_UPDATE=()

for pkg in "${PACKAGE_LIST[@]}"; do
  if [[ -n "${pkg// /}" ]]; then
    if [[ ! -d "/usr/local/Caskroom/$pkg" && ! -d "/usr/local/Cellar/$pkg" ]]; then
      PACKAGES_TO_INSTALL+=("$pkg")
    else
      PACKAGES_TO_UPDATE+=("$pkg")
    fi
  fi
done

if [ ${#PACKAGES_TO_INSTALL[@]} == 0 ]; then
  echo "✅ All expected packages already installed"
else
  brew install "${PACKAGES_TO_INSTALL[@]}"
fi

if [ ${#PACKAGES_TO_UPDATE[@]} != 0 ]; then
  echo "Updating packages to latest..."
  brew upgrade
fi

echo "🚀 Homebrew packages installation complete"
