export SPACK_ROOT="$HOME/spack"
[ -f "$SPACK_ROOT/share/spack/setup-env.sh" ] && . "$SPACK_ROOT/share/spack/setup-env.sh"

export NVM_DIR="$HOME/.nvm"

export stem=/data/ubdat/01_stem/
export hass=/data/ubdat/02_hass/
export proj=/data/ubdat/04_proj/
export prog=/data/ubdat/06_prog/
export lect=/data/ubdat/05_wrwk/02_lect/
export soft=/data/ubdat/07_soft/
export down=/data/ubdat/97_down/

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

nvhpc() {
  module use /opt/nvidia/hpc_sdk/modulefiles
  module load nvhpc/23.7
}

unvhpc() {
  module unload nvhpc/23.7
}

if [ -d /usr/local/go/bin ]; then
  case ":$PATH:" in
  *":/usr/local/go/bin:"*) ;;
  *) export PATH="$PATH:/usr/local/go/bin" ;;
  esac
fi

torb() {
  (
    cd /data/ubdat/98_torb || exit 1
    ./start-tor-browser.desktop "$@" >/dev/null 2>&1 &
  )
}

export PATH="/opt/adr-tools-3.0.0/src:$PATH"

# OpenAI Codex in conservative local mode:
# - read-only sandbox
# - untrusted approval policy
# - web search disabled
codex-safe() {
  codex \
    --sandbox read-only \
    --ask-for-approval untrusted \
    --config web_search='"disabled"' \
    "$@"
}
