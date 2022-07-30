log_stage() {
  local msg="${1}"
  printf -- '[%s] >>> %s ...\n' \
    "${KEEPER[tool]}" "${msg}"
}

log_info() {
  local msg="${1}"
  printf -- '[%s] >>> %s\n' \
    "${KEEPER[tool]}" "${msg}"
}

conffile_strip() {
  local conffile="${1}"
  txt_trim "${conffile}" \
  | txt_rmblank | txt_rmcomment | sed 's/\s*=\s*/=/'
}

# RETVAL will contain vendor name
# after successful installation
install_vendor() {
  RETVAL=""

  local vendor="${1}"
  local fullname
  local name
  local ver
  local url
  local install_dir

  fullname="${vendor%%=*}"
  url="${vendor#*=}"
  name="${fullname%%@*}"
  ver="${fullname#*@}"
  install_dir="$(realpath "${OPTS[vendor_dir]}/${name}")"

  # security check if ${name} subdirectory will reside
  # inside vendor directory
  [[ "${install_dir}" == "${OPTS[vendor_dir]}"* ]] || return 1

  mkdir -p "${install_dir}" || {
    msgbag_add ERRBAG "Error creating vendor directory: ${install_dir}"
    return 1
  }

  cd "${install_dir}"
  git init -q
  git remote remove origin 2> /dev/null
  git remote add origin -f --tags "${url}" || {
    msgbag_add ERRBAG "Error adding origin: ${name}"
    return 1
  }
  # -p and -P for pruning non-existing remotely
  # references and tags
  git fetch -p -P -f || {
    msgbag_add ERRBAG "Error fetching: ${name}"
    return 1
  }
  git reset origin/master --hard
  # remove untracked files
  git clean -f -d -X
  git checkout -q "${ver}" || {
    msgbag_add ERRBAG "Error switching to version: ${name}@${ver}"
    return 1
  }

  RETVAL="${name}"
}
