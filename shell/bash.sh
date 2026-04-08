export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

mod_prefix="$(spack location -i environment-modules 2>/dev/null)"
if [ -n "$mod_prefix" ] && [ -f "$mod_prefix/init/bash" ]; then
    source "$mod_prefix/init/bash"
fi

module use /usr/local/modulefiles 2>/dev/null || true
