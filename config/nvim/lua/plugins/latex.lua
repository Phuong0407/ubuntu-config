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
    keys = {
      {
        "<C-k>",
        function()
          local ls = require("luasnip")
          if ls.expandable() then
            ls.expand()
          elseif ls.jumpable(1) then
            ls.jump(1)
          end
        end,
        mode = { "i", "s" },
      },
      {
        "<C-j>",
        function()
          require("luasnip").jump(-1)
        end,
        mode = { "i", "s" },
      },
    },
  },

  -- 2. luasnip-latex-snippets
  {
    "iurimateus/luasnip-latex-snippets.nvim",
    ft = { "tex", "latex", "plaintex" },
    dependencies = { "L3MON4D3/LuaSnip", "lervag/vimtex" },
    config = function()
      local m = require("luasnip-latex-snippets")
      m.setup({ use_treesitter = true })
      if vim.bo.filetype == "tex" then
        local utils = require("luasnip-latex-snippets.util.utils")
        local is_math = utils.with_opts(utils.is_math, true)
        local not_math = utils.with_opts(utils.not_math, true)
        m.setup_tex(is_math, not_math)
      end
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
        ["<CR>"] = {
          function(cmp)
            local ls = require("luasnip")
            if ls.expandable() then
              vim.schedule(function() ls.expand() end)
              return true
            end
          end,
          "accept",
          "fallback",
        },
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
