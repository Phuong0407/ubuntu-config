#!/usr/bin/env bash
set -euo pipefail

ZSHRC="$HOME/.zshrc"
OHMYZSH_DIR="${ZSH:-$HOME/.oh-my-zsh}"
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$OHMYZSH_DIR/custom}"
P10K_THEME_DIR="$ZSH_CUSTOM_DIR/themes/powerlevel10k"

append_if_missing() {
  local line="$1"
  grep -Fqx "$line" "$ZSHRC" || echo "$line" >>"$ZSHRC"
}

echo "==> installing Oh My Zsh..."
if [ ! -d "$OHMYZSH_DIR" ]; then
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "==> Oh My Zsh already installed at $OHMYZSH_DIR"
fi

echo "==> installing Powerlevel10k..."
if [ -d "$P10K_THEME_DIR" ]; then
  echo "==> Powerlevel10k already exists at $P10K_THEME_DIR"
else
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_THEME_DIR"
fi

touch "$ZSHRC"

echo "==> setting ZSH_THEME in $ZSHRC ..."
if grep -q '^ZSH_THEME=' "$ZSHRC"; then
  sed -i 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' "$ZSHRC"
else
  printf '\nZSH_THEME="powerlevel10k/powerlevel10k"\n' >>"$ZSHRC"
fi

echo "==> adding shell source lines..."
append_if_missing '[[ -f ~/.shell/common.sh ]] && source ~/.shell/common.sh'
append_if_missing '[[ -f ~/.shell/zsh.sh ]] && source ~/.shell/zsh.sh'
append_if_missing '[[ -f ~/.shell/functions.sh ]] && source ~/.shell/functions.sh'

echo "==> Done."
echo "restart zsh or run:"
echo "    source ~/.zshrc"
echo
echo "then run:"
echo "    p10k configure"
