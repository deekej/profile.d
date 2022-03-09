# vim: filetype=bash

# Do nothing if we were not called from Bash or ZSH:
[[ "${SHELL}" != *zsh && "${SHELL}" != *bash ]] && return

# Do not source us until oh-my-zsh finished - we will be sourced later:
[[ "${SHELL}" == *zsh && -z "${ZDOTDIR}" ]] && return

# Don't do anything if we were already sourced:
[ -n "${GLOBAL_FUNCTIONS_SOURCED}" ] && return

GLOBAL_FUNCTIONS_SOURCED='true'

# ---| Custom functions |------------------------------------------------------

# Change to directory & display its content immediately:
function cdl()
{
  cd "${1}" && ll
}

# Initialize empty Ansible file:
function ansible_file_init()
{
  [[ -s "${1}" ]] && return

  echo '---' >> "${1}"
  echo '# vim: filetype=yaml.ansible' >> "${1}"
}

# Initialize default directory layout for Ansible project:
function ansible_layout_init()
{
  mkdir -p collections
  mkdir -p filter_plugins
  mkdir -p group_vars
  mkdir -p host_vars
  mkdir -p library
  mkdir -p roles
  mkdir -p module_utils
  mkdir -p vault

  touch .gitignore

  touch LICENSE
  touch README.md

  touch hosts
  touch ansible.cfg

  # NOTE: Use this after upgrading to version 2.12 (core):
  #ansible-config init --disabled > ansible.cfg

  ansible_file_init requirements.yml
  ansible_file_init group_vars/all.yml
}

function whatprovides()
{
  [[ -z "${1}" ]] && return

  local eval $(cat /etc/*-release | grep VERSION_ID)
  rpm_query="$(rpm -qf "$(which --skip-alias "${1}" 2>/dev/null)" 2>/dev/null)"

  if [[ -n "${rpm_query}" ]]; then
    echo "${rpm_query}"
    return
  fi

  dnf_query="$(toolbox run dnf repoquery --assumeno --disablerepo='fedora-cisco-openh264' --whatprovides "${1}" 2>/dev/null | grep -m 1 "fc${VERSION_ID}")"

  if [[ -n "${dnf_query}" ]]; then
    echo "${dnf_query}"
    return
  fi

  echo "Nothing provides: ${1}"
}
