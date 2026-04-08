-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.clipboard = "unnamedplus"

vim.opt.list = true
vim.opt.listchars = { trail = "~" }

vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "\u{21AA} "
vim.opt.conceallevel = 0

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

-- vimtex
vim.g.vimtex_view_method = "zathura"
vim.g.lazyvim_check_order = false

-- kdiff3
vim.opt.diffopt:append("vertical")
vim.g.gitgutter_git_args = '--no-pager'
