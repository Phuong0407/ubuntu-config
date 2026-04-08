return {
  -- 1. LuaSnip
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    config = function()
      require("luasnip").config.set_config({
        enable_autosnippets = true,
        store_selection_keys = "<Tab>",
      })
      require("luasnip.loaders.from_lua").load({
        paths = { vim.fn.stdpath("config") .. "/snippets" },
      })
    end,
  },

  -- 2. luasnip-latex-snippets
  {
    "iurimateus/luasnip-latex-snippets.nvim",
    ft = { "tex", "latex", "plaintex" },
    dependencies = { "L3MON4D3/LuaSnip", "lervag/vimtex" },
    config = function()
      require("luasnip-latex-snippets").setup({ use_treesitter = true })
    end,
  },

  -- 3. blink.cmp
  {
    "saghen/blink.cmp",
    opts = {
      snippets = { preset = "luasnip" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      keymap = {
        preset = "default",
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
      },
    },
  },
  
  -- 4. vimtex
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.vimtex_output_directory = "build"
      vim.g.vimtex_view_method = "zathura_simple"
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        aux_dir = 'build',
        out_dir = 'build',
        callback = 1,
        continuous = 0,
      }
    end,
  },
}
