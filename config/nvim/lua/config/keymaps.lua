-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Inkscape figures
-- Insert mode: Ctrl+F create new figure from the typed name

vim.keymap.set("i", "<C-f>", function()
  local cmd = "inkscape-figures create '" .. vim.fn.getline("."):gsub("^%s+", ""):gsub("%s+$", "") .. "' " ..
              vim.fn.expand("%:p:h") .. "/figures/"
  vim.fn.system(cmd)
  -- Replace current line with \incfig
  local line = vim.fn.getline(".")
  local figname = line:gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s+", "-"):lower()
  vim.fn.setline(".", string.format("\\incfig{%s}", figname))
end, { desc = "Create Inkscape figure" })

-- Normal mode: Ctrl+F open figure picker
vim.keymap.set("n", "<C-f>", function()
  local cmd = "inkscape-figures edit '" .. vim.fn.expand("%:p:h") .. "/figures/' "
  vim.fn.termopen(cmd)
end, { desc = "Edit Inkscape figure" })

-- Disable arrow keys in all modes
local modes = { "n", "i", "v", "x", "s", "o", "c", "t" }
for _, mode in ipairs(modes) do
  vim.keymap.set(mode, "<Up>",    "<Nop>", { noremap = true })
  vim.keymap.set(mode, "<Down>",  "<Nop>", { noremap = true })
  vim.keymap.set(mode, "<Left>",  "<Nop>", { noremap = true })
  vim.keymap.set(mode, "<Right>", "<Nop>", { noremap = true })
end

-- Override Tab for LuaSnip jump (load after blink load)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex", "latex" },
  callback = function()
    local opts = { buffer = true, silent = true }
    vim.keymap.set({ "i", "s" }, "<C-k>", function()
      local ls = require("luasnip")
      if ls.expandable() then
        ls.expand()
      elseif ls.jumpable(1) then
        ls.jump(1)
      end
    end, opts)
    vim.keymap.set({ "i", "s" }, "<C-j>", function()
      require("luasnip").jump(-1)
    end, opts)
  end,
})
