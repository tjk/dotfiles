" == TJ's vimrc ===============================================================
" -- Bootstrap ----------------------------------------------------------------
set nocompatible                "don't emulate vi's limitations
filetype off                    "required
let mapleader=','               "use , rather than default \ as leader
set rtp+=~/.vim/bundle/vundle/  "add to vim runtime path
call vundle#rc()                "sets up vundle for bundle management
  " -- Bundles ----------------------------------------------------------------
  " >> set the bundles up by running the following two commands in shell
  " $ git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
  " $ vim +BundleInstall +qall
  " Vundle doesn't accept comments on same line -- Vundle manages itself
  " -- from github ------------------------------------------------------------
  Bundle 'gmarik/vundle'
  Bundle 'scrooloose/nerdtree'
    let NERDTreeWinPos="left"
    let NERDTreeWinSize=30
    let NERDTreeIgnore=['\.pyc$']
    silent! nmap <silent> <leader>p :NERDTreeToggle<CR>
  Bundle 'altercation/vim-colors-solarized'
    set background=dark
    colorscheme solarized
    command! Dark :set background=dark | colorscheme solarized
    command! Light :set background=light | colorscheme solarized
  Bundle 'Lokaltog/vim-powerline'
    let g:Powerline_symbols='fancy'
  Bundle 'Valloric/YouCompleteMe'
  Bundle 'ervandew/supertab'
  Bundle 'mattn/zencoding-vim'
  Bundle 'tpope/vim-rails'
    "TODO change this
    command! -bar -nargs=1 OpenURL :!chromium <args>
  Bundle 'tpope/vim-surround'
  Bundle 'tpope/vim-fugitive'
  Bundle 'kien/ctrlp.vim'
    let g:ctrlp_working_path_mode=2
  Bundle 'xolox/vim-session'
    let g:session_autoload='no'
    let g:session_autosave='no'
    map <leader>q :SaveSession<CR>:qall!<CR>
    map <leader>l :OpenSession<CR>
  Bundle 'vim-scripts/Tab-Name'
  Bundle 'vim-scripts/L9'
  Bundle 'aaronbieber/quicktask'
  Bundle 'scrooloose/nerdcommenter'
  " File types ----------------------------------------------------------------
  Bundle 'tpope/vim-markdown'
  Bundle 'tpope/vim-haml'
  Bundle 'tpope/vim-markdown'
  Bundle 'depuracao/vim-rdoc'
  Bundle 'derekwyatt/vim-scala'
  Bundle 'vim-ruby/vim-ruby'
  Bundle 'kchmck/vim-coffee-script'
  Bundle 'dag/vim2hs'
    let g:haddock_browser='/usr/bin/chromium'
    let g:ghc='/usr/bin/ghc'
  " -- finished bundle bootstrapping ------------------------------------------
filetype plugin indent on       "required
" -- Basic stuff --------------------------------------------------------------
syntax on
set modelines=0                 "http://www.guninski.com/vim1.html
set relativenumber              "add relative line numbers
set autoread                    "watch for file changes
set nocursorline                "want to see _ and diff between . & ,
set mouse=a                     "enable mouse if possible
set mousehide                   "hide mouse while characters are typed
set hidden                      "hide buffers
set title                       "let vim change terminal window's title
set ruler                       "show current cursor position
set nospell                     "programmers don't need spell correct
set vb t_vb=                    "disable beep AND visual bell
set backspace=indent,eol,start  "backspace between lines, etc
set whichwrap=b,s,h,l,<,>,[,]   "backspace && cursor keys wrap too
set history=1000                "how big the history buffer should be
set undolevels=1000             "how big the undo buffer should be
set wrap linebreak
set wrapscan                    "search wraps around eof
set list listchars=tab:→\ ,trail:·
set showbreak=...
set showmatch                   "shows brace pairs
set matchpairs+=<:>             "match < and > as well
set dict=/usr/share/dict/words
set showtabline=2               "always visible tabline
set directory=~/.vim/swap,.     "all swap files in one place
" -- Cursor -------------------------------------------------------------------
"TODO
":h termcap-cursor-shape
" if &term =~ "rxvt-unicode"
  " let &t_SI=""
  " let &t_EI=""
