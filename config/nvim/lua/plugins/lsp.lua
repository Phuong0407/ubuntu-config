return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
        },
        pyright = {},
        asm_lsp = {
          filetypes = { "asm", "s", "S" },
        },
      },
    },
  },
}
