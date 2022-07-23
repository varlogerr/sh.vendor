#!/usr/bin/env bash

declare RETVAL
declare -a ERRBAG=()
declare -A DEFAULTS=(
  [action]=install
  [conffile]="$(pwd)/.vendor.conf"
  [vendor_dir]=./vendor
  [vendor_version]=master
  [tool_url]=https://github.com/varlogerr/toolbox.sh.vendor.git
)

declare -A KEEPER=(
  [tool]="$(basename "${BASH_SOURCE[0]}")"
  [bindir]="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
)
KEEPER[tooldir]="$(realpath "${KEEPER[bindir]}/..")"
KEEPER[incdir]="${KEEPER[tooldir]}/inc"
KEEPER[vendor_dir]="${KEEPER[tooldir]}/vendor"

. "${KEEPER[vendor_dir]}/.lib/lib/lib/txt.sh"

. "${KEEPER[incdir]}/opts.sh"
. "${KEEPER[incdir]}/run.sh"
