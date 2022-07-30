OPTS+=(
  [initdir]="$(pwd)"
)

__opts_detect() {
  unset __opts_detect

  declare -a initdirs=()

  while :; do
    [[ -z "${1+x}" ]] && break

    case "${1}" in
      * ) initdirs+=("$1") ;;
    esac

    shift
  done

  OPTS[initdir]="${initdirs[0]:-${OPTS[initdir]}}"

  [[ ${#initdirs[@]} -gt 1 ]] && {
    msgbag_add ERRBAG "Only 1 argument is expected"
  }
} && __opts_detect "${@}"
