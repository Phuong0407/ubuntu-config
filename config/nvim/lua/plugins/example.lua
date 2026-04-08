return {
  -- LaTeX + PDF compile
  { import = "lazyvim.plugins.extras.lang.tex" },

  -- Markdown rendering + math
  { import = "lazyvim.plugins.extras.lang.markdown" },

  -- Telescope layout
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },

  -- Mason tools
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "clang-format",
        "black",
        "latexindent",
      },
    },
  },

  -- Formatters
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        python = { "black" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        tex = { "latexindent" },
      },
    },
  },
}
