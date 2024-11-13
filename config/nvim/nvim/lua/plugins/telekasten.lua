-- ...
-- Telekasten
return {
  {
    "renerocksai/telekasten.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {
      home = vim.fn.expand("~/Nextcloud/zettelkasten"),
      -- TODO: this should not be necessary since in `markdown.lua` I take all the required step for markdown-render to work
      auto_set_filetype = false, -- set filetype to `markdown` for `ltex-ls`
      command_palette_thme = "dropdown",
      show_tags_theme = "dropdown",
      template_new_note = vim.fn.expand("~/Nextcloud/zettelkasten/template_new_note.md"),
    },
    keys = {
      { "<leader>z", desc = "zettelkasten" },
      { "<leader>zz", "<cmd>Telekasten panel<CR>", desc = "Zettelkasten Panel" },
      { "<leader>zn", "<cmd>Telekasten new_note<CR>", desc = "Zettelkasten New [n]ote" },
      { "<leader>zg", "<cmd>Telekasten follow_link<CR>", desc = "Zettelkasten Follow link" },
      { "<leader>zd", "<cmd>Telekasten goto_today<CR>", desc = "Goto to[d]ay" },
      { "<leader>zw", "<cmd>Telekasten goto_thisweek<CR>", desc = "Goto this [w]eek" },
      { "<leader>zt", "<cmd>Telekasten toggle_todo<CR>", desc = "Toggle [T]o-do" },
      -- Search in zettelkasten
      { "<leader>sz", desc = "zettelkasten" },
      { "<leader>szn", "<cmd>Telekasten find_notes<CR>", desc = "Find note" },
      { "<leader>szd", "<cmd>Telekasten find_daily<CR>", desc = "Find daily note" },
      { "<leader>szw", "<cmd>Telekasten find_weekly<CR>", desc = "Find weekly note" },
      { "<leader>szt", "<cmd>Telekasten show_tags<CR>", desc = "Show tags" },
    },
  },
  -- {
  --   -- image preview for markdown files
  --   "3rd/image.nvim",
  --   opts = {
  --     markdown = {
  --       integrations = { "markdown", "vimwiki", "telekasten" },
  --     },
  --   },
  --   -- FIXME: fuck you luarocks
  --   -- dependencies = { "leafo/magick" },
  -- },
}
