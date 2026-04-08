export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

mod_prefix="$(spack location -i environment-modules 2>/dev/null)"
if [ -n "$mod_prefix" ] && [ -f "$mod_prefix/init/zsh" ]; then
    source "$mod_prefix/init/zsh"
fi

module use /usr/local/modulefiles 2>/dev/null || true
