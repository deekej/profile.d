# vim: filetype=bash

# --------------------------------- #

TERMINAL="$(ps --pid ${PPID} --no-headers --format comm)"

# If the $TERMINAL is 'sudo', then it means we have been started via 'sudo -s'
# or 'sudo -i', and we need to dig deeper...
if [[ "${TERMINAL}" == 'sudo' ]]; then
  PSTREE_OUTPUT="$(pstree -ps ${PPID})"

  case "${PSTREE_OUTPUT}" in
    *gnome-terminal*)
      TERMINAL='gnome-terminal'
      ;;

    *terminator*)
      TERMINAL='terminator'
      ;;

    *tilix*)
      TERMINAL='tilix'
      ;;

    *xterm*)
      TERMINAL='xterm'
      ;;

    *)
      TERMINAL='unknown'
      ;;
  esac

  unset PSTREE_OUTPUT
fi

# Display the fortune-cookie if the system is able to, we are
# not running as root and we are not in Tilix (Quake) Terminal:
if [[ -x /usr/bin/fortune-cookie && ${EUID} -ne 0 && "${TERMINAL}" != 'tilix' && "${TERMINAL}" != 'terminator' ]]; then
  tput reset
  /usr/bin/fortune-cookie
fi
