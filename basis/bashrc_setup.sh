#!/usr/bin/env bash
set -euo pipefail

BASHRC="$HOME/.bashrc"

append_if_missing() {
  local line="$1"
  grep -Fqx "$line" "$BASHRC" || echo "$line" >>"$BASHRC"
}

touch "$BASHRC"

append_if_missing '[ -f ~/.shell/common.sh ] && . ~/.shell/common.sh'
append_if_missing '[ -f ~/.shell/bash.sh ] && . ~/.shell/bash.sh'
append_if_missing '[ -f ~/.shell/functions.sh ] && . ~/.shell/functions.sh'

. "$BASHRC"

echo "==> updated $BASHRC and sourced it."
