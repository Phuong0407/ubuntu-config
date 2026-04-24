return {
  -- 0. mini.pairs: add $ pairing for LaTeX math mode
  {
    "nvim-mini/mini.pairs",
    opts = {
      mappings = {
        ["$"] = {
          action = "closeopen",
          pair = "$$",
          neigh_pattern = "[^\\].",
          register = { cr = false },
        },
      },
    },
  },


  -- 1. LuaSnip
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",

    dependencies = {
      "rafamadriz/friendly-snippets",
    },

    config = function()
      local ls = require("luasnip")

      ls.config.set_config({
        enable_autosnippets = true,
        store_selection_keys = "<Tab>",
      })

      ls.filetype_extend("hpp", { "cpp" })
      ls.filetype_extend("hh",  { "cpp" })
      ls.filetype_extend("hxx", { "cpp" })
      ls.filetype_extend("h",   { "c", "cpp" })

      require("luasnip.loaders.from_vscode").lazy_load()

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "tex", "latex", "plaintex" },
        callback = function()
          vim.schedule(function()
            dofile(vim.fn.stdpath("config") .. "/snippets/tex.lua")
          end)
        end,
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
