#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_CONFIG_DIR="$REPO_ROOT/config"
DST_CONFIG_DIR="$HOME/.config"

link_one() {
  local name="$1"
  local src="$SRC_CONFIG_DIR/$name"
  local dst="$DST_CONFIG_DIR/$name"

  if [ ! -e "$src" ]; then
    echo "==> Skip: $src does not exist"
    return
  fi

  if [ -L "$dst" ]; then
    echo "==> Removing existing symlink: $dst"
    rm -f "$dst"
  elif [ -e "$dst" ]; then
    echo "==> Backing up existing path: $dst -> ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi

  echo "==> Linking $dst -> $src"
  ln -s "$src" "$dst"
}

main() {
  mkdir -p "$DST_CONFIG_DIR"

  for name in "$SRC_CONFIG_DIR"/*; do
    [ -e "$name" ] || continue
    link_one "$(basename "$name")"
  done

  echo "==> Done."
}

main "$@"
