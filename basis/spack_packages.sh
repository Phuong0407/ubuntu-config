#!/usr/bin/env bash
set -euo pipefail

SPACK_USER_CONFIG_DIR="${SPACK_USER_CONFIG_DIR:-$HOME/.spack}"
PACKAGES_YAML="${SPACK_USER_CONFIG_DIR}/packages.yaml"

mkdir -p "$SPACK_USER_CONFIG_DIR"

cat >"$PACKAGES_YAML" <<'EOF'
packages:
  llvm:
    externals:
    - spec: llvm@14.0.0+clang~flang+lld+lldb
      prefix: /usr
      extra_attributes:
        compilers:
          c: /usr/bin/clang
          cxx: /usr/bin/clang++
    - spec: llvm@14.0.0+clang~flang~lld~lldb
      prefix: /usr/lib/llvm-14
      extra_attributes:
        compilers:
          c: /usr/bin/clang
          cxx: /usr/bin/clang++
    buildable: false

  gcc:
    externals:
    - spec: gcc@12.3.0 languages:='c,c++,fortran'
      prefix: /usr
      extra_attributes:
        compilers:
          c: /usr/bin/gcc-12
          cxx: /usr/bin/g++-12
          fortran: /usr/bin/gfortran-12
    - spec: gcc@11.4.0 languages:='c,c++,fortran'
      prefix: /usr
      extra_attributes:
        compilers:
          c: /usr/bin/gcc-11
          cxx: /usr/bin/g++-11
          fortran: /usr/bin/gfortran-11
    buildable: false

  cuda:
    externals:
    - spec: cuda@11.8
      prefix: /usr/local/cuda-11.8
    - spec: cuda@12.2
      prefix: /usr/local/cuda-12.2
    buildable: false
EOF

echo "wrote: $PACKAGES_YAML"
echo
echo "contents:"
sed -n '1,200p' "$PACKAGES_YAML"
