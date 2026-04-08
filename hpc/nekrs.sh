#!/usr/bin/env bash
set -euo pipefail

echo "==> installing nekrs with Spack..."

spack install -j8 \
  nekrs@23.0 \
  build_system=cmake \
  build_type=Release \
  +cuda cuda_arch=61 \
  generator \
  +opencl
