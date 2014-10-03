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
set backupcopy=no
set backupskip=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*
set noswapfile

" Completion
set completeopt=menuone,longest,preview

" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>

" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

" Key remappings
nnoremap <silent> <F5> :call <SID>StripTrailingWhitespaces()<cr>

" Autocomand functions
if has("autocmd")
	" automatically strip trailing whitespace on specified file types
	autocmd BufWritePre *.c,*.cpp,*.h :call <SID>StringTrailingWhitespaces()
endif

" Useful functions
function! <SID>StripTrailingWhitespaces()
	" Preperation: save last search and cursor position.
	let _s=@/
	let l = line(".")
	let c = col(".")
	" Do the business:
	%s/\s\+$//e
	" Clean up: restore previous search history and cursor positions
	let @/=_s
	call cursor(l,c)
endfunction

