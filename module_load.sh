#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULE_REPO_DIR="$REPO_ROOT/modulefiles"
SYSTEM_MODULE_DIR="/usr/local/modulefiles"

check_prereqs() {
  local missing=()

  [ ! -d /usr/local/cuda-11.8 ] && missing+=("CUDA 11.8")
  [ ! -d /usr/local/cuda-12.2 ] && missing+=("CUDA 12.2")
  [ ! -x /usr/bin/gcc-11 ] && missing+=("gcc-11")
  [ ! -x /usr/bin/gcc-12 ] && missing+=("gcc-12")

  if [ ${#missing[@]} -gt 0 ]; then
    echo "ERROR: Missing prerequisites: ${missing[*]}" >&2
    echo "Install them before running this script." >&2
    exit 1
  fi
}

setup_cuda_modules() {
  echo "==> writing CUDA modulefiles into repo..."
  mkdir -p "$MODULE_REPO_DIR/cuda"

  cat >"$MODULE_REPO_DIR/cuda/11.8" <<'EOF'
#%Module1.0
proc ModulesHelp { } {
    puts stderr "NVIDIA CUDA Toolkit 11.8"
}
module-whatis "NVIDIA CUDA Toolkit 11.8"
conflict cuda

set root /usr/local/cuda-11.8
prepend-path PATH $root/bin
prepend-path LD_LIBRARY_PATH $root/lib64
prepend-path LIBRARY_PATH $root/lib64
prepend-path CPATH $root/include
setenv CUDA_HOME $root
setenv CUDA_ROOT $root
setenv CUDA_PATH $root
EOF

  cat >"$MODULE_REPO_DIR/cuda/12.2" <<'EOF'
#%Module1.0
proc ModulesHelp { } {
    puts stderr "NVIDIA CUDA Toolkit 12.2"
}
module-whatis "NVIDIA CUDA Toolkit 12.2"
conflict cuda

set root /usr/local/cuda-12.2
prepend-path PATH $root/bin
prepend-path LD_LIBRARY_PATH $root/lib64
prepend-path LIBRARY_PATH $root/lib64
prepend-path CPATH $root/include
setenv CUDA_HOME $root
setenv CUDA_ROOT $root
setenv CUDA_PATH $root
EOF
}

setup_gcc_modules() {
  echo "==> writing GCC modulefiles into repo..."
  mkdir -p "$MODULE_REPO_DIR/gcc"

  cat >"$MODULE_REPO_DIR/gcc/11.4.0" <<'EOF'
#%Module1.0
proc ModulesHelp { } {
    puts stderr "GNU Compiler Collection 11.4.0"
}
module-whatis "GNU Compiler Collection 11.4.0"
conflict gcc

setenv CC  /usr/bin/gcc-11
setenv CXX /usr/bin/g++-11
setenv FC  /usr/bin/gfortran-11
prepend-path PATH /usr/bin
EOF

  cat >"$MODULE_REPO_DIR/gcc/12.3.0" <<'EOF'
#%Module1.0
proc ModulesHelp { } {
    puts stderr "GNU Compiler Collection 12.3.0"
}
module-whatis "GNU Compiler Collection 12.3.0"
conflict gcc

setenv CC  /usr/bin/gcc-12
setenv CXX /usr/bin/g++-12
setenv FC  /usr/bin/gfortran-12
prepend-path PATH /usr/bin
EOF
}

setup_openfoam_modules() {
  echo "==> writing OpenFOAM modulefiles into repo..."
  mkdir -p "$MODULE_REPO_DIR/foam"

  if [ -d /opt/openfoam13 ]; then
    cat >"$MODULE_REPO_DIR/foam/13" <<'EOF'
#%Module1.0
proc ModulesHelp { } {
    puts stderr "OpenFOAM v13 (Foundation version)"
}
module-whatis "OpenFOAM v13"
conflict foam

set root /opt/openfoam13
prepend-path PATH            $root/bin
prepend-path LD_LIBRARY_PATH $root/lib
setenv FOAM_INST_DIR         /opt
setenv WM_PROJECT_DIR        $root
EOF
  fi

  if [ -d /usr/lib/openfoam/openfoam2512 ]; then
    cat >"$MODULE_REPO_DIR/foam/2512" <<'EOF'
#%Module1.0
proc ModulesHelp { } {
    puts stderr "OpenFOAM v2512 (ESI version)"
}
module-whatis "OpenFOAM v2512"
conflict foam

set root     /usr/lib/openfoam/openfoam2512
set platform linux64GccDPInt32Opt

prepend-path PATH            $root/bin
prepend-path PATH            $root/platforms/$platform/bin
prepend-path LD_LIBRARY_PATH $root/platforms/$platform/lib
prepend-path LD_LIBRARY_PATH $root/platforms/$platform/lib/dummy

setenv FOAM_INST_DIR         /usr/lib/openfoam
setenv WM_PROJECT_DIR        $root
setenv WM_PROJECT            OpenFOAM
setenv WM_PROJECT_VERSION    v2512
setenv FOAM_APPBIN           $root/platforms/$platform/bin
setenv FOAM_LIBBIN           $root/platforms/$platform/lib
EOF
  fi
}

# CAST3M modules
setup_cast3m_modules() {
  echo "==> writing Cast3M modulefiles..."
  mkdir -p "$MODULE_REPO_DIR/cast3m"

  if [ -d /home/grasvis/CASTEM2025 ]; then
    sudo tee "$MODULE_REPO_DIR/cast3m/2025" >/dev/null <<'EOF'
#%Module1.0
proc ModulesHelp { } {
    puts stderr "CASTEM2025"
}
module-whatis "CASTEM2025"
conflict cast3m

set root /home/grasvis/CASTEM2025
prepend-path PATH $root/bin
setenv CAST3M_HOME $root
EOF
  fi
}

install_symlink() {
  echo "==> Installing symlink into $SYSTEM_MODULE_DIR ..."
  sudo mkdir -p "$(dirname "$SYSTEM_MODULE_DIR")"

  if [ -e "$SYSTEM_MODULE_DIR" ] || [ -L "$SYSTEM_MODULE_DIR" ]; then
    sudo rm -rf "$SYSTEM_MODULE_DIR"
  fi

  sudo ln -s "$MODULE_REPO_DIR" "$SYSTEM_MODULE_DIR"
}

main() {
  echo ""
  echo "Setting up Environment Modulefiles from Git repo"
  echo ""

  check_prereqs
  setup_cuda_modules
  setup_gcc_modules
  setup_openfoam_modules
  setup_cast3m_modules
  install_symlink

  echo ""
  echo "Module repo: $MODULE_REPO_DIR"
  echo "System symlink: $SYSTEM_MODULE_DIR -> $MODULE_REPO_DIR"
  echo ""
  echo "Ensure MODULEPATH includes /usr/local/modulefiles"
  echo "Example:"
  echo "    module use /usr/local/modulefiles"
  echo "    module avail"
}

main "$@"
