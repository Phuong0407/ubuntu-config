vim.filetype.add({
  extension = {
    c = "c",
    h = "c",
    cc = "cpp",
    cpp = "cpp",
    cxx = "cpp",
    hpp = "cpp",
    hxx = "cpp",
    hh = "cpp",
    ipp = "cpp",
    tpp = "cpp",
    inl = "cpp",

    cu = "cuda",
    cuh = "cuda",

    f = "fortran",
    F = "fortran",
    f90 = "fortran",
    F90 = "fortran",
    f95 = "fortran",
    F95 = "fortran",
    f03 = "fortran",
    f08 = "fortran",

    py = "python",
    pyi = "python",

    s = "asm",
    S = "asm",
    asm = "asm",

    foam = "foam",
  },

  filename = {
    controlDict = "foam",
    fvSchemes = "foam",
    fvSolution = "foam",
    blockMeshDict = "foam",
    snappyHexMeshDict = "foam",
    decomposeParDict = "foam",
    topoSetDict = "foam",
    createPatchDict = "foam",
    surfaceFeatureExtractDict = "foam",

    transportProperties = "foam",
    turbulenceProperties = "foam",
    thermophysicalProperties = "foam",
    dynamicMeshDict = "foam",

    U = "foam",
    p = "foam",
    T = "foam",
    k = "foam",
    epsilon = "foam",
    omega = "foam",
    nut = "foam",
    nuTilda = "foam",
    alpha = "foam",
  },
})
