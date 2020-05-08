# vim: filetype=bash

# -------------------------------------
# Custom aliases for both ZSH and Bash:
# -------------------------------------

# Usability section:
# ------------------
alias dd='dd status=progress'
alias df='df -h'
alias du='du -h'
alias la='ls -lhvAF --color=auto'
alias ll='ls -ohvAF --color=auto --group-directories-first'
alias lr='ls -ohvAF --color=auto --group-directories-first --reverse'
alias rm='rm -I'

alias ngrep='grep -n --color=auto'
alias xclip='xclip -sel clip'
alias xopen='xdg-open'

# Network section:
# ----------------
alias tracert='traceroute'
alias ipconfig='ifconfig'
alias whatsmyip='dig +short myip.opendns.com @resolver1.opendns.com'

# Workflow section:
# -----------------
alias make='make -j'

# -----------------------------------------------------------------------------

if [[ "$(uname -n)" == Normandy-SR5* ]]; then
  # Set logout only if GUI is running:
  if [[ "$TERM" = "xterm" || "$TERM" = "xterm-256color" ]]; then
    alias logout='gnome-session-quit --logout --no-prompt && exit'
  fi

  # Custom hooks section:
  # ---------------------
  alias     ping='/usr/libexec/ping.hook'
  alias    patch='/usr/libexec/patch.hook'
  #alias     sudo='/usr/libexec/sudo.hook'

  # Security section:
  # -----------------
  alias su='su -'
  alias pwgen='pwgen -scnyB'
  alias PINgen="hexdump -n 2 -e '1/1 \"%03u\"' /dev/urandom; echo \"\""

  # Network section:
  # ----------------
  alias speedtest='speedtest-cli'
  alias wget='curl -L --remote-header-name --remote-name'

  #alias -- ssh-nostrict='ssh -o StrictHostKeyChecking=no'
  #alias -- scp-nostrict='scp -o StrictHostKeyChecking=no'

  # Performance & battery-life section:
  # -----------------------------------
  alias powertop='sudo powertop'

  # Usability section:
  # ------------------
  if command -v colordiff &> /dev/null; then
    alias diff='colordiff -uprN'
  else
    alias diff='diff -uprN'
  fi

  alias ctags='rm -f .ctags && ctags -R -f .ctags'
  alias info='pinfo'
  alias gdb='cgdb'

  alias xwayland='export QT_QPA_PLATFORM=xcb'

  alias -- laptop-font='setfont ter-m32b'
  alias -- display-font='setfont ter-m16v'

  # Other section:
  # --------------
  alias weather='curl wttr.in'
  alias -- youtube-mp3='youtube-dl --extract-audio --audio-format mp3 --audio-quality 320K --write-thumbnail'

  # ---------------------------------------------------------------------------

  # Font testing:
  # -------------
  alias pango='DISPLAY=:0 FC_DEBUG=4 pango-view --font=monospace -t ☺ | grep family:'

  # Package maintaining section:
  # ----------------------------
  alias mock='mock --no-clean'
  alias bumpspec='rpmdev-bumpspec *.spec'

  alias -- rpm-extract='rpmdev-extract'

  function whatprovides()
  {
    local eval $(cat /etc/*-release | grep VERSION_ID)

    rpm -qf "$(which --skip-alias ${1} 2>/dev/null)" 2>/dev/null || \
      dnf repoquery --assumeno --disablerepo='fedora-cisco-openh264' -C --whatprovides "$1" 2>/dev/null | \
      grep "\.$VERSION_ID" || \
      echo "Nothing provides: ${1}"
  }
fi
