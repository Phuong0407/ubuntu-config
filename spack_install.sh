#!/usr/bin/env bash
set -euo pipefail

SPACK_ROOT="${SPACK_ROOT:-$HOME/spack}"

if [ ! -d "$SPACK_ROOT/.git" ]; then
  git clone https://github.com/spack/spack.git "$SPACK_ROOT"
else
  echo "spack already exists at $SPACK_ROOT"
fi

. "$SPACK_ROOT/share/spack/setup-env.sh"

echo "[1/4] detecting compilers..."
spack compiler find /usr/bin

echo "[2/4] registered compilers..."
spack compiler list

echo "[3/4] verifying gcc toolchains..."
command -v gcc-11 >/dev/null 2>&1 && gcc-11 --version | head -n 1 || true
command -v g++-11 >/dev/null 2>&1 && g++-11 --version | head -n 1 || true
command -v gfortran-11 >/dev/null 2>&1 && gfortran-11 --version | head -n 1 || true

command -v gcc-12 >/dev/null 2>&1 && gcc-12 --version | head -n 1 || true
command -v g++-12 >/dev/null 2>&1 && g++-12 --version | head -n 1 || true
command -v gfortran-12 >/dev/null 2>&1 && gfortran-12 --version | head -n 1 || true

echo "[4/4] Done."
