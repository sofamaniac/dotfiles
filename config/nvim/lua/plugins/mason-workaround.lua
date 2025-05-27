-- We need to pin mason because of a breaking change
-- see https://github.com/LazyVim/LazyVim/issues/6039
return {
  { "mason-org/mason.nvim", version = "^1.0.0" },
  { "mason-org/mason-lspconfig.nvim", version = "^1.0.0" },
}
