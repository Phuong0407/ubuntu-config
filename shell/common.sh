export SPACK_ROOT="$HOME/spack"
[ -f "$SPACK_ROOT/share/spack/setup-env.sh" ] && . "$SPACK_ROOT/share/spack/setup-env.sh"

export NVM_DIR="$HOME/.nvm"

export STEM=/media/grasvis/DATA/01_stem
export HASS=/media/grasvis/DATA/02_hass
export PROJ=/media/grasvis/DATA/04_proj
export PROG=/media/grasvis/DATA/05_prog
export NOTE=/media/grasvis/DATA/06_workbench/notes
export SOFT=/media/grasvis/DATA/download/software

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

case ":$PATH:" in
  *":$HOME/.cargo/bin:"*) ;;
  *) export PATH="$HOME/.cargo/bin:$PATH" ;;
esac
