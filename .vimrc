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
    "Plug 'derekwyatt/vim-scala'
    "Plug 'elixir-editors/vim-elixir'
    "Plug 'JuliaEditorSupport/julia-vim'
    "Plug 'leafOfTree/vim-vue-plugin'
    Plug 'hashivim/vim-terraform'
    Plug 'rust-lang/rust.vim'
    Plug 'vito-c/jq.vim'
    Plug 'ziglang/zig.vim'
"HUD
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
"Colors
    Plug 'nordtheme/vim'
"Latex
    "Plug 'gerw/vim-latex-suite'
"Pocilot
    "Plug 'github/copilot.vim'
call plug#end()

"Airline
set t_Co=256
set laststatus=2
let g:airline_powerline_fonts=1
if !exists("g:airline_symbols")
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
"let g:airline_theme              = 'silver'

"Colors
syntax enable
set notermguicolors
set background=dark
colorscheme nord

"LaTeXSuite
let g:Tex_DefaultTargetFormat="pdf"

let g:mapleader=","
nnoremap <leader>llf <Plug>IMAP_JumpForward
vnoremap <leader>llf <Plug>IMAP_JumpForward
inoremap <leader>llf <Plug>IMAP_JumpForward

"autocmd InsertEnter * set norelativenumber
"autocmd InsertLeave * set relativenumber

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
set tagcase=smart
set gdefault
set incsearch
set showmatch
set showcmd
set hlsearch
set textwidth=100
set wrapmargin=2
set formatoptions=qrn1
"set colorcolumn=100
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

"mutt
au BufRead /tmp/mutt-* set tw=76

inoremap kj <esc>

nnoremap ' `
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
cmap w!! w !sudo tee > /dev/null %
nnoremap <leader>w :update<cr>

function! ToggleScheme()
  if g:colors_name == 'shine'
    set background=dark
    colorscheme nord
    AirlineTheme base16_grayscale
  else
    set background=light
    colorscheme shine
    hi CursorLine cterm=none ctermbg=255
    AirlineTheme silver
  endif
endfunction

nnoremap <leader>c :call ToggleScheme()<cr>
inoremap <F4> import ipdb;ipdb.set_trace()
cnoremap <leader>N set nonumber relativenumber!<cr>
cnoremap <leader>r set number relativenumber<cr>
nnoremap <leader>t :call GitAdd('theirs')<cr>
nnoremap <leader>o :call GitAdd('ours')<cr>
nnoremap <leader>* :call FindInFiles(1)<cr>
nnoremap <leader># :call FindInFiles(0)<cr>

function TabToSpace()
  %s/\t/  /e
endfunction

function SpaceToTab()
  %s/  /\t/e
endfunction

function DelTrailing()
  normal mp
  %s/\v\s+$//e
  normal `p
endfunction

function! GitAdd(whose)
  let currentfile = shellescape(expand('%'))
  let cmd = 'git checkout --' . a:whose . ' -- ' . l:currentfile
  call system(cmd)
  if v:shell_error
    echoerr "Fail checkout"
    return
  endif
  silent e
  call system('git add ' . l:currentfile)
  if v:shell_error
    echoerr "Failed add"
    return
  endif
  echo "把這份檔案加上去了 " . a:whose . '-' . l:currentfile
endfunction

function! FindInFiles(sensitive)
  let file_extension = expand('%:e')
  let current_word = expand('<cword>')
  let cmd = 'vim "\<' . current_word . '\>" **/*.' . file_extension

  let case = &ignorecase
  if a:sensitive && case
    set noignorecase
  endif

  execute cmd

  if case
    set ignorecase
  endif
endfunction

command Cleanspacing :call DelTrailing() <bar> :call TabToSpace()
command DelTrailing :call DelTrailing()
command Tts :call TabToSpace()
command Stt :call SpaceToTab()
command W :update

if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

let g:tagbar_type_zig = {'ctagstype': 'zig', 'kinds':
      \ ['f:functions', 's:structs', 'e:enums', 'u:unions', 'E:errors']}
