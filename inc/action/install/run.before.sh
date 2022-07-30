OPTS+=(
  [vendor_dir]="${DEFAULTS[vendor_dir]}"
  [conffile_dir]=
  [tool]=
  [lib]=
)

#
# Blocking validations
#

msgbag_is_empty ERRBAG && {
  __detect_conffile_dir() {
    unset __detect_conffile_dir
    log_stage "Detecting CONFFILE directory"

    OPTS[conffile_dir]="$(dirname -- "${OPTS[conffile]}")"
  } && __detect_conffile_dir

  declare VALID_CONFFILE_LINES

  __validate_conffile_format() {
    unset __validate_conffile_format
    log_stage "Validating CONFFILE format"

    # TODO fix validation

    # local valid_lines_rexes="$(txt_rmblank <<< '
    #   vendor\.dir=.+
    #   (tool|lib)\.[^@=]+(@[^=]*)?=.+
    # ' | txt_trim)"
    # local conffile_content="$(
    #   conffile_strip "${OPTS[conffile]}"
    # )"

    # VALID_CONFFILE_LINES="$(grep -Ex -f <(echo "${valid_lines_rexes}") \
    #   <<< "${conffile_content}")"

    # while read -r inval; do
    #   [[ -n "${inval}" ]] || continue
    #   ERRBAG+=("Invalid CONFFILE line: ${inval}")
    # done <<< "$(
    #   grep -vFxf  <(printf -- '%s' "${VALID_CONFFILE_LINES}") \
    #     <<< "${conffile_content}"
    # )"
  } && __validate_conffile_format

  __parse_conffile() {
    unset __parse_conffile
    log_stage "Parsing CONFFILE"

    declare -A predef_map=(
      [vendor.dir]=vendor_dir
    )

    local key
    local val
    local vendor_type
    while read -r l; do
      [[ -n "${l}" ]] || continue

      key="${l%%=*}"
      val="${l#*=}"

      # some system required conf
      [[ -n "${predef_map[$key]}" ]] && {
        OPTS["${predef_map[$key]}"]="${val}"
        continue
      }

      # some vendor
      vendor_type="${key%%.*}"
      key="${key#*.}"

      # set version to default value if not pointed
      [[ "${key}" != *"@"* ]] && {
        key+="@"
      }
      [[ "${key: -1}" == "@" ]] && {
        key+="${DEFAULTS[vendor_version]}"
      }

      OPTS[$vendor_type]+="${OPTS[$vendor_type]:+$'\n'}${key}=${val}"
    done <<< "${VALID_CONFFILE_LINES}"

    OPTS[vendor_dir]="$(
      realpath -m -- "${OPTS[conffile_dir]}/${OPTS[vendor_dir]}"
    )"
  } && __parse_conffile

  unset VALID_CONFFILE_LINES
}
