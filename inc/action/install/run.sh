declare RC=0

__create_vendor_dir() {
  unset __create_vendor_dir
  log_stage "Creating vendor directory: ${OPTS[vendor_dir]}"

  mkdir -p -- "${OPTS[vendor_dir]}"/.{lib,bin} || {
    RC=$?
    ERRBAG+=("($RC) Error creating vendor directory: ${OPTS[vendor_dir]}/{.lib,,bin}")
  }
} && __create_vendor_dir

if [[ ${RC} -eq 0 ]]; then
  cd "${OPTS[vendor_dir]}" || {
    # fail if you're not in the vendor directory
    echo "Something went wrong!!!" >&2
    exit 1
  }
fi

[[ ${RC} -eq 0 ]] && \
__create_gitignore() {
  unset __create_gitignore
  log_stage "Creating gitignore file: ${dest}"

  local dest="${OPTS[vendor_dir]}/.gitignore"

  cp -- "${KEEPER[tooldir]}/tpl/gitignore" "${dest}" || {
    RC=$?
    ERRBAG+=("($RC) Can't create gitignore file: ${dest}")
  }
} && __create_gitignore

[[ ${RC} -eq 0 ]] && {
  __cleanup() {
    unset __cleanup
    log_stage "Performing cleanup"

    local cur_vendors_txt_lst
    declare -A cur_vendors_dels=()
    local new_vendors
    local rm_items

    new_vendors+="${OPTS[tool]}${OPTS[tool]:+$'\n'}"
    new_vendors+="${OPTS[lib]}${OPTS[lib]}"
    new_vendors="$(cut -d'@' -f 1 <<< "${new_vendors}" | grep -Exv 's+')"

    cur_vendors_txt_lst="$(find . -mindepth 1 -maxdepth 1 -type d ! \
      -name '.bin' ! -name '.lib' | sort -n | cut -d'/' -f2-)"
    while read -r v; do
      [[ -n "${v}" ]] || continue

      cur_vendors_dels[$v]="${OPTS[vendor_dir]}/${v}"

      [[ -d ".lib/${v}" ]] && {
        # this is a lib vendor
        cur_vendors_dels[$v]+=$'\n'"${OPTS[vendor_dir]}/.lib/${v}"
        continue
      }

      # tool vendor without bin (no sense though)
      [[ ! -d "${v}/bin" ]] && continue

      while read -r f; do
        [[ -n "${f}" ]] || continue

        local rmfile=".bin/$(basename "${f}")"
        cur_vendors_dels[$v]+=$'\n'"${OPTS[vendor_dir]}/${rmfile}"
      done <<< "$(find "${v}/bin" -mindepth 1 \
        -maxdepth 1 -type f -executable)"

    done <<< "${cur_vendors_txt_lst}"

    while read -r i; do
      [[ -n "${i}" ]] || continue

      while read -r del; do
        [[ -n "${del}" ]] || continue
        rm -rf "${del}" || {
          RC=$?
          ERRBAG+=("($RC) Can't remove: ${cur_vendors_dels[$i]}")
        }
      done <<< "${cur_vendors_dels[$i]}"
    done <<< "$(grep -vFx -f <(echo "${new_vendors}") <<< "${cur_vendors_txt_lst}")"
  } && __cleanup

  __install() {
    unset __install
    log_stage "Installing"

    local v_name

    local bin_dir
    while read -r v; do
      [[ -n "${v}" ]] || continue

      install_vendor "${v}"
      v_name="${RETVAL}"

      [[ -n "${v_name}" ]] || continue

      # use relative paths for symlinks
      bin_dir="../${v_name}/bin"
      [[ -d "${bin_dir}" ]] || continue

      # symlink executables
      cd "${OPTS[vendor_dir]}/.bin"
      find "${bin_dir}" -mindepth 1 -maxdepth 1 \
        -type f -executable -exec ln -sf {} . \; || {
        ERRBAG+=("Error symlinking: ${v_name}")
      }
    done <<< "${OPTS[tool]}"

    local v_dir
    local dot_libfile_dir
    local dot_libfile
    local dot_libdir="${OPTS[vendor_dir]}/.lib"
    while read -r v; do
      [[ -n "${v}" ]] || continue

      install_vendor "${v}"
      v_name="${RETVAL}"

      [[ -n "${v_name}" ]] || continue

      dot_libfile_dir="$(realpath -m "${dot_libdir}/${v_name}")"

      # probably there are some `../` in `v_name`
      [[ "${dot_libfile_dir}" == "${dot_libdir}"* ]] || continue

      # rm previous dotlib files
      rm -rf "${dot_libfile_dir}"

      # copy libs
      v_dir="${OPTS[vendor_dir]}/${v_name}"
      while read -r f; do
        [[ -n "${f}" ]] || continue

        # in vendor directory `.lib/<toolname>[/<toolsubdir]/*.sh`
        dot_libfile="$(realpath -m "${dot_libfile_dir}/${f#${v_dir}/}")"
        mkdir -p "$(dirname "${dot_libfile}")"
        cp -f "${f}" "${dot_libfile}"
      done <<< "$(find "${v_dir}" -type f \
        -name '*.sh' ! -name 'demo.*.sh')"
    done <<< "${OPTS[lib]}"
  } && __install
}
