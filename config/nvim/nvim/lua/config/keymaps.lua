-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- use `vim.keymap.set` instead
-- local map = LazyVim.safe_keymap_set

-- Remap for dealing with word wrap
LazyVim.safe_keymap_set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
LazyVim.safe_keymap_set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

require("which-key").add({
  -- Yank to and from clipboard
  -- Found on Reddit
  {
    mode = { "n", "v" },
    { "<leader>y", '"+y', desc = "Copy to clipboard" },
    { "<leader>p", '"+p', desc = "Paste from clipboard" },
  },
})
