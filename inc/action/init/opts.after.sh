OPTS+=(
  [vendor_dir]=
  [tool_prefix]=
  [tool_ver]=
)

OPTS[initdir]="$(realpath -m -- "${OPTS[initdir]}")"

__mk_vendor_dir() {
  unset __mk_vendor_dir

  OPTS[vendor_dir]="$(realpath -m \
    --relative-to="${OPTS[initdir]}" \
    -- "$(dirname "${KEEPER[tooldir]}")")"
} && __mk_vendor_dir

__mk_tool_prefix() {
  unset __mk_tool_prefix

  OPTS[tool_prefix]="$(basename -- "$(dirname "${KEEPER[bindir]}")")"
} && __mk_tool_prefix

__mk_tool_ver() {
  unset __mk_tool_ver

  OPTS[tool_ver]="$("${KEEPER[bindir]}/${KEEPER[tool]}" -v)"
} && __mk_tool_ver
