export SPACK_ROOT="$HOME/spack"
[ -f "$SPACK_ROOT/share/spack/setup-env.sh" ] && . "$SPACK_ROOT/share/spack/setup-env.sh"

export NVM_DIR="$HOME/.nvm"

export stem=/data/ubdat/01_stem/
export hass=/data/ubdat/02_hass/
export proj=/data/ubdat/04_proj/
export prog=/data/ubdat/06_prog/
export lect=/data/ubdat/05_wrwk/01_lect/
export soft=/data/ubdat/07_soft/

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

case ":$PATH:" in
*":$HOME/.local/bin:"*) ;;
*) export PATH="$HOME/.local/bin:$PATH" ;;
esac

case ":$PATH:" in
*":$HOME/.cargo/bin:"*) ;;
*) export PATH="$HOME/.cargo/bin:$PATH" ;;
esac

export PATH="$HOME/.local/bin:$PATH"

loadnvhpc() {
  module use /opt/nvidia/hpc_sdk/modulefiles
  module load nvhpc/23.7
}

uloadnvhpc() {
  module unload nvhpc/23.7
}
