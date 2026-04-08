return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.install").compilers = { "gcc" }
      require("nvim-treesitter").setup({
        ensure_installed = {
          "vim",
          "regex",
          "lua",
          "bash",
          "markdown",
          "markdown_inline",
          "c",
          "cpp",
          "python",
          "fortran",
        },
        auto_install = false,
        highlight = {
          enable = true,
        },
      })
    end,
  },
}
