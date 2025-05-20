-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt
-- Do not sync vim clipboard with system's clipboard
opt.clipboard = ""

vim.o.breakindent = true

-- try to fix escape delay while in tmux
vim.o.ttimeoutlen = 0
