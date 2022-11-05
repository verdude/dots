set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
runtime macros/matchit.vim
call vundle#begin()
"Package Manager
    Plugin 'VundleVim/Vundle.vim'
"Comments, Alignment, Sorting
    Plugin 'godlygeek/tabular'
    Plugin 'michaeljsmith/vim-indent-object'
"Open/Close Symbols
    Plugin 'tpope/vim-surround'
    Plugin 'Raimondi/delimitMate'
"Searching
    Plugin 'ctrlpvim/ctrlp.vim'
"Distraction Free mode
    Plugin 'junegunn/goyo.vim'
"Syntax Highlighting
    Plugin 'derekwyatt/vim-scala'
    Plugin 'elixir-editors/vim-elixir'
    Plugin 'JuliaEditorSupport/julia-vim'
    Plugin 'hashivim/vim-terraform'
    Plugin 'leafOfTree/vim-vue-plugin'
"HUD
    Plugin 'vim-airline/vim-airline'
    Plugin 'vim-airline/vim-airline-themes'
"Colors
    "Plugin 'arcticicestudio/nord-vim'
    Plugin 'w0ng/vim-hybrid'
"Tmux
    "Plugin 'christoomey/vim-tmux-navigator'
"Latex
    Plugin 'gerw/vim-latex-suite'
call vundle#end()

filetype plugin indent on
"Airline
set t_Co=256
set laststatus=2
let g:airline_powerline_fonts=1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_left_sep           = '»'
let g:airline_left_sep           = '▶'
let g:airline_right_sep          = '«'
let g:airline_right_sep          = '◀'
let g:airline_symbols.linenr     = '¶'
let g:airline_symbols.maxlinenr  = '☰'
let g:airline_symbols.branch     = '⎇ '
let g:airline_symbols.spell      = 'Ꞩ'
let g:airline_symbols.notexists  = '∄'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_theme              = 'base16_grayscale'
"Colors
syntax enable
set background=dark
colorscheme hybrid
let g:solarized_termcolors=256
"LaTeXSuite
let g:Tex_DefaultTargetFormat = 'pdf'
nnoremap <leader>llf <Plug>IMAP_JumpForward
vnoremap <leader>llf <Plug>IMAP_JumpForward
inoremap <leader>llf <Plug>IMAP_JumpForward
"Python-Mode - Python debugging, highlighting, completion and more; <leader>r, <c-c>ro for imports,
set nofoldenable

"Non-Plugins
"autocmd InsertEnter * set norelativenumber
"autocmd InsertLeave * set relativenumber

let mapleader = ','

set relativenumber
set number
set directory=/tmp//,.//
set undodir=/tmp/.undo//,/tmp//,.//
set undofile
set backupdir=/tmp/.backup//,/tmp//,.//
set backup
set autoindent
set autowrite
set pastetoggle=<F2>
set ignorecase
set smartcase
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smarttab
set gdefault
set incsearch
set showmatch
set showcmd
set hlsearch
set textwidth=120
set wrapmargin=2
set formatoptions=qrn1
set colorcolumn=120
set scrolloff=1
set splitright
set splitbelow
set cursorline
set wrap
set linebreak
set ff=unix
set clipboard=unnamedplus
"Automatic, but try z= for auto fix
"set spell spelllang=en_us

"mutt
au BufRead /tmp/mutt-* set tw=76

inoremap kj <esc>

nnoremap / /\v
nnoremap <leader>/ /
nnoremap <leader>m :Goyo<cr>
nnoremap <leader>n :Goyo 150<cr> :set number relativenumber<cr>
nnoremap <leader><space> :noh<cr>
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
"nnoremap <F11> :!./%<cr>
cmap w!! w !sudo tee > /dev/null %
nnoremap <leader>w :update<cr>

cnoremap <leader>tsp set shiftwidth=2 tabstop=2 <bar> echo ">^.^<"<cr>
cnoremap <leader>fsp set shiftwidth=4 tabstop=4 <bar> echo ">^.^<"<cr>
cnoremap <leader>zxw set noexpandtab sw=4 ts=4 <bar> echo ">>>>>>>idiot<<<<<<<"<cr>
cnoremap <leader>wxz set expandtab sw=4 ts=4 <bar> echo ">>>>>>>reverse idiot<<<<<<<"<cr>
cnoremap <leader>noff set nonumber relativenumber!<cr>
cnoremap <leader>non set number relativenumber<cr>

function TabToSpace()
  %s/\t/  /e
endfunction

function SpaceToTab()
  %s/  /\t/e
endfunction

function DelTrailing()
  %s/\s\s*\n/\r/e
endfunction

command Cleanspacing :call DelTrailing() <bar> :call TabToSpace()
command DelTrailing :call DelTrailing()
command Tts :call TabToSpace()
command Stt :call SpaceToTab()
command S :update

nnoremap <leader>ltx :%s:<++>::<cr>

if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
