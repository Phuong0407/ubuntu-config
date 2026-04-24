vim.filetype.add({
  extension = {
    h = "cpp",
    hpp = "cpp",
    tpp = "cpp",
    ipp = "cpp",
  },
})

require("config.lazy")
