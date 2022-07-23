__check_conffile() {
  unset __check_conffile

  [[ -f "${OPTS[conffile]}" ]] || {
    ERRBAG+=("CONFFILE must be a file: ${OPTS[conffile]}")
    return
  }

  OPTS[conffile]="$(realpath -- "${OPTS[conffile]}")"
} && __check_conffile
