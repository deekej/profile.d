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

  alias xwayland='export QT_QPA_PLATFORM=xcb; echo "export QT_QPA_PLATFORM=xcb"'

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

  # Custom launchers to workaround inconsistent desktop switching:
  alias  firefox-nightly='/usr/libexec/launchers/firefox-nightly'
  alias          firefox='/usr/libexec/launchers/firefox'
  alias             gimp='/usr/libexec/launchers/gimp'
  alias             gvim='/usr/libexec/launchers/gvim'
  alias         gvimdiff='/usr/libexec/launchers/gvimdiff'
  alias          hexchat='/usr/libexec/launchers/hexchat'
  alias             nemo='/usr/libexec/launchers/nemo'
  alias        photogimp='/usr/libexec/launchers/photogimp'
  alias    skypeforlinux='/usr/libexec/launchers/skypeforlinux'
  alias            slack='/usr/libexec/launchers/slack'
  alias          spotify='/usr/libexec/launchers/spotify'
  alias telegram-desktop='/usr/libexec/launchers/telegram-desktop'
  alias       terminator='/usr/libexec/launchers/terminator'
  alias     virt-manager='/usr/libexec/launchers/vir-manager'
  alias              vlc='/usr/libexec/launchers/vlc'
fi
