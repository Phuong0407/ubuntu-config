vim.keymap.set("i", "<C-f>", function()
  local cmd = "inkscape-figures create '"
    .. vim.fn.getline("."):gsub("^%s+", ""):gsub("%s+$", "")
    .. "' "
    .. vim.fn.expand("%:p:h")
    .. "/figures/"
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
  vim.keymap.set(mode, "<Up>", "<Nop>", { noremap = true })
  vim.keymap.set(mode, "<Down>", "<Nop>", { noremap = true })
  vim.keymap.set(mode, "<Left>", "<Nop>", { noremap = true })
  vim.keymap.set(mode, "<Right>", "<Nop>", { noremap = true })
end

-- Override Tab for LuaSnip jump (load after blink load)
-- LuaSnip keymaps (GLOBAL, override LazyVim / LSP / blink)

local function luasnip_next()
  local ls = require("luasnip")
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end

local function luasnip_prev()
  local ls = require("luasnip")
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end

-- Insert + Select mode
vim.keymap.set({ "i", "s" }, "<C-j>", luasnip_next, {
  silent = true,
  noremap = true,
  desc = "LuaSnip next",
})

vim.keymap.set({ "i", "s" }, "<C-k>", luasnip_prev, {
  silent = true,
  noremap = true,
  desc = "LuaSnip prev",
})

-- vim-tmux-navigator
pcall(vim.keymap.del, "n", "<C-h>")
pcall(vim.keymap.del, "n", "<C-j>")
pcall(vim.keymap.del, "n", "<C-k>")
pcall(vim.keymap.del, "n", "<C-l>")

vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", {
  silent = true,
  desc = "Tmux navigate left",
})

vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", {
  silent = true,
  desc = "Tmux navigate down",
})

vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", {
  silent = true,
  desc = "Tmux navigate up",
})

vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", {
  silent = true,
  desc = "Tmux navigate right",
})

-- LSP go to definition
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
  desc = "Go to definition",
})

-- Indent and remain in visual mode
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true })
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true })
vim.keymap.set("n", ">", ">>", { noremap = true, silent = true })
vim.keymap.set("n", "<", "<<", { noremap = true, silent = true })

-- Use tab to jump between buffers
vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>")
vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>")

-- Focus to file pannel for toggled pannel
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", {
  desc = "Toggle file tree",
})

vim.keymap.set("n", "<leader>t", "<cmd>Neotree focus<cr>", {
  desc = "Focus file tree",
})
