" Set syntax on
syntax on

" Indent automatically depending on the filetype
filetype indent on
set autoindent

" Highlight search
set hls

" Intentation
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent

" Search
set hlsearch
set incsearch
set ignorecase

" General Settings
set nocompatible
set hidden
set history=1000
set visualbell
set ruler
set title
set showcmd
set laststatus=2
set showmatch
set linebreak
set backspace=indent,eol,start
set whichwrap+=<,>,[,],h,l
set matchpairs+=<:>

" Backups and Swap
set backupdir=~/tmp/sessions
set backupcopy=yes
set backupskip=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*
set noswapfile

" Completion
set completeopt=menuone,longest,preview


