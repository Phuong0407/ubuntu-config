#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

echo "[1/6] apt update..."
sudo apt update

echo "[2/6] base development packages..."
sudo apt install -y \
  build-essential \
  software-properties-common \
  ca-certificates \
  gnupg \
  lsb-release \
  file \
  pkg-config \
  make \
  ninja-build \
  cmake \
  meson \
  autoconf \
  automake \
  libtool \
  m4 \
  gdb \
  valgrind \
  strace \
  ltrace \
  binutils \
  binutils-dev \
  patchelf \
  chrpath \
  ccache \
  git \
  curl \
  wget \
  zip \
  unzip \
  tar \
  xz-utils \
  rsync \
  tree \
  htop \
  nvtop \
  environment-modules \
  python3 \
  python3-pip \
  python3-venv

echo "[3/6] gcc/g++/gfortran 11 and 12..."
sudo apt install -y \
  gcc-11 g++-11 gfortran-11 \
  gcc-12 g++-12 gfortran-12

echo "[4/6] LLVM/Clang toolchain..."
sudo apt install -y \
  clang \
  llvm \
  lld \
  lldb \
  clangd \
  clang-tidy \
  clang-format \
  libomp-dev

echo "[5/6] common C/C++/Fortran dev libraries..."
sudo apt install -y \
  libc6-dev \
  libstdc++-11-dev \
  libgcc-11-dev \
  libgfortran-11-dev \
  libstdc++-12-dev \
  libgcc-12-dev \
  libgfortran-12-dev

echo "[6/6] register compilers with update-alternatives..."
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 110 \
  --slave /usr/bin/g++ g++ /usr/bin/g++-11 \
  --slave /usr/bin/gfortran gfortran /usr/bin/gfortran-11

sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 120 \
  --slave /usr/bin/g++ g++ /usr/bin/g++-12 \
  --slave /usr/bin/gfortran gfortran /usr/bin/gfortran-12

echo
echo "installed compilers:"
command -v gcc-11 >/dev/null 2>&1 && gcc-11 --version | head -n 1 || true
command -v gcc-12 >/dev/null 2>&1 && gcc-12 --version | head -n 1 || true
command -v g++-11 >/dev/null 2>&1 && g++-11 --version | head -n 1 || true
command -v g++-12 >/dev/null 2>&1 && g++-12 --version | head -n 1 || true
command -v gfortran-11 >/dev/null 2>&1 && gfortran-11 --version | head -n 1 || true
command -v gfortran-12 >/dev/null 2>&1 && gfortran-12 --version | head -n 1 || true
command -v clang >/dev/null 2>&1 && clang --version | head -n 1 || true
command -v clang++ >/dev/null 2>&1 && clang++ --version | head -n 1 || true
command -v llvm-config >/dev/null 2>&1 && llvm-config --version || true

echo
echo "default GCC family:"
readlink -f /usr/bin/gcc || true
readlink -f /usr/bin/g++ || true
readlink -f /usr/bin/gfortran || true

echo
echo "done."
echo "to choose default compiler interactively, run:"
echo "  sudo update-alternatives --config gcc"
