-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Yank to and from clipboard
-- Found on Reddit
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = "Copy to clipboard" })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = "Paste from clipboard" })
--[[ vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P ]]
-- NERDTree
vim.keymap.set('n', '<leader>x', ':NERDTreeToggle<CR>', { desc = "Toggle NERDTree" })

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sk', require('telescope.builtin').keymaps, { desc = '[S]earch [K]eymaps' })

-- Diagnostic keymaps
vim.keymap.set('n', '(d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
vim.keymap.set('n', ')d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })
vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, { desc = 'Open diagnostics in floating window' })
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Show location list' })
vim.keymap.set('n', '<leader>dt', vim.lsp.buf.hover, { desc = 'Show info on symbol under cursor' })

-- Zettelkasten maps
vim.keymap.set('n', '<leader>sz', ":ZkNotes<CR>", { desc = '[S]earch [Z]ettelkasten' })

-- LuaSnips keymaps
vim.keymap.set('n', '<leader>sr', "<cmd> source ~/.config/nvim/after/plugin/luasnip.lua<CR>",
  { desc = "[S]nippets [R]eload" })

-- Window navigation maps
vim.keymap.set('n', '<leader>v', '<C-w>', { desc = '<C-w>' })
vim.keymap.set('n', '<leader>vv', ':vsplit<CR>', { desc = 'Vertical split' })
vim.keymap.set('n', '<leader>tt', ':terminal<CR>', { desc = 'Open terminal' })
