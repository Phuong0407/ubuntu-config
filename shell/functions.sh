dealii() {
  spack load dealii@9.7.1

  export CC=/usr/bin/gcc
  export CXX=/usr/bin/g++
  export FC=/usr/bin/gfortran

  cmake "$@" \
    -DCMAKE_C_COMPILER=/usr/bin/gcc \
    -DCMAKE_CXX_COMPILER=/usr/bin/g++ \
    -DCMAKE_Fortran_COMPILER=/usr/bin/gfortran

  spack unload dealii@9.7.1
}

su2() {
  spack load swig py-mpi4py szip openmpi openblas hdf5
  export SU2_HOME=/media/grasvis/DATA/download/software/SU2
  export SU2_RUN=/home/grasvis/su2/bin
  export PATH="$PATH:$SU2_RUN"
  export PYTHONPATH="$PYTHONPATH:$SU2_RUN"
}
