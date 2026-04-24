return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
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
        asm_lsp = {
          filetypes = { "asm", "s", "S" },
        },
      },
    },
  },
}
