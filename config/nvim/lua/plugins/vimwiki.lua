return {
  "vimwiki/vimwiki",
  init = function()
    vim.g.vimwiki_list = {
      { path = "/home/sofamaniac/Nextcloud/vimwiki/", syntax = "markdown", ext = ".wiki", links_space_char = "-" },
    }
    -- we restrict vimwiki to `.wiki` files otherwise it messes up the type of markdown files
    vim.g.vimwiki_ext2syntax = { [".wiki"] = "markdown" }
    vim.g.vimwiki_use_mouse = 1
    vim.g.vimwiki_markdown_link_ext = 1
  end,
}
