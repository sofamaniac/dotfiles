-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  -- Configure LazyVim to load catppucin
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
      flavour = "mocha",
      styles = {
        comments = { "italic" },
      },
    },
  },

  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "json",
        "lua",
        "latex",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "vim",
        "yaml",
        "toml",
      },
    },
  },

  -- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
  -- would overwrite `ensure_installed` with the new value.
  -- If you'd rather extend the default config, use the code below instead:
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
      })
    end,
  },

  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        -- must remain inactive to not interfer with rustacean
        -- "rust-analyzer",
      },
    },
  },
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      -- Vimtex configuration
      vim.g.tex_flavor = "latex"
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_quickfix_mode = 0
      vim.conceallevel = 1
      vim.g.tex_conceal = "abdmg"
      vim.g.vimtex_subfile_start_local = 1
      vim.g.vimtex_compiler_latexmk = {
        build_dir = "./_aux",
        aux_dir = "./_aux",
        out_dir = "./_aux",
        options = {
          "--verbose",
          "--file-line-error",
          "--synctex=1",
          "--interaction=nonstopmode",
          "--cd",
          "--outdir=./_aux",
          "-r .latexmkrc", -- Per project latexmkrc file
        },
      }
    end,
  },
  {
    "ryleelyman/latex.nvim",
    config = function()
      require("latex").setup({})
    end,
  },
  {
    "kmonad/kmonad-vim",
  },
}
