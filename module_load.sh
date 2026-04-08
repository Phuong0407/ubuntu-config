#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULE_REPO_DIR="$REPO_ROOT/modulefiles"
SYSTEM_MODULE_DIR="/usr/local/modulefiles"

install_symlink() {
  echo "==> installing symlink into $SYSTEM_MODULE_DIR ..."

  if [ ! -d "$MODULE_REPO_DIR" ]; then
    echo "ERROR: module repo directory does not exist: $MODULE_REPO_DIR" >&2
    exit 1
  fi

  sudo mkdir -p "$(dirname "$SYSTEM_MODULE_DIR")"

  if [ -e "$SYSTEM_MODULE_DIR" ] || [ -L "$SYSTEM_MODULE_DIR" ]; then
    sudo rm -rf "$SYSTEM_MODULE_DIR"
  fi

  sudo ln -s "$MODULE_REPO_DIR" "$SYSTEM_MODULE_DIR"
}

main() {
  echo ""
  echo "linking modulefiles repo"
  echo ""

  install_symlink

  echo ""
  echo "module repo: $MODULE_REPO_DIR"
  echo "system symlink: $SYSTEM_MODULE_DIR -> $MODULE_REPO_DIR"
  echo ""
  echo "ensure MODULEPATH includes /usr/local/modulefiles"
  echo "example:"
  echo "    module use /usr/local/modulefiles"
  echo "    module avail"
}

main "$@"
