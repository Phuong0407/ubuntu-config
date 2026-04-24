return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      bash = { "shfmt" },
      c = {},
      cpp = {},
      fish = { "fish_indent" },
      lua = { "stylua" },
      markdown = { "prettier" },
      ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
      python = { "black" },
      sh = { "shfmt" },
      tex = { "latexindent" },
    },
  },
}
