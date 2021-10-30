" turn on hybrid numbers
:set number relativenumber

:set tabstop=4
:set noexpandtab
:set shiftwidth=4

" :set clipboard=unnamedplus

:inoremap <C-L> <Esc>

" We change the way movements are handle to have a better behaviour with
" wrapped lines, ie the cursor moves to match what is display instead of
" just following line numbers, but command like 2j still works as
" expected using the relative numbers
" For an clearer explanation see : https://stackoverflow.com/questions/20975928/moving-the-cursor-through-long-soft-wrapped-lines-in-vim 
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

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

" Set up Merlin
:set rtp+=/home/sofamaniac/.opam/default/share/merlin/vim

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
	\ '-outdir=./aux'
	\ ],
	\}
let g:vimtex_compiler_latexmk = { 'build_dir' : './aux' }
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

" PaperColor (theme)
Plug 'NLKNguyen/papercolor-theme'
set t_Co=256   " This is may or may not needed.
set background=dark

" undotree
Plug 'mbbill/undotree'
nnoremap <F5> :UndotreeToggle<CR>

" coq in vim
Plug 'whonore/Coqtail'

" status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

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

call plug#end()

let TEXPREAMBLE="~/cours/preamble.tex"
" Templates handling
augroup templates
	au!
	" read in template file if it exists
	autocmd BufNewFile *.* silent! execute '0r $HOME/.vim/templates/skeleton.'.expand("<afile>:e")

	" automagically set things up in template
	autocmd BufNewFile * %substitute#\[:VIM_EVAL:\]\(.\{-\}\)\[:END_EVAL:\]#\=eval(submatch(1))#ge
augroup END

" Setting options and shortcuts for buffer

set hidden

" We remap (/) to [/] to make shortcuts easier
nmap ( [
nmap ) ]

nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

colorscheme PaperColor

" Setting transparent background
hi Normal guibg=NONE ctermbg=NONE
