OPTS+=(
  [conffile]="${DEFAULTS[conffile]}"
)

__opts_detect() {
  unset __opts_detect

  declare -a pos_args=()

  [[ "${1}" == '--' ]] && shift

  while :; do
    [[ -z "${1+x}" ]] && break

    case "${1}" in
      * ) pos_args+=("${1}") ;;
    esac

    shift
  done

  OPTS[conffile]="${pos_args[0]:-${OPTS[conffile]}}"

  for arg in "${pos_args[@]:1}"; do
    msgbag_add ERRBAG "Invalid argument: ${arg}"
  done
} && __opts_detect "${@}"
