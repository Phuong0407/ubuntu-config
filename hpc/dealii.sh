#!/usr/bin/env bash
set -euo pipefail

echo "==> installing deal.II with Spack..."

spack install -j8 \
  dealii@9.7.1 \
  +adol-c \
  +arborx \
  +arpack \
  +assimp \
  +cgal \
  +complex \
  ~cuda \
  +doc \
  +examples \
  +ginkgo \
  +gmsh \
  +gsl \
  +hdf5 \
  ~int64 \
  ~ipo \
  +kokkos \
  +metis \
  +mpi \
  +muparser \
  ~nanoflann \
  ~netcdf \
  +opencascade \
  ~optflags \
  +p4est \
  +petsc \
  +platform-introspection \
  +python \
  +scalapack \
  +simplex \
  +slepc \
  +sundials \
  +symengine \
  ~taskflow \
  +threads \
  ~trilinos \
  +vtk \
  build_system=cmake \
  build_type=Release \
  cxxstd=17 \
  generator=make \
  platform=linux \
  os=ubuntu22.04 \
  target=zen \
  %gcc@11.4.0 \
  ^/njepihm \
  ^openblas~dynamic_dispatch

echo "==> Done."
