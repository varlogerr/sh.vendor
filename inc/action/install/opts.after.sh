__check_conffile() {
  unset __check_conffile

  freadable "${OPTS[conffile]}" || {
    msgbag_add ERRBAG "CONFFILE must be a file: ${OPTS[conffile]}"
    return
  }
} && __check_conffile
