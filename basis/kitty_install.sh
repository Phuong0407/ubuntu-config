#!/usr/bin/env bash
set -euo pipefail

KITTY_APP="$HOME/.local/kitty.app"
LOCAL_BIN="$HOME/.local/bin"
LOCAL_APPS="$HOME/.local/share/applications"
XDG_TERMINALS="$HOME/.config/xdg-terminals.list"

echo "==> installing/updating kitty..."
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n

echo "==> Creating symlinks..."
mkdir -p "$LOCAL_BIN"
ln -sf "$KITTY_APP/bin/kitty" "$LOCAL_BIN/kitty"
ln -sf "$KITTY_APP/bin/kitten" "$LOCAL_BIN/kitten"

echo "==> installing desktop entries..."
mkdir -p "$LOCAL_APPS"
cp "$KITTY_APP/share/applications/kitty.desktop" "$LOCAL_APPS/"
cp "$KITTY_APP/share/applications/kitty-open.desktop" "$LOCAL_APPS/"

ABS_HOME="$(readlink -f "$HOME")"
sed -i "s|Icon=kitty|Icon=$ABS_HOME/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" \
  "$LOCAL_APPS"/kitty*.desktop
sed -i "s|Exec=kitty|Exec=$ABS_HOME/.local/kitty.app/bin/kitty|g" \
  "$LOCAL_APPS"/kitty*.desktop

echo "==> setting kitty as xdg terminal..."
mkdir -p "$(dirname "$XDG_TERMINALS")"
echo 'kitty.desktop' >"$XDG_TERMINALS"

echo
echo "==> installed version:"
"$LOCAL_BIN/kitty" --version || true

echo
echo "==> Check PATH resolution:"
type -a kitty || true

echo
echo "==> reminder:"
echo "1. close all old kitty windows completely."
echo "2. re-open kitty from app launcher or by running: ~/.local/bin/kitty"
echo "3. inside the new kitty, run: echo \$TERM"
echo "   expected: xterm-kitty"
echo "4. if you still see xterm-256color, remove any line like:"
echo "   export TERM=xterm-256color"
