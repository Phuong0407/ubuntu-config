local parser_dir = vim.fn.expand("~/.local/share/nvim/treesitter-parsers")
vim.fn.mkdir(parser_dir, "p")
vim.opt.runtimepath:prepend(parser_dir)

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      parser_install_dir = parser_dir,
      ignore_install = { "bibtex", "ninja", "json", "printf" },
      ensure_installed = {
        "c",
        "cpp",
        "cuda",
        "fortran",
        "python",
        "asm",
        "bash",
        "regex",
        "lua",
        "vim",
        "vimdoc",
        "cmake",
        "make",
        "lua",
        "latex",
        "markdown",
        "markdown_inline",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.install").compilers = { "gcc" }
      require("nvim-treesitter").setup(opts)
    end,
  },
}
