# vim: filetype=bash

# -------------------------------------------------------------
# Global environment configuration common for both Bash && ZSH:
# -------------------------------------------------------------

if [[ "$(uname -n)" != Normandy-SR* ]]; then
  # Source 'kubectl' completion on k8s server:
  if command -v kubectl &> /dev/null; then
    if [[ "$SHELL" == *bash ]]; then
      source <(kubectl completion bash)
    else
      source <(kubectl completion zsh)
    fi
  fi

  # Additional aliases for servers:
  # alias foo='bar'
else
  # Preferred editor for local and remote sessions
  if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim -f'
  else
    export EDITOR='gvim -f'
  fi

  if [[ "$USER" == deekej ]]; then
    # Enabling SSH access with GPG keys:
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    gpgconf --launch gpg-agent
  fi

  # Default editor for systemd units:
  export SYSTEMD_EDITOR="/usr/bin/vim"

  # Go workspace:
  export GOPATH="$HOME/build/go"

  # Personal settings of working environment:
  export GDB="cgdb"

  # Don't save history of searches in 'less':
  export LESSHISTFILE="/dev/null"

  # We want this to be enabled only on local laptop:
  #export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}/usr/local/lib"
fi

# Source the aliases after the default aliases have been set,
# so we can override them if necessary:
if [ -f /etc/profile.d/global-aliases.sh ]; then
  source /etc/profile.d/global-aliases.sh
elif [ -f ~/.profile.d/global-aliases.sh ]; then
  source ~/.profile.d/global-aliases.sh
fi
