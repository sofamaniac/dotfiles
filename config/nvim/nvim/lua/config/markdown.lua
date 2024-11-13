-- see https://www.lazyvim.org/extras/lang/markdown
vim.treesitter.language.register("markdown", "vimwiki")
vim.treesitter.language.register("markdown", "telekasten")
-- enabling a bunch of plugins (see https://www.lazyvim.org/extras/lang/markdown)
require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "plugins" },
  },
})
require("render-markdown").setup({
  file_types = { "markdown", "vimwiki", "telekasten" },
  latex = { enabled = false },
  win_options = {
    conceallevel = { rendered = 2 },
  },
})
require("latex").setup({})
