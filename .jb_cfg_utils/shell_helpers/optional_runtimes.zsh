# Makes rbenv (Ruby) and pyenv (Python) opt-in.
#
# They start by themselves when you cd into a directory tree that has a
# .ruby-version or .python-version file. In any other shell, run
# `enable_ruby` or `enable_python`. Until then, `ruby` and `python3` are
# the macOS system versions.

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

function enable_ruby() {
  [[ -n $_JB_RUBY_ON ]] && return 0
  _JB_RUBY_ON=1
  eval "$(rbenv init - zsh)"
  echo "rbenv enabled in this shell"
}

function enable_python() {
  [[ -n $_JB_PYTHON_ON ]] && return 0
  _JB_PYTHON_ON=1
  eval "$(pyenv init -)"
  echo "pyenv enabled in this shell"
}

# Returns 0 if the file $1 exists in the current directory or any parent.
function _jb_find_up() {
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    [[ -e "$dir/$1" ]] && return 0
    dir="${dir:h}"
  done
  return 1
}

function _jb_auto_runtimes() {
  [[ -z $_JB_RUBY_ON ]] && _jb_find_up .ruby-version && enable_ruby
  [[ -z $_JB_PYTHON_ON ]] && _jb_find_up .python-version && enable_python
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd _jb_auto_runtimes
_jb_auto_runtimes
