-- Vimtex configuration
vim.g.tex_flavor='latex'
vim.g.vimtex_view_method='zathura'
vim.g.vimtex_quickfix_mode=0
vim.conceallevel=1
vim.g.tex_conceal='abdmg'
vim.g.vimtex_subfile_start_local=1
vim.g.vimtex_compiler_latexmk = {
  options = {
    '--verbose',
    '--file-line-error',
    '--synctex=1',
    '--interaction=nonstopmode',
    '--cd',
    '--outdir=./_aux',
    '-r .latexmkrc', -- Per project latexmkrc file
  }
}
vim.g.vimtex_compiler_latexmk = { build_dir = './_aux' }
-- Changed the output dir for latexmk, and added cmd in ~/.latexmkrc to move pdf to right folder