" endif
" -- Indentation --------------------------------------------------------------
set tw=79 sw=2 sts=2
set expandtab
set smarttab                    "intelligent tab + backspace
set autoindent                  "use current indent level for next line
set smartindent                 "intelligent guess at next line's indent
" -- Offscren scrolling -------------------------------------------------------
set scrolloff=1
set sidescrolloff=7
set sidescroll=1
" -- Searching ----------------------------------------------------------------
set incsearch                   "find the next match as we type the search
set ignorecase
set smartcase
set hlsearch                    "hilight search results
" -- Folding ------------------------------------------------------------------
set foldmethod=indent           "fold based on indent
set foldnestmax=3               "deepest fold is 3 levels
set nofoldenable                "dont fold by default
" -- Command Line stuff -------------------------------------------------------
set showcmd                     "show incomplete cmds down the bottom
set cmdheight=2
set showmode                    "show mode all the time
set wildchar=<Tab>              "use tab to autocomplete in command line
set wildmenu                    "ctrl-n and ctrl-p to scroll thru matches
set wildmode=list:longest       "cmdline tab completion similar to bash
set wildignore=*.o,*.obj,*~     "stuff to ignore when tab completing
set formatoptions-=o            "dont continue comments when pushing o/O
set laststatus=2                "always show status bar
" -- Key mappings -------------------------------------------------------------
"" careful about comments in this section as they mess up map commands
nnoremap ; :
cmap W w
cmap WQ wq
cmap wQ wq
cmap Q q
nnoremap Y y$
"allow navigating through long lines that span multiple rows
nnoremap j gj
nnoremap k gk
"improve movement through windows by removing a keystroke
map  <C-h> <C-w>h
map  <C-j> <C-w>j
map  <C-k> <C-w>k
map  <C-l> <C-w>l
"easier buffer navigation
nnoremap <leader>b :buffers<CR>:buffer<Space>
"TODO C-tab doesn't work (interecepted by urxvt)
nmap <C-tab> :bn<CR>
imap <C-tab> <ESC>:bn<CR>i
"ease opening and sourcing the vimrc
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>
"make the current file executable
nmap <leader>x :w<CR>:!chmod +x %<CR>:e<CR>
"clear highlighted search results
noremap <silent> <leader>/ :silent nohls<CR>
set pastetoggle=<F2>
map <F7> :w !xclip<CR><CR>
vmap <F7> "*y
map <S-F7> :r!xclip -o<CR>
"force save when opened while !root
cmap w!! w !sudo tee % > /dev/null
"note taking
map <leader>n :e! ~/notes<CR>
" -- Autocmd functions --------------------------------------------------------
if has("autocmd")
  function! SetCursorPosition()
    if &filetype !~ 'commit\c'
      if line("'\"") > 0 && line("'\"") <= line("$")
        exe "normal! g`\""
        normal! zz
      endif
    end
  endfunction
  autocmd BufReadPost * call SetCursorPosition()
  " ---------------------------------------------------------------------------
  function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
  endfunction
  "" TODO map this -- don't want to mess up other people's style
  autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
  " ---------------------------------------------------------------------------
  "" TODO surround in if clause -- if in rxvt
  command! -bar -nargs=1 FSize :! sh printf '\33]50;%s%d\007'
    \ "xft:incosolata\ for\ Powerline:antialias=true:size=" <q-args>
  noremap + :FSize 14<CR>
  noremap - :FSize 11<CR>
  " ---------------------------------------------------------------------------
  augroup FTMisc
    autocmd!
    autocmd BufReadPre *.pdf         setlocal binary
  augroup END
  " ---------------------------------------------------------------------------
  augroup FTOptions
    autocmd!
    autocmd FileType make            setlocal noexpandtab
    autocmd FileType c,cpp,cs,java   setlocal ai et sta sw=4 sts=4 cin
    autocmd FileType sh,csh,tcsh,zsh setlocal ai et sta sw=4 sts=4
    autocmd FileType sh,csh,tcsh,zsh
      \ inoremap <silent><buffer> <leader>! #!/bin/<C-R>=&ft<CR>
    autocmd FileType markdown,liquid setlocal ai et sta sw=2 sts=2 tw=72
    autocmd FileType javascript      setlocal ai et sta sw=2 sts=2
                                       \ ts=2 cin isk+=$
    autocmd FileType tex,css         setlocal ai et sta sw=2 sts=2
    autocmd FileType html,xhtml      setlocal ai et sta sw=2 sts=2
    autocmd FileType yaml,ruby       setlocal ai et sta sw=2 sts=2
    autocmd FileType perl,python,ruby
      \ inoremap <silent><buffer> <leader>! #!/usr/bin/env <C-R>=&ft<CR>
    autocmd FileType help            setlocal ai fo+=2n |
                                       \ silent! setlocal nospell
    autocmd FileType help nnoremap <silent><buffer> q :q<CR>
  augroup END
  " ---------------------------------------------------------------------------
endif
" =============================================================================
