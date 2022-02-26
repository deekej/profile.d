# vim: filetype=bash

# -------------------------------------------------------------
# Global environment configuration common for both Bash && ZSH:
# -------------------------------------------------------------

# Do nothing if we were not called from Bash or ZSH:
[[ "${SHELL}" != *zsh && "${SHELL}" != *bash ]] && return

# Do not source us until oh-my-zsh finished - we will be sourced later:
[[ "${SHELL}" == *zsh && -z "${ZDOTDIR}" ]] && return

# Don't do anything if we were already sourced:
[ -n "${GLOBAL_ENV_SOURCED}" ] && return

GLOBAL_ENV_SOURCED='true'

# We don't want the cowsay to be encapsulating the Ansible playbooks... Anywhere!
export ANSIBLE_NOCOWS=1

case "$(uname -n)" in
  Normandy-SR*)
    # Preferred editor for local and remote sessions
    if [[ -n "${SSH_CONNECTION}" ]]; then
      export EDITOR='vim -f'
    else
      export EDITOR='gvim -f'
    fi

    if [[ "${USER}" == deekej ]]; then
      # Enabling SSH access with GPG keys:
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      gpgconf --launch gpg-agent
    fi

    # Default editor for systemd units:
    export SYSTEMD_EDITOR="/usr/bin/vim"

    # Go workspace:
    export GOPATH="${HOME}/build/go"

    # Don't save history of searches in 'less':
    export LESSHISTFILE="/dev/null"

    # We want this to be enabled only on local laptop:
    #export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}/usr/local/lib"

    # Desktop is using nVidia GPU - make sure that everything (that can) is
    # being rendered on it (and not via software rendering)...
    if [[ "$(uname -n)" == Normandy-SR3* ]]; then
      export DRI_PRIME=1
    fi
    ;;

  toolbox)
    ;;

  *)
    # Source 'kubectl' completion on k8s server:
    if command -v kubectl &> /dev/null; then
      if [[ "${SHELL}" == *bash ]]; then
        source <(kubectl completion bash)
      else
        source <(kubectl completion zsh)
      fi
    fi

    # Additional aliases for servers:
    # alias foo='bar'
    ;;
esac

# -----------------------------------------------------------------------------

# Fix for not properly visible colors of GREP:
export GREP_COLORS='fn=01;35:ln=01;32'

# Color pallete for GCC warnings/settings (since GCC 4.9.0+):
export GCC_COLORS='error=01;31:warning=01;33:note=01;32:caret=01;32:locus=01;34:quote=01;35'

# Load up custom colors config:
if [ -r "${HOME}/.profile.d/DIR_COLORS" ]; then
  eval $(dircolors -b "${HOME}/.profile.d/dir_colors")
elif [ -r "${ZDOTDIR}/profile.d/DIR_COLORS" ]; then
  eval $(dircolors -b "${HOME}/.dir_colors")
elif [ -r /etc/DIR_COLORS ] ; then
  eval $(dircolors -b /etc/DIR_COLORS)
else
  eval $(dircolors)
fi

# Set normal (sane) umask:
umask 022

# -----------------------------------------------------------------------------

# Source the aliases after the default Oh-my-zsh aliases have been set,
# so we can override them if necessary:
if [ -r /etc/profile.d/global-aliases.sh ]; then
  source /etc/profile.d/global-aliases.sh
elif [ -r "${HOME}/.profile.d/global-aliases.sh" ]; then
  source -r "${HOME}/.profile.d/global-aliases.sh"
elif [ -r "${ZDOTDIR}/profile.d/global-aliases.sh" ]; then
  source "${ZDOTDIR}/profile.d/global-aliases.sh"
fi
