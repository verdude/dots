set nocompatible
autocmd FileType python setlocal ts=4 sw=4 sts=4
filetype plugin indent on

runtime macros/matchit.vim

let data_dir = '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
"Comments, Alignment, Sorting
    Plug 'godlygeek/tabular'
    Plug 'michaeljsmith/vim-indent-object'
"Open/Close Symbols
    Plug 'tpope/vim-surround'
    Plug 'Raimondi/delimitMate'
"Searching
    Plug 'ctrlpvim/ctrlp.vim'
"Distraction Free mode
    Plug 'junegunn/goyo.vim'
"Syntax Highlighting
    Plug 'derekwyatt/vim-scala'
    Plug 'elixir-editors/vim-elixir'
    Plug 'JuliaEditorSupport/julia-vim'
    Plug 'hashivim/vim-terraform'
    Plug 'leafOfTree/vim-vue-plugin'
    Plug 'rust-lang/rust.vim'
    Plug 'vito-c/jq.vim'
    Plug 'ziglang/zig.vim'
"HUD
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
"Colors
    Plug 'sainnhe/everforest'
"Tmux
    "Plugin 'christoomey/vim-tmux-navigator'
"Latex
    Plug 'gerw/vim-latex-suite'
"Pocilot
    "Plug 'github/copilot.vim'
call plug#end()

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
"let g:airline_theme              = 'base16_grayscale'
"Colors
syntax enable
set background=dark
colorscheme everforest
let g:solarized_termcolors=256
"LaTeXSuite
let g:Tex_DefaultTargetFormat = 'pdf'
nnoremap <leader>llf <Plug>IMAP_JumpForward
vnoremap <leader>llf <Plug>IMAP_JumpForward
inoremap <leader>llf <Plug>IMAP_JumpForward

"Non-Plugins
"autocmd InsertEnter * set norelativenumber
"autocmd InsertLeave * set relativenumber

let mapleader = ','

set wildignore+=dist/**
set nofoldenable
set relativenumber
set number
set directory=/tmp//,.//
set undodir=/tmp/.undo//,/tmp//,.//
set undofile
set backupdir=/tmp/.backup//,/tmp//,.//
set backupcopy=yes
set backupskip=
set backup
set autowrite
set pastetoggle=<F2>
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set showcmd
set hlsearch
set textwidth=100
set wrapmargin=2
set formatoptions=qrn1
set colorcolumn=100
set scrolloff=1
set splitright
set splitbelow
set wrap
set linebreak
set ff=unix

set autoindent
set expandtab
set smarttab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set cursorline

if !has('macunix')
  set clipboard=unnamedplus
endif

"Automatic, but try z= for auto fix
"set spell spelllang=en_us

"mutt
au BufRead /tmp/mutt-* set tw=76

inoremap kj <esc>

nnoremap / /\v
nnoremap <leader>/ /
nnoremap <leader>m :Goyo<cr>
nnoremap <leader>b :Goyo 80<cr>
nnoremap <leader>n :Goyo 100<cr> :set number relativenumber<cr>
nnoremap <leader>k :Goyo 150<cr> :set number relativenumber<cr>
nnoremap <leader>j :Goyo 200<cr> :set number relativenumber<cr>
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

function StyleCursorLine()
  set cursorline
  hi CursorLine cterm=none ctermbg=255
endfunction

nnoremap <leader>c :call StyleCursorLine()<cr>

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
command W :update

nnoremap <leader>ltx :%s:<++>::<cr>

if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
