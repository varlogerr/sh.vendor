print_help() {
  _print "
    USAGE
    =====
    \`\`\`sh
    # generate conffile to stdout
    ${KEEPER[tool]} --genconf
   !
    # initialize a directory as a vendor
    # directory
    # DIRECTORY is optional, defaults to \$(pwd)
    ${KEEPER[tool]} --init [DIRECTORY]
   !
    # install depdendencies from CONFFILE
    # \`--\` is end of options, i.e. for
    #   cases when CONFFILE name is for
    #   example \`-h\`
    # CONFFILE - path to vendor conffile.
    #   optional, defaults to \$(pwd)/$(basename -- "${DEFAULTS[conffile]}")
    ${KEEPER[tool]} [--] [CONFFILE]
    \`\`\`
  "
}

_print() {
  local lines="${1}"
  local line_symbol="${2:-!}"

  while read -r line; do
    [[ -z "${line}" ]] && continue

    [[ "${line:0:1}" == "${line_symbol}" ]] \
      && line="${line:1}"

    printf -- '%s\n' "${line}"
  done <<< "${lines}"
}
