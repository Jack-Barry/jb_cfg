# Project history for the Up and Down keys.
#
# Up:   step back through commands you ran in this project, newest first.
#       If you typed something first, only commands that start with it show.
# Down: step forward again. Past the newest match, your typed text comes back.
#
# A "project" is a git repository. The main checkout and all of its worktrees
# count as one project. Outside a git repository, the project is the
# current directory.
#
# Records go to ~/.zsh_project_history. The normal ~/.zsh_history file and
# Ctrl+R (fzf, all directories) do not change. The file starts empty, so Up
# shows nothing in a project until you run commands there.

typeset -g JB_PROJECT_HISTFILE="$HOME/.zsh_project_history"
typeset -g JB_PROJECT_HISTFILE_MAX_BYTES=$(( 4 * 1024 * 1024 ))
typeset -g _jb_project_key=""

# --- Project key ---------------------------------------------------------

# All worktrees of a repository share one "git common dir".
function _jb_project_key_update() {
  local common
  common=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
  if [[ -n $common ]]; then
    _jb_project_key="${common%/.git}"
  else
    _jb_project_key="$PWD"
  fi
}

# --- Recording -----------------------------------------------------------

# One record per command: <project key> 0x1F <command> 0x00.
# The NUL separator keeps multi-line commands intact.
function _jb_project_history_add() {
  local cmd="${1%$'\n'}"
  [[ -z $cmd || $cmd == ' '* ]] && return 0   # same rule as hist_ignore_space
  print -rn -- "${_jb_project_key}"$'\x1f'"${cmd}"$'\0' >> "$JB_PROJECT_HISTFILE"
  return 0   # 0 = zsh also saves the command to the normal history
}

# Keeps the newest half of the file when it grows past the size limit.
function _jb_project_history_trim() {
  [[ -f $JB_PROJECT_HISTFILE ]] || return 0
  zmodload -F zsh/stat b:zstat
  local -a size
  zstat -A size +size -- "$JB_PROJECT_HISTFILE" 2>/dev/null || return 0
  (( size[1] > JB_PROJECT_HISTFILE_MAX_BYTES )) || return 0
  local -a records
  records=("${(@0)"$(<$JB_PROJECT_HISTFILE)"}")
  records=(${records:#})
  local keep=$(( ${#records} / 2 ))
  print -rn -- "${(pj:\0:)records[-keep,-1]}"$'\0' > "$JB_PROJECT_HISTFILE"
}

# --- Up and Down widgets -------------------------------------------------

typeset -ga _jb_ph_matches
typeset -g _jb_ph_index=0 _jb_ph_prefix="" _jb_ph_original=""

# Fills _jb_ph_matches: this project's commands that start with the prefix,
# newest first, no duplicates.
function _jb_ph_load() {
  _jb_ph_matches=()
  [[ -r $JB_PROJECT_HISTFILE ]] || return 0
  local -a records
  records=("${(@0)"$(<$JB_PROJECT_HISTFILE)"}")
  local -A seen
  local i rec cmd
  for (( i = ${#records}; i > 0; i-- )); do
    rec=${records[i]}
    [[ ${rec%%$'\x1f'*} == "$_jb_project_key" ]] || continue
    cmd=${rec#*$'\x1f'}
    [[ $cmd == "${_jb_ph_prefix}"* ]] || continue
    [[ -n ${seen[$cmd]} ]] && continue
    seen[$cmd]=1
    _jb_ph_matches+=("$cmd")
  done
}

function _jb_ph_in_sequence() {
  [[ $LASTWIDGET == _jb_ph_up || $LASTWIDGET == _jb_ph_down ]]
}

function _jb_ph_up() {
  if ! _jb_ph_in_sequence; then
    # In a multi-line command, Up moves the cursor up one line.
    if [[ $LBUFFER == *$'\n'* ]]; then
      zle .up-line
      return
    fi
    _jb_ph_original=$BUFFER
    _jb_ph_prefix=$LBUFFER
    _jb_ph_index=0
    _jb_ph_load
  fi
  if (( _jb_ph_index < ${#_jb_ph_matches} )); then
    (( _jb_ph_index++ ))
    BUFFER=${_jb_ph_matches[_jb_ph_index]}
    CURSOR=${#BUFFER}
  else
    zle -M "No older command in this project. Ctrl+R searches all history."
  fi
}

function _jb_ph_down() {
  if ! _jb_ph_in_sequence; then
    zle .down-line
    return
  fi
  if (( _jb_ph_index > 1 )); then
    (( _jb_ph_index-- ))
    BUFFER=${_jb_ph_matches[_jb_ph_index]}
  else
    _jb_ph_index=0
    BUFFER=$_jb_ph_original
  fi
  CURSOR=${#BUFFER}
}

# --- Setup ---------------------------------------------------------------

autoload -Uz add-zsh-hook
add-zsh-hook zshaddhistory _jb_project_history_add
add-zsh-hook chpwd _jb_project_key_update
_jb_project_key_update
_jb_project_history_trim

zle -N _jb_ph_up
zle -N _jb_ph_down
for keymap in emacs viins; do
  bindkey -M $keymap '^[[A' _jb_ph_up
  bindkey -M $keymap '^[OA' _jb_ph_up
  bindkey -M $keymap '^[[B' _jb_ph_down
  bindkey -M $keymap '^[OB' _jb_ph_down
done
unset keymap
