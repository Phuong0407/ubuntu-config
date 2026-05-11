return {
  {
    "LazyVim/LazyVim",
    opts = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp", "h", "hpp", "tpp" },
        callback = function()
          vim.opt_local.makeprg = "cmake --build build"

          vim.keymap.set("n", "<leader>mb", "<cmd>make<CR>", { buffer = true, desc = "CMake build" })
          vim.keymap.set("n", "<leader>mq", "<cmd>copen<CR>", { buffer = true, desc = "Open quickfix" })
        end,
      })
    end,
  },
}
