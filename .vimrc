" Modeline and Notes {
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker spell:
"
" }

" Environment {

    " Identify platform {
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return  (has('win32') || has('win64'))
        endfunction
    " }

    " Basics {
        set nocompatible        " Must be first line
        if !WINDOWS()
            set shell=/bin/sh
        endif
    " }

    " Windows Compatible {
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        if WINDOWS()
          set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
        endif
    " }
    
    " Arrow Key Fix {
        " https://github.com/spf13/spf13-vim/issues/780
        if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
            inoremap <silent> <C-[>OC <RIGHT>
        endif
    " }

" }

filetype off

" Set up Vundle and add plugins {

" Set the runtime path to include Vundle and initialise
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Additional plugins to use are added here
Plugin 'scrooloose/nerdtree'
Plugin 'bling/vim-airline'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'powerline/fonts'
Plugin 'bling/vim-bufferline'

Plugin 'rhysd/conflict-marker.vim'
Plugin 'mbbill/undotree'
Plugin 'jiangmiao/auto-pairs'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tacahiroy/ctrlp-funky'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'scrooloose/nerdcommenter'
Plugin 'tpope/vim-abolish.git'

if executable('ctags')
    Bundle 'majutsushi/tagbar'
endif
Plugin 'luochen1990/rainbow'
Plugin 'Shougo/neocomplete.vim.git'
Plugin 'Shougo/neosnippet'
Plugin 'Shougo/neosnippet-snippets'
Plugin 'tpope/vim-characterize'
Plugin 'tpope/vim-surround'

" Themes
Plugin 'sickill/vim-monokai'
Plugin 'fcevado/molokai_dark'
Plugin 'sjl/badwolf'
Plugin 'morhetz/gruvbox'

" Git support
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-git'
Plugin 'airblade/vim-gitgutter'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-shell'

" Language support
Plugin 'rust-lang/rust.vim'
Plugin 'fatih/vim-go'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-dispatch'
Plugin 'klen/python-mode'
Plugin 'parkr/vim-jekyll'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'tpope/vim-markdown'

call vundle#end()

" }

"  General Settings {

    filetype plugin indent on           " Automatically detect file types
    set background=dark
    syntax on                           " Syntax highlighting
    scriptencoding utf-8
    set encoding=utf-8

    if isdirectory(expand("~/.vim/bundle/badwolf"))
        colorscheme badwolf
    endif

    if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else         " On mac and Windows, use * register fnr copy-paste
            set clipboard=unnamed
        endif
    endif

    if has("gui_running")
        set lines=55 columns=200
		if has("win32")
			set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h10
		else
			set guifont="Droid Sans Mono Dotted for Powerline 10"
		endif		        
        set guioptions-=T                   " Remove the tool bar
        set guioptions-=r                   " Remove the right-hand scroll bar
    else
        set term=xterm-256color
    endif

    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    set nospell                         " Spell checking off
    set hidden                          " Allow buffer switching without saving
    set iskeyword-=.                    " '.' is an end of word designator
    set iskeyword-=#                    " '#' is an end of word designator
    set iskeyword-=-                    " '-' is an end of word designator

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " http://vim.wikia.com/Restore_cursor_to_file_position_in_previous_editing_session
    " Restore cursor to file position in previous editing session
    function! ResCur()
        if line("'\"") <= line("$")
            normal! g`"
            return 1
        endif
    endfunction

    augroup resCur
        autocmd!
        autocmd BufWinEnter * call ResCur()
    augroup END

    " Setting up the directories
    set backup                  " Backups are nice ...
    if has('persistent_undo')
        set undofile                " So is persistent undo ...
        set undolevels=1000         " Maximum number of changes that can be undone
        set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
    endif
" }

 " User interface {

    set showmode                    " Display the current mode
    set cursorline                  " Highlight the current line

    highlight clear SignColumn      " Sign column should match background
    highlight clear LineNr          " Current line number row will have same background colour

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        set statusline+=%{fugitive#statusline()} " Git Hotness
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set number                      " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set foldenable                  " Auto fold code
    set foldmethod=marker
    set foldlevelstart=10           " Open most folds by default
    set list
    set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
    set modelines=1

" }

" Formatting {

    set nowrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)

    set nocursorline
    set relativenumber

" }

" Key mapping {

    let mapleader = ','

    " Easier moving in tabs and windows
    map <C-J> <C-W>j
    map <C-K> <C-W>k
    map <C-H> <C-W>h
    map <C-L> <C-W>l

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " turn off surch highlighting
    nnoremap <leader>. :nohlsearch<CR>

    nmap <F8> :TagbarToggle<CR>

    " move to beginning/end of line
    nnoremap B ^
    nnoremap E $

    nmap <leader>l :set list!<CR>

    if has("user_commands")
        command! -bang -nargs=* -complete=file E e<bang> <args>
        command! -bang -nargs=* -complete=file W w<bang> <args>
        command! -bang -nargs=* -complete=file Wq wq<bang> <args>
        command! -bang -nargs=* -complete=file WQ wq<bang> <args>
        command! -bang Wa wa<bang>
        command! -bang WA wa<bang>
        command! -bang Q q<bang>
        command! -bang QA qa<bang>
        command! -bang Qa qa<bang>
    endif

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Code folding options
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null
    " Easier horizontal scrolling
    map zl zL
    map zh zH

" }

" Plugin Configuration

" Ctags {

    set tags=./tags;/,~/.vimtags

    " Make tags placed in .git/tags file available in all levels of a repository
    let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
    if gitroot != ''

        let &tags = &tags . ',' . gitroot . '/.git/tags'
    endif

" }

" NerdTree {

    if isdirectory(expand("~/.vim/bundle/nerdtree"))
        map <C-e> <plug>NERDTreeTabsToggle<CR>
        map <leader>e :NERDTreeFind<CR>
        nmap <leader>nt :NERDTreeFind<CR>

        let NERDTreeShowBookmarks=1
        let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
        let NERDTreeChDirMode=0
        let NERDTreeQuitOnOpen=1
        let NERDTreeMouseMode=2
        let NERDTreeShowHidden=1
        let NERDTreeKeepTreeInNewTab=1
        let g:nerdtree_tabs_open_on_gui_startup=0
    endif

" }
    
" GoLang {
    let g:go_highlight_functions = 1
    let g:go_highlight_methods = 1
    let g:go_highlight_structs = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_build_constraints = 1
    let g:go_fmt_command = "goimports"
    let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
    let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
    au FileType go nmap <Leader>s <Plug>(go-implements)
    au FileType go nmap <Leader>i <Plug>(go-info)
    au FileType go nmap <Leader>e <Plug>(go-rename)
    au FileType go nmap <leader>r <Plug>(go-run)
    au FileType go nmap <leader>b <Plug>(go-build)
    au FileType go nmap <leader>t <Plug>(go-test)
    au FileType go nmap <Leader>gd <Plug>(go-doc)
    au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
    au FileType go nmap <leader>co <Plug>(go-coverage)
" }

" TagBar {
    if isdirectory(expand("~/.vim/bundle/tagbar/"))
        nnoremap <silent> <leader>tt :TagbarToggle<CR>
    endif

" }

" Fugitive {

    if isdirectory(expand("~/.vim/bundle/vim-fugitive/"))
        nnoremap <silent> <leader>gs :Gstatus<CR>
        nnoremap <silent> <leader>gd :Gdiff<CR>
        nnoremap <silent> <leader>gc :Gcommit<CR>
        nnoremap <silent> <leader>gb :Gblame<CR>
        nnoremap <silent> <leader>gl :Glog<CR>
        nnoremap <silent> <leader>gp :Git push<CR>
        nnoremap <silent> <leader>gr :Gread<CR>
        nnoremap <silent> <leader>gw :Gwrite<CR>
        nnoremap <silent> <leader>ge :Gedit<CR>
        " Mnemonic _i_nteractive
        nnoremap <silent> <leader>gi :Git add -p %<CR>
        nnoremap <silent> <leader>gg :SignifyToggle<CR>
    endif

" }

" indent_guides {
    if isdirectory(expand("~/.vim/bundle/vim-indent-guides/"))
        let g:indent_guides_start_level = 2
        let g:indent_guides_guide_size = 1
        let g:indent_guides_enable_on_vim_startup = 1
    endif
" }

" UndoTree {

    if isdirectory(expand("~/.vim/bundle/undotree/"))
        nnoremap <Leader>u :UndotreeToggle<CR>
        " If undotree is opened, it is likely one wants to interact with it.
        let g:undotree_SetFocusWhenToggle=1
    endif

" }

" vim-airline {

    " See `:echo g:airline_theme_map` for some more choices
    " Default in terminal vim is 'dark'
    if isdirectory(expand("~/.vim/bundle/vim-airline/"))
        set laststatus=2               " enable airline even if no splits
        let g:airline_theme='luna'
        let g:airline_powerline_fonts=1
        let g:airline_enable_branch=1
        let g:airline_enable_syntastic=1
        let g:airline_powerline_fonts = 1
        let g:airline_linecolumn_prefix = '¶ '
        let g:airline_paste_symbol = 'ρ'
        let g:airline_paste_symbol = 'Þ'
        let g:airline_paste_symbol = '∥'
        let g:airline#extensions#tabline#enabled = 0
    endif

" }

" Rainbow {
    if isdirectory(expand("~/.vim/bundle/rainbow/"))
        let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
    endif
"}

" NeoComplete {

    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0
    " Use neocomplete.
    let g:neocomplete#enable_at_startup = 1
    " Use smartcase.
    let g:neocomplete#enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 4
    let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
    " Set minimum characters before completion
    let g:neocomplete#auto_completion_start_length = 3
    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries = {
        \ 'default' : '',
        \ 'vimshell' : $HOME.'/.vimshell_hist',
        \ 'scheme' : $HOME.'/.gosh_completions'
            \ }

    " Define keyword.
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " Plugin key-mappings.
    inoremap <expr><C-g>     neocomplete#undo_completion()
    inoremap <expr><C-l>     neocomplete#complete_common_string()

    " Recommended key-mappings.
    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
      return neocomplete#close_popup() . "\<CR>"
      " For no inserting <CR> key.
      "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
    endfunction
    " <TAB>: completion.
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y>  neocomplete#close_popup()
    inoremap <expr><C-e>  neocomplete#cancel_popup()
    " Close popup by <Space>.
    "inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

    " Enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
      let g:neocomplete#sources#omni#input_patterns = {}
    endif

    " For perlomni.vim setting.
    " https://github.com/c9s/perlomni.vim
    let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.cs = '.*[^=\);]'

" }

" NeoSnippets {

    " Plugin key-mappings.
    imap <C-k>     <Plug>(neosnippet_expand_or_jump)
    smap <C-k>     <Plug>(neosnippet_expand_or_jump)
    xmap <C-k>     <Plug>(neosnippet_expand_target)

    " SuperTab like snippets behavior.
    imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
    \ "\<Plug>(neosnippet_expand_or_jump)"
    \: pumvisible() ? "\<C-n>" : "\<TAB>"
    smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
    \ "\<Plug>(neosnippet_expand_or_jump)"
    \: "\<TAB>"

    " For snippet_complete marker.
    if has('conceal')
    set conceallevel=2 concealcursor=niv
    endif

" }

" CTRL-P {

    let g:ctrlp_map = '<C-p>'
    let g:ctrlp_cmd = 'CtrlP'
    let g:ctrlp_working_path_mode = 'ra'

" }

" Python-mode {
    " Activate rope
    " Keys:
    " P             Show python docs
    " <Ctrl-Space>  Rope autocomplete
    " <Ctrl-c>g     Rope goto definition
    " <Ctrl-c>d     Rope show documentation
    " <Ctrl-c>f     Rope find occurrences
    " <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
    " [[            Jump on previous class or function (normal, visual, operator
    " modes)
    " ]]            Jump on next class or function (normal, visual, operator
    " modes)
    " [M            Jump on previous class or method (normal, visual, operator
    " modes)
    " ]M            Jump on next class or method (normal, visual, operator modes)
    let g:pymode_rope = 1

    " Documentation
    let g:pymode_doc = 1
    let g:pymode_doc_key = 'P'

    "Linting
    let g:pymode_lint = 1
    let g:pymode_lint_checker = "pyflakes,pep8"
    " Auto check on save
    let g:pymode_lint_write = 1

    " Support virtualenv
    let g:pymode_virtualenv = 1

    " Enable breakpoints plugin
    let g:pymode_breakpoint = 1
    let g:pymode_breakpoint_bind = '<leader>b'

    " syntax highlighting
    let g:pymode_syntax = 1
    let g:pymode_syntax_all = 1
    let g:pymode_syntax_indent_errors = g:pymode_syntax_all
    let g:pymode_syntax_space_errors = g:pymode_syntax_all


    " Don't autofold code
    let g:pymode_folding = 0

    let g:pymode_options_max_line_length=119

" }

" Functions {

    " Initialize directories
    function! InitializeDirectories()
        let parent = $HOME
        let prefix = 'vim'
        let dir_list = {
                    \ 'backup': 'backupdir',
                    \ 'views': 'viewdir',
                    \ 'swap': 'directory' }

        if has('persistent_undo')
            let dir_list['undo'] = 'undodir'
        endif

        let common_dir = parent . '/.' . prefix

        for [dirname, settingname] in items(dir_list)
            let directory = common_dir . dirname . '/'
            if exists("*mkdir")
                if !isdirectory(directory)
                    call mkdir(directory)
                endif
            endif
            if !isdirectory(directory)
                echo "Warning: Unable to create backup directory: " . directory
                echo "Try: mkdir -p " . directory
            else
                let directory = substitute(directory, " ", "\\\\ ", "g")
                exec "set " . settingname . "=" . directory
            endif
        endfor
    endfunction
    call InitializeDirectories()

    " Initialize NERDTree as needed
    function! NERDTreeInitAsNeeded()
        redir => bufoutput
        buffers!
        redir END
        let idx = stridx(bufoutput, "NERD_tree")
        if idx > -1
            NERDTreeMirror
            NERDTreeFind
            wincmd l
        endif
    endfunction

    " Strip whitespace
    function! StripTrailingWhitespace()
        " Preparation: save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " do the business:
        %s/\s\+$//e
        " clean up: restore previous search history, and cursor position
        let @/=_s
        call cursor(l, c)
    endfunction

    " Shell command
    function! s:RunShellCommand(cmdline)
        botright new

        setlocal buftype=nofile
        setlocal bufhidden=delete
        setlocal nobuflisted
        setlocal noswapfile
        setlocal nowrap
        setlocal filetype=shell
        setlocal syntax=shell

        call setline(1, a:cmdline)
        call setline(2, substitute(a:cmdline, '.', '=', 'g'))
        execute 'silent $read !' . escape(a:cmdline, '%#')
        setlocal nomodifiable
        1
    endfunction

    command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
    " e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %

" }

 " Filetype mappings {

    autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> if !exists('g:spf13_keep_trailing_whitespace') | call StripTrailingWhitespace() | endif
    autocmd FileType haskell,ruby setlocal expandtab shiftwidth=2 softtabstop=2
    autocmd FocusLost set number
    autocmd FocusGained set relativenumber

"    autocmd FileType c,cpp,java,go,php,javascript,python RainbowParenthesesToggleAll

    au BufRead,BufNewFile *.x68,*.X68,*.s,*.asm setlocal filetype=asm68k
    au FileType asm68k setlocal nospell

    augroup XML
        autocmd!
        autocmd FileType xml setlocal foldmethod=indent foldlevelstart=999 foldminlines=0
    augroup END

    augroup reload_vimrc
        autocmd!
        autocmd BufWritePost $MYVIMRC source $MYVIMRC
    augroup END

    " Python related
    autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent fileformat=unix
    let python_hightlight_all=1
    autocmd FileType python highlight Excess ctermbg=Black guibg=Black
    autocmd FileType python match Excess /\%120v.*/
    autocmd FileType python set nowrap

    au BufRead,BufNewFile *.scss set filetype=scss.css
    autocmd FileType scss set iskeyword+=-

" }

" vim:foldmethod=marker:foldlevel=0
