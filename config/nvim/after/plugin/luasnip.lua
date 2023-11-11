require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/snippets"})

require("luasnip").setup {
  enable_autosnippets = true,
  update_events = {"TextChanged", "TextChangedI"}
}
