# vim: filetype=bash

# Do nothing if we were not called from Bash or ZSH:
[[ "$SHELL" != *zsh && "$SHELL" != *bash ]] && return

# Do not source us until oh-my-zsh finished - we will be sourced later:
[[ "$SHELL" == *zsh && -z "$ZDOTDIR" ]] && return

# Don't do anything if we were already sourced:
[ -n "$DEFCONF_SOURCED" ] && return

DEFCONF_SOURCED='true'

# -----------------------------------------------------------------------------

# Specific configuration either for Bash, or ZSH:
if [[ "$SHELL" == *bash ]]; then
  # Check the window size after each command and,
  # update the values of LINES and COLUMNS if necessary:
  shopt -s checkwinsize

  # Append to the history file, don't overwrite it
  # (i.e. enable on parrallel history):
  shopt -s histappend
  history -a

  # --------------------------------- #

  # NOTE: We get the *PS1_COLOR sourced automatically from default-bash-prompt.sh via profile script.

  # Set the custom Bash prompt:
  if [ ${EUID} -eq 0 ]; then
    PS1=${ROOT_PS1_COLOR:-'\[\033[01;31m\]\h\[\033[01;34m\] \w \$\[\033[00m\] '}
  else
    PS1=${USER_PS1_COLOR:-'\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '}
  fi

  unset ROOT_PS1_COLOR USER_PS1_COLOR
else
  # Specific configuration for ZSH:
  true
fi

# -----------------------------------------------------------------------------
#  Shared configuration between Bash and ZSH:
# -----------------------------------------------------------------------------

# Load up custom colors config:
if [ -f ~/.dir_colors ] ; then
  eval $(dircolors -b ~/.dir_colors)
elif [ -f /etc/DIR_COLORS ] ; then
  eval $(dircolors -b /etc/DIR_COLORS)
else
  eval $(dircolors)
fi

# Fix for not properly visible colors of GREP:
export GREP_COLORS='fn=01;35:ln=01;32'

# Color pallete for GCC warnings/settings (since GCC 4.9.0+):
export GCC_COLORS='error=01;31:warning=01;33:note=01;32:caret=01;32:locus=01;34:quote=01;35'

# --------------------------------- #

# Enable colors for common commands:
alias     ls='ls   --color=auto -v -CF'
alias    dir='vdir --color=auto'
alias   vdir='vdir --color=auto'

alias   grep='grep  --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias  fgrep='fgrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias  egrep='egrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'

alias   less='less -R'

if command -v colordiff &> /dev/null; then
  alias diff='colordiff -uprN'
else
  alias diff='diff -uprN'
fi

# --------------------------------- #

# Global alias definitions:
alias dd='dd status=progress'
alias df='df -h'
alias du='du -h'
alias la='ls -lhvAF --color=auto'
alias ll='ls -ohvAF --color=auto --group-directories-first'
alias lr='ls -ohvAF --color=auto --group-directories-first --reverse'
alias rm='rm -i'

# --------------------------------- #

# Set normal (sane) umask:
umask 022

# --------------------------------- #

# Display the fortune-cookie if the system is able to:
if [ -x /usr/bin/fortune-cookie ]; then
  tput reset
  /usr/bin/fortune-cookie
fi
