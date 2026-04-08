#!/usr/bin/env bash
set -euo pipefail

SPACK_USER_CONFIG_DIR="${SPACK_USER_CONFIG_DIR:-$HOME/.spack}"
MODULES_YAML="${SPACK_USER_CONFIG_DIR}/modules.yaml"

mkdir -p "$SPACK_USER_CONFIG_DIR"

cat >"$MODULES_YAML" <<'EOF'
modules:
  default:
    enable:
    - lmod
    lmod:
      core_compilers:
      - gcc@11.4.0
      all:
        autoload: direct
      projections:
        all: '{name}/{version}'
EOF

echo "wrote: $MODULES_YAML"
echo
sed -n '1,200p' "$MODULES_YAML"
