KEEPER[actdir]="${KEEPER[incdir]}/action/${OPTS[action]}"

# source action hooks
while read -r f; do
  [[ -z "${f}" ]] && continue
  [[ -f "${KEEPER[actdir]}/${f}.sh" ]] && . "${KEEPER[actdir]}/${f}.sh"
done <<< "
  init
  lib
  opts
  opts.after
  run.before
"

msgbag_is_empty ERRBAG || {
  echo
  msgbag2list ERRBAG >&2
  echo
  echo "Issue \`${KEEPER[tool]} -h\` for help"
  exit 1
}

. "${KEEPER[actdir]}/run.sh"

msgbag_is_empty ERRBAG || {
  echo
  msgbag2list ERRBAG >&2
}
