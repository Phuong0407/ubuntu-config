#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_SHELL_DIR="$REPO_ROOT/shell"
DST_SHELL_DIR="$HOME/.shell"

link_one() {
  local name="$1"
  local src="$SRC_SHELL_DIR/$name"
  local dst="$DST_SHELL_DIR/$name"

  if [ ! -e "$src" ]; then
    echo "==> Skip: missing $src"
    return
  fi

  if [ -L "$dst" ]; then
    echo "==> Removing existing symlink: $dst"
    rm -f "$dst"
  elif [ -e "$dst" ]; then
    echo "==> Backing up existing file: $dst -> ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi

  echo "==> Linking $dst -> $src"
  ln -s "$src" "$dst"
}

main() {
  mkdir -p "$DST_SHELL_DIR"

  for path in "$SRC_SHELL_DIR"/*; do
    [ -e "$path" ] || continue
    link_one "$(basename "$path")"
  done

  echo "==> Done."
}

main "$@"
