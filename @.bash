__iife() {
  unset __iife

  ENVAR_NAME=vendor

  local curdir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
  PATH="${curdir}/bin:${PATH}"
  PATH="${curdir}/vendor/.bin:${PATH}"
} && __iife
