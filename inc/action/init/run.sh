mkdir -p "${OPTS[initdir]}"
cd "${OPTS[initdir]}"

CONFFILE="${OPTS[initdir]}/$(basename -- "${DEFAULTS[conffile]}")"

__create_conffile() {
  unset __create_conffile

  [[ -f "${CONFFILE}" ]] && return

  conffile_content="$(
    sed -e 's/{vendor_version}/'"${DEFAULTS[vendor_version]}"'/g' \
      -e 's#{vendor_dir}#'"${OPTS[vendor_dir]}"'#g' \
      "${KEEPER[tooldir]}/tpl/vendor.conf"
  )"
  conffile_content+=$'\n'
  conffile_content+="tool.${OPTS[tool_prefix]}@${OPTS[tool_ver]}=${DEFAULTS[tool_url]}"

  echo "${conffile_content}" > "${CONFFILE}"
} && __create_conffile

__create_gitignore() {
  unset __create_gitignore

  local dest="${OPTS[vendor_dir]}/.gitignore"

  cp -- "${KEEPER[tooldir]}/tpl/gitignore" "${dest}" || {
    RC=$?
    ERRBAG+=("($RC) Can't create gitignore file: ${dest}")
  }
} && __create_gitignore
