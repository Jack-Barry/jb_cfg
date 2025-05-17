# compinit is used for completions
autoload -U compinit
compinit

# Homebrew shell completion
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# fnm (Node)
eval "$(fnm env --use-on-cd --version-file-strategy=recursive --resolve-engines)"

# rbenv (Ruby)
eval "$(rbenv init - zsh)"
FPATH=~/.rbenv/completions:"$FPATH"

# Distant tooling lives here
export PATH="/Users/jb/.local/bin:$PATH"

# 1Password shell completion
eval "$(op completion zsh)"; compdef _op op

export ZSH="$HOME/.oh-my-zsh"
plugins=(git rust)
source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"

### Begin Preferences
########################################
# Custom lazygit config location
export XDG_CONFIG_HOME="$HOME/.config"

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

### TMUX Begin
# Tmux sessions
function mux() {
    local session_name="$1"
    if [ -z "$session_name" ]; then
      session_name="stuff"
    fi
    tmux new-session -A -s "$session_name"
}

# Autocompletion based on currently open sessions
_mux() {
    local -a sessions
    sessions=($(tmux list-sessions -F "#{session_name}" 2>/dev/null))
    compadd -a sessions
}
compdef _mux mux
### TMUX End

# Go to Obsidian Default vault dir
alias cdnotes='cd ~/Nextcloud/Notes/Obsidian/General'

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
########################################
### End Aliases
########################################

