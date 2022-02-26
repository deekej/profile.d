# vim: filetype=bash

# Do nothing if we were not called from Bash:
[[ "${SHELL}" != *bash ]] && return

# Don't do anything if we were already sourced:
[ -n "${BASH_DEFCONF_SOURCED}" ] && return

BASH_DEFCONF_SOURCED='true'

# -----------------------------------------------------------------------------

# Check the window size after each command and,
# update the values of LINES and COLUMNS if necessary:
shopt -s checkwinsize

# Append to the history file, don't overwrite it
# (i.e. enable on parrallel history):
shopt -s histappend
history -a

# Set the custom Bash prompt:
# NOTE: We get the *PS1_COLOR sourced automatically from bash-default-prompt.sh via profile script.
if [ ${EUID} -eq 0 ]; then
  PS1=${ROOT_PS1_COLOR:-'\[\033[01;31m\]\h\[\033[01;34m\] \w \$\[\033[00m\] '}
else
  PS1=${USER_PS1_COLOR:-'\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '}
fi

unset ROOT_PS1_COLOR USER_PS1_COLOR
