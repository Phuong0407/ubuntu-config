#!/usr/bin/env bash
set -euo pipefail

echo "==> installing MFEM spec..."

spack install -j8 \
  "mfem@4.9.0 \
  target=x86_64 \
  build_system=generic \
  +conduit \
  +cuda \
  cuda_arch=61 \
  cxxstd=17 \
  ~debug \
  ~enzyme \
  +examples \
  +exceptions \
  +fms \
  +ginkgo \
  +gnutls \
  +gslib \
  +lapack \
  +libceed \
  +libunwind \
  +metis \
  +miniapps \
  +mpfr \
  +mpi \
  +mumps \
  +netcdf \
  +openmp \
  +petsc \
  +pumi \
  +shared \
  +slepc \
  +suite-sparse \
  +sundials \
  +superlu-dist \
  +threadsafe \
  +umpire \
  +zlib \
  ^cuda@11.8 \
  ^openblas~dynamic_dispatch"

echo "==> Done."
