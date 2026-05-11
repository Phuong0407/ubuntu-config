return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "clangd",
        "pyright",
        "fortls",
        "asm-lsp",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          filetypes = {
            "c",
            "cpp",
            "objc",
            "objcpp",
            "cuda",
          },
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style={BasedOnStyle: LLVM, ColumnLimit: 0, AllowShortFunctionsOnASingleLine: All, AllowShortIfStatementsOnASingleLine: WithoutElse}",
          },
        },

        pyright = {},

        fortls = {
          filetypes = { "fortran" },
        },

        asm_lsp = {
          filetypes = { "asm" },
        },
      },
    },
  },
}
