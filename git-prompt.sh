#!/usr/bin/env bash
# Necessary functions used by /usr/bin/cd builtin for customized git prompt.
# These functions were extracted from: https://github.com/rtomayko/git-sh

# This is intended for bash only...
[[ "$SHELL" != *bash ]] && return

ANSI_RESET="\001$(\git config --get-color "" "reset" 2>/dev/null)\002"

# determine whether color should be enabled. this checks git's color.ui
# option and then color.sh.
_git_color_enabled() {
  [ "$(\git config --get-colorbool color.sh true 2>/dev/null)" = "true" ]
}

# retrieve an ANSI color escape sequence from git config
_git_color() {
  local color
  color=$(\git config --get-color "$1" "$2" 2>/dev/null)
  [ -n "$color" ] && echo -ne "\001$color\002"
}

# apply a color to the first argument
_git_apply_color() {
  local output="$1" color="$2" default="$3"
  if _git_color_enabled ; then
    color=$(_git_color "$color" "$default")
    echo -ne "${color}${output}${ANSI_RESET}"
  else
    echo -ne "$output"
  fi
}

# ------------------------------------------------------------------------------

# detect working directory relative to working tree root
_git_workdir() {
  subdir=$(\git rev-parse --show-prefix 2>/dev/null)
  subdir="${subdir%/}"
  workdir="${PWD%/$subdir}"
  _git_apply_color "${workdir/*\/}${subdir:+/$subdir}" "color.sh.workdir" "blue bold"
}

# detect the deviation from the upstream branch
_git_upstream_state() {
  local p=""

  # Find how many commits we are ahead/behind our upstream
  local count="$(\git rev-list --count --left-right "@{upstream}"...HEAD 2>/dev/null)"

  # calculate the result
  case "$count" in
    "") # no upstream
      p="~" ;;
    "0	0") # equal to upstream
      p="u=" ;;
    "0	"*) # ahead of upstream
      p="u+${count#0	}" ;;
    *"	0") # behind upstream
      p="u-${count%	0}" ;;
    *) # diverged from upstream
      p="u+${count#*	}-${count%	*}" ;;
  esac

  _git_apply_color "$p" "color.sh.upstream-state" "yellow bold"
}

# detect the current branch; use 7-sha when not on branch
_git_headname() {
  local br=$(\git symbolic-ref -q HEAD 2>/dev/null)
  [ -n "$br" ] &&
    br=${br#refs/heads/} ||
    br=$(\git rev-parse --short HEAD 2>/dev/null)
  _git_apply_color "$br" "color.sh.branch" "yellow reverse"
}

# detect if the repository is in a special state (rebase or merge)
_git_repo_state() {
  local git_dir="$(\git rev-parse --show-cdup 2>/dev/null).git"
  if test -d "$git_dir/rebase-merge" -o -d "$git_dir/rebase-apply"; then
    local state_marker="(rebase)"
  elif test -f "$git_dir/MERGE_HEAD"; then
    local state_marker="(merge)"
    elif test -f "$git_dir/CHERRY_PICK_HEAD"; then
        local state_marker="(cherry-pick)"
  else
    return 0
  fi
  _git_apply_color "$state_marker" "color.sh.repo-state" "red"
}

# detect whether the tree is in a dirty state.
_git_dirty() {
  if ! \git rev-parse --verify HEAD >/dev/null 2>&1; then
    return 0
  fi
  local dirty_marker="$(\git config gitsh.dirty 2>/dev/null || echo ' *')"

  if ! \git diff --quiet 2>/dev/null ; then
    _git_apply_color "$dirty_marker" "color.sh.dirty" "red"
  elif ! \git diff --staged --quiet 2>/dev/null ; then
    _git_apply_color "$dirty_marker" "color.sh.dirty-staged" "yellow"
  else
    return 0
  fi
}

# detect whether any changesets are stashed
_git_dirty_stash() {
  if ! \git rev-parse --verify refs/stash >/dev/null 2>&1; then
    return 0
  fi
  local dirty_stash_marker="$(\git config gitsh.dirty-stash 2>/dev/null || echo ' $')"
  _git_apply_color "$dirty_stash_marker" "color.sh.dirty-stash" "red"
}

# ------------------------------------------------------------------------------

_git_repo() {
  # We might not be in git repository, but user still might want us to use the
  # git prompt... Check if current path of working directory is in config file.
  if [[ -f "$HOME/.config/git/promptrc" ]]; then
    while read line; do
      pwd -P | grep "$line" &>/dev/null

      # Existing baseline?
      if [[ $? -eq 0 && "$line" != "" ]]; then
        BASELINE="$(basename "$line")"
        return  0     # Success (user override) ->> use git prompt
      fi
    done < "$HOME/.config/git/promptrc"
  fi

  # Are we in folder with accessible git repository?
  #if [[ -d .git/ && -O .git/ ]]; then
  if git rev-parse --is-inside-work-tree &> /dev/null; then
    return 0          # Yes, we are ->> use git prompt
  else
    return 1          # Not in git repository && no user override
  fi
}

_git_update_prompt() {
  BASELINE="${BASELINE:-$(dirname "$PWD")}"
  PS1='[\[\033[01;31m\]$BASELINE\[\033[00m\]||$(_git_workdir)] $(_git_upstream_state) [$(_git_headname)$(_git_repo_state)$(_git_dirty)$(_git_dirty_stash)]\n\[\033[01;32m\] >>\[\033[00m\] '
}

_git_reset_prompt() {
  if [ -z "$BASELINE" ]; then
    return            # Nothing to do - PS1 is not displaying git_prompt
  fi

  # Get the preferred PS1 settings, if they exists:
  [ -f /etc/sysconfig/bash-default-prompt ] && source /etc/sysconfig/bash-default-prompt

  # Dir colors already enabled & evaluated, just set the correct PS1:
  if [ ${EUID} == 0 ]; then
    PS1=${ROOT_PS1_COLOR:-'\[\033[01;31m\]\h\[\033[01;34m\] \w \$\[\033[00m\] '}
  else
    PS1=${USER_PS1_COLOR:-'\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '}
  fi

  unset BASELINE ROOT_PS1_COLOR USER_PS1_COLOR
}

# --------------------------------- #

# Allow to change PS1 when we enter the directory with .git/ subfolder
# (see e.g. /usr/bin/cd) and update the PS1 if we already start there:
alias cd='. /usr/bin/cd'
alias pushd='. /usr/bin/pushd'
alias popd='. /usr/bin/popd'

cd .

# --------------------------------- #
