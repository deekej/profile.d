# vim: filetype=bash

# --------------------------------------
# Custom aliases specific for Bash only:
# --------------------------------------
if [[ "$SHELL" == *bash ]]; then
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

alias la='ls -lhvAF --color=auto'
alias li='ls -ohvAF --color=auto --group-directories-first --reverse'
alias ll='ls -ohvAF --color=auto --group-directories-first'
alias lt='ls -ltFh  --reverse'

alias ll.='ls -ohvAF --color=auto --group-directories-first --directory .*'
alias lls='ls -1FSsh --reverse'

alias llsr='ls -1FSsh --reverse --recursive'

alias tree='tree -a'

alias ngrep='grep -n --color=auto'
alias xclip='xclip -sel clip'
alias xopen='xdg-open'

# Network section:
# ----------------
alias ssh-pass='ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no -o GSSAPIAuthentication=no'
alias scp-pass='scp -o PreferredAuthentications=password -o PubkeyAuthentication=no -o GSSAPIAuthentication=no'
alias tracert='traceroute'
alias ipconfig='ifconfig'
alias whatsmyip='dig +short myip.opendns.com @resolver1.opendns.com'
alias wifiscan='nmcli -f ALL dev wifi'

# Workflow section:
# -----------------
alias make='make -j'

# Custom functions:
# -----------------

function cdl()
{
  cd "$1" && ll
}

# -----------------------------------------------------------------------------

if [[ "$(uname -n)" == Normandy-SR* ]]; then
  # Set logout only if GUI is running:
  if [[ "$TERM" = "xterm" || "$TERM" = "xterm-256color" ]]; then
    alias logout='gnome-session-quit --logout --no-prompt && exit'
  fi

  # Custom hooks section:
  # ---------------------
  alias     ping='/usr/libexec/ping.hook'

  # Security section:
  # -----------------
  alias su='su -'
  alias pwgen='pwgen -scnyB'
  alias PINgen="hexdump -n 2 -e '1/1 \"%03u\"' /dev/urandom; echo \"\""

  # Network section:
  # ----------------
  alias speedtest='speedtest-cli'

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

  alias xwayland='export QT_QPA_PLATFORM=xcb; echo "export QT_QPA_PLATFORM=xcb"'

  alias -- laptop-font='setfont ter-m20b'
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
