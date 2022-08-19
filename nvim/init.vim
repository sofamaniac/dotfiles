" turn on hybrid numbers
:set number relativenumber

:set tabstop=4
:set noexpandtab
:set shiftwidth=4

" add mouse support
set mouse=a


filetype plugin on
set omnifunc=syntaxcomplete#Complete

" We change the way movements are handle to have a better behaviour with
" wrapped lines, ie the cursor moves to match what is display instead of
" just following line numbers, but command like 2j still works as
" expected using the relative numbers
" For an clearer explanation see : https://stackoverflow.com/a/21000307

nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" shortcuts for tab navigation
nnoremap H gT
nnoremap L gt

" remap double esc in terminal mode to exit back to normal mode
tnoremap <Esc><Esc> <C-\><C-n>

" config terminal buffers
function! SetTerminalOptions()
    setlocal nospell
    setlocal nonumber
    setlocal nornu
endfunction
au TermOpen * call SetTerminalOptions()

" Some custom commands
:command -nargs=0 Shortcuts :vsplit ~/Nextcloud/vim_shortcuts.txt

" Syntax coloration
:syntax on

" spellcheck
:set spell
:set spelllang=fr,en_gb
:hi clear SpellBad
:hi SpellBad cterm=underline
:hi SpellBad ctermfg=001

:setlocal foldmethod=syntax
:set autoindent

" Gestion des plugins
call plug#begin('~/.vim/plugged')

" Latex configuration
Plug 'lervag/vimtex'
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'
let g:vimtex_subfile_start_local=1
let g:vimtex_compiler_latexmk = { 'options' : [
	\ '-verbose',
	\ '-file-line-error',
	\ '-synctex=1',
	\ '-interaction=nonstopmode',
	\ '-cd', 
	\ '-outdir=./_aux'
	\ ],
	\}
let g:vimtex_compiler_latexmk = { 'build_dir' : './_aux' }
" Changed the output dir for latexmk, and added cmd in ~/.latexmkrc to move pdf to right folder

" Ultisnips configuration
Plug 'sirver/ultisnips'
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'
set runtimepath+=~/.vim/snippets/UltiSnips

" Markdown Preview
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" Nerdtree
Plug 'preservim/nerdtree'
let g:plug_window = 'noautocmd vertical topleft new'
nnoremap <leader>e :NERDTreeToggle<CR>
" automatically start NERDTree
autocmd VimEnter * NERDTree
autocmd BufWinEnter * NERDTreeMirror
autocmd VimEnter * wincmd w
" automagically close vim if NERDTree is the last and only buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" status bar
Plug 'itchyny/lightline.vim'
" PaperColor (theme)
Plug 'NLKNguyen/papercolor-theme'
set t_Co=256   " This is may or may not needed.
set background=dark

" undotree
Plug 'mbbill/undotree'
nnoremap <F5> :UndotreeToggle<CR>

" coc.nvim
Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-sh', 'coc-clangd']
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" vimwiki and necessary parameters settings
Plug 'vimwiki/vimwiki'
set nocompatible
filetype plugin on
syntax on
let g:vimwiki_list = [{'path': '~/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]

" glow.nvim for rendering markdown in vim
Plug 'ellisonleao/glow.nvim', {'branch': 'main'}

" fzf for vim
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" sugar for reasonml files
Plug 'reasonml-editor/vim-reason-plus'

" floaterm
Plug 'voldikss/vim-floaterm'
nnoremap <leader>t :FloatermToggle<CR>

" indentation guide
Plug 'lukas-reineke/indent-blankline.nvim'

" treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" orgmode
Plug 'nvim-neorg/neorg' | Plug 'nvim-lua/plenary.nvim'

" nice icons
Plug 'ryanoasis/vim-devicons'

" syntax support for eww config language
Plug 'elkowar/yuck.vim'

call plug#end()

let g:PaperColor_Theme_Options={
            \ 'theme': {
                \ 'default': {
                    \ 'transparent_background': 1,
                    \ 'override' : {
                        \ 'color05': ['#2F7A47', '']
                    \}
                \},
            \}
        \}
let g:ariline_theme='papercolor'
let g:lightline = { 'colorscheme': 'PaperColor' }
colorscheme PaperColor

let TEXPREAMBLE="~/cours/preamble.tex"
" Templates handling
augroup templates
	au!
	" read in template file if it exists
	autocmd BufNewFile *.* silent! execute '0r $HOME/.vim/templates/skeleton.'.expand("<afile>:e")

	" automagically set things up in template
	autocmd BufNewFile * %substitute#\[:VIM_EVAL:\]\(.\{-\}\)\[:END_EVAL:\]#\=eval(submatch(1))#ge
augroup END

" Treesitter configuration
lua << EOF
require('config')
EOF

" Setting options and shortcuts for buffer
set hidden

" We remap (/) to [/] to make shortcuts easier
nmap ( [
nmap ) ]

nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

" Found on Reddit
" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" Setting transparent background
hi Normal guibg=NONE ctermbg=NONE
hi Conceal ctermfg=109 guifg=#83a598 guibg=None ctermbg=None
" transparency for line numbers
hi clear LineNr
" transparency for sign column
hi clear SignColumn

" ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
let s:opam_share_dir = system("opam var share")
let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

let s:opam_configuration = {}

function! OpamConfOcpIndent()
  execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
endfunction
let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

function! OpamConfOcpIndex()
  execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
endfunction
let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

function! OpamConfMerlin()
  let l:dir = s:opam_share_dir . "/merlin/vim"
  execute "set rtp+=" . l:dir
endfunction
let s:opam_configuration['merlin'] = function('OpamConfMerlin')

let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
for tool in s:opam_packages
  " Respect package order (merlin should be after ocp-index)
  if count(s:opam_available_tools, tool) > 0
    call s:opam_configuration[tool]()
  endif
endfor
" ## end of OPAM user-setup addition for vim / base ## keep this line
" ## added by OPAM user-setup for vim / ocp-indent ## 304d6b5a9cb3e1589c95f6f558adbf40 ## you can edit, but keep this line
if count(s:opam_available_tools,"ocp-indent") == 0
  source "/home/sofamaniac/Nextcloud/cours/M1/stage/goblint/analyzer/_opam/share/ocp-indent/vim/indent/ocaml.vim"
endif
" ## end of OPAM user-setup addition for vim / ocp-indent ## keep this line
