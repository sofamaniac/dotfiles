" turn on hybrid numbers
:set number relativenumber

set undofile

:set tabstop=4
:set noexpandtab
:set shiftwidth=4

" add mouse support
set mouse=a

setlocal foldmethod=syntax
set autoindent

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

let g:mapleader = "\<Space>"
nnoremap <Space><Space> :nohlsearch<CR>

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
command -nargs=0 Shortcuts :vsplit ~/Nextcloud/vim_shortcuts.txt

" Syntax coloration
syntax on


let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
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
let g:UltiSnipsSnippetDirectories = ["~/.config/nvim/UltiSnips"]

" Nerdtree
Plug 'preservim/nerdtree'
let g:plug_window = 'noautocmd vertical topleft new'
nnoremap <leader>e :NERDTreeToggle<CR>
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
nnoremap <leader>u :UndotreeToggle<CR>

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

" floaterm
Plug 'voldikss/vim-floaterm'
nnoremap <leader>t :FloatermToggle<CR>

" indentation guide
Plug 'lukas-reineke/indent-blankline.nvim'

" treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" nice icons
Plug 'ryanoasis/vim-devicons'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" ctags support
Plug 'ludovicchabant/vim-gutentags'

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
" spellcheck
setlocal spell
set spelllang=fr,en_gb
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
hi clear SpellBad
hi SpellBad cterm=underline
hi SpellBad ctermfg=001
hi clear SpellCap
hi SpellCap cterm=underline
hi SpellCap ctermfg=166
hi clear SpellRare
hi SpellRare cterm=underline
hi SpellRare ctermfg=180
hi clear SpellLocal
hi SpellLocal cterm=underline
hi SpellLocal ctermfg=120
" Don't mark URL-like things as spelling errors
fun! UrlNoSpell()
	syn match UrlNoSpell '\w\+:\/\/[^[:space:]]\+' contains=@NoSpell transparent
	syn cluster Spell add=UrlNoSpell
endfun
autocmd BufRead,BufNewFile * :call UrlNoSpell()
