-- lua/plugins/markdown.lua
return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
    },
  },

  -- lua/plugins/markdown.lua
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {},  -- LSP for markdown (links, headings navigation)
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        markdown = { "prettier" },
      },
    },
  },

  {
    "OXY2DEV/markview.nvim",
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      render_modes = { "n", "c" },
      heading = { enabled = true },
      code = { enabled = true, style = "full" },
      bullet = { enabled = true },
      checkbox = { enabled = true },
      table = { enabled = true },
      latex = { enabled = false },
      conceal = {
        default = true,
      },
    },
  },
}
