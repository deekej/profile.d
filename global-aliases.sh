# vim: filetype=bash

# Do nothing if we were not called from Bash or ZSH:
[[ "${SHELL}" != *zsh && "${SHELL}" != *bash ]] && return

# Do not source us until oh-my-zsh finished - we will be sourced later:
[[ "${SHELL}" == *zsh && -z "${ZDOTDIR}" ]] && return

# Don't do anything if we were already sourced:
[ -n "${GLOBAL_ALIASES_SOURCED}" ] && return

GLOBAL_ALIASES_SOURCED='true'

# --------------------------------------
# Custom aliases specific for Bash only:
# --------------------------------------
if [[ "${SHELL}" == *bash ]]; then
  # NOTE: Oh-my-zsh has its own check when removing multiple files.
  alias rm='rm -I'
fi

# -------------------------------------
# Custom aliases for both ZSH and Bash:
# -------------------------------------

# Usability section:
# ------------------
alias cp='cp -v'
alias dd='dd conv=fsync status=progress'

alias df='df -h'
alias du='du -h'

alias dul='du -d 1 -h'
alias duc='du -sh'

alias  dir='vdir --color=auto'
alias vdir='vdir --color=auto'

alias ls='ls -v -CF --color=auto'
alias la='ls -lhvAF --color=auto'
alias li='ls -ohvAF --color=auto --group-directories-first --reverse'
alias ll='ls -ohvAF --color=auto --group-directories-first'
alias lt='ls -ltFh  --reverse'

alias ll.='ls -ohvAF --color=auto --group-directories-first --directory .*'
alias lls='ls -1FSsh --reverse'
alias llsr='ls -1FSsh --reverse --recursive'

alias tree='tree -a'

alias less='less -R'
alias info='pinfo'

alias  grep='grep  --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias fgrep='fgrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias egrep='egrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias ngrep='grep -n --color=auto'

alias xclip='xclip -sel clip'

if command -v colordiff &> /dev/null; then
  alias diff='colordiff -uprN'
else
  alias diff='diff -uprN'
fi

# Network section:
# ----------------
alias ssh-pass='ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no -o GSSAPIAuthentication=no'
alias scp-pass='scp -o PreferredAuthentications=password -o PubkeyAuthentication=no -o GSSAPIAuthentication=no'

# Custom functions:
# -----------------
function cdl()
{
  cd "$1" && ll
}

# -----------------------------------------------------------------------------

case "$(uname -n)" in
  Normandy-SR*)
    # Set logout only if GUI is running:
    if [[ "$TERM" = "xterm" || "$TERM" = "xterm-256color" ]]; then
      alias logout='gnome-session-quit --logout --no-prompt && exit'
    fi

    alias xopen='xdg-open'
    alias xwayland='export QT_QPA_PLATFORM=xcb; echo "export QT_QPA_PLATFORM=xcb"'

    alias powertop='sudo powertop'

    #alias -- laptop-font='setfont ter-m20b'
    #alias -- display-font='setfont ter-m16v'

    # Network section:
    # ----------------
    alias speedtest='speedtest-cli'
    alias wifiscan='nmcli -f ALL dev wifi'
    alias tracert='traceroute'
    alias ipconfig='ifconfig'
    alias whatsmyip='dig +short myip.opendns.com @resolver1.opendns.com'

    #alias -- ssh-nostrict='ssh -o StrictHostKeyChecking=no'
    #alias -- scp-nostrict='scp -o StrictHostKeyChecking=no'

    # Other:
    # ------
    alias weather='curl wttr.in'
    alias -- youtube-mp3='youtube-dl --extract-audio --audio-format mp3 --audio-quality 320K --write-thumbnail'

    # TaskWarrior:
    # ------------
    alias ta='task add'
    alias tl='task list'
    alias td='task done'
    alias tan='task annotate'
    alias tsc='task context'

    alias taa='task add project:accomplish'
    alias twa='task add project:work'
    alias tda='task add project:devel'
    alias tfa='task add project:fedora'
    alias tpa='task add project:personal'
    ;;

  toolbox)
    # Development / packaging:
    # ------------------------
    alias gdb='cgdb'
    alias make='make -j'
    alias mock='mock --no-clean'
    alias ctags='rm -f .ctags && ctags -R -f .ctags'
    alias bumpspec='rpmdev-bumpspec *.spec'
    alias -- rpm-extract='rpmdev-extract'

    # Font testing:
    # -------------
    alias pango='DISPLAY=:0 FC_DEBUG=4 pango-view --font=monospace -t ☺ | grep family:'

    function whatprovides()
    {
      local eval $(cat /etc/*-release | grep VERSION_ID)

      rpm_query=$(rpm -qf "$(which --skip-alias "${1}" 2>/dev/null)" 2>/dev/null)

      [[ -n "${rpm_query}" ]] && echo "${rpm_query}" && return

      dnf_query=$(dnf repoquery --assumeno --disablerepo='fedora-cisco-openh264' -C --whatprovides "${1}" 2>/dev/null | grep "fc${VERSION_ID}")

      [[ -n "${dnf_query}" ]] && echo "${dnf_query}" && return

      echo "Nothing provides: ${1}"
    }
    ;;
esac
