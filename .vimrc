" == TJ's vimrc ==========================================================
" -- Bootstrap -----------------------------------------------------------
set nocompatible                "don't emulate vi's limitations
filetype off                    "required
let mapleader=','               "use , rather than default \ as leader
set rtp+=~/.vim/bundle/vundle/  "add to vim runtime path
call vundle#rc()                "sets up vundle for bundle management
  " -- Bundles -----------------------------------------------------------
  " >> set the bundles up by running the following two commands in shell
  " $ git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
  " $ vim +BundleInstall +qall
  " Vundle doesn't accept comments on same line -- Vundle manages itself
  " -- from github -------------------------------------------------------
  Bundle 'gmarik/vundle'
  Bundle 'scrooloose/nerdtree'
    let NERDTreeWinPos="left"
    let NERDTreeWinSize=35
    let NERDTreeIgnore=['\.pyc$']
    silent! nmap <silent> <Leader>p :NERDTreeToggle<CR>
  Bundle 'Lokaltog/vim-powerline'
    let g:Powerline_symbols = 'fancy'
  Bundle 'ervandew/supertab'
  Bundle 'mattn/zencoding-vim'
  Bundle 'tpope/vim-rails'
    command! -bar -nargs=1 OpenURL :!chromium <args>
  Bundle 'altercation/vim-colors-solarized'
    set background=dark
    colorscheme solarized
    command! Dark :set background=dark | colorscheme solarized
    command! Light :set background=light | colorscheme solarized
  Bundle 'tpope/vim-surround'
  Bundle 'tpope/vim-markdown'
  Bundle 'tpope/vim-fugitive'
  Bundle 'depuracao/vim-rdoc'
  Bundle 'vim-ruby/vim-ruby'
  Bundle 'kien/ctrlp.vim'
  Bundle 'xolox/vim-notes'
    let g:notes_directory = '~/notes'
  Bundle 'vim-scripts/Tab-Name'
  Bundle 'vim-scripts/L9'
  " -- finished bundle bootstrapping -------------------------------------
filetype plugin indent on       "required
" -- Basic stuff ---------------------------------------------------------
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
set vb t_vb=                    "disable visual bell
set noerrorbells
set backspace=indent,eol,start  "backspace between lines, etc
set whichwrap=b,s,h,l,<,>,[,]   "backspace && cursor keys wrap too
set history=1000                "how big the history buffer should be
set undolevels=1000             "how big the undo buffer should be
set wrap linebreak
set wrapscan                    "search wraps around eof
set list listchars=tab:→\ ,trail:·
highlight SpecialKey term=standout ctermbg=yellow guibg=yellow
set showbreak=...
set guioptions-=T               "turn off needless toolbar on gvim/mvim
set showmatch                   "shows brace pairs
set matchpairs+=<:>             "match < and > as well
set dict=/usr/share/dict/words
" -- Cursor --------------------------------------------------------------
":h termcap-cursor-shape
" if &term =~ "rxvt-unicode"
  " let &t_SI=""
  " let &t_EI=""
" endif
" -- Indentation ---------------------------------------------------------
set tw=500 sw=2 sts=2
set expandtab
set smarttab                    "intelligent tab + backspace
set autoindent                  "use current indent level for next line
set smartindent                 "intelligent guess at next line's indent
" -- Filetype specifics --------------------------------------------------
  if has('autocmd')
  " -- PIG -------------------- requires ~/.vim/syntax/pig.vim, etc ------
    au BufNewFile,BufRead *.pig set ft=pig syntax=pig
  " -- C + PYTHON --------------------------------------------------------
    au BufNewFile,BufRead *.py,*.pyw,*.c,*.h set sw=4 sts=4 ts=4
    au BufNewFile,BufRead *.py,*.pyw,*.c,*.h set ff=unix tw=79
  " -- Makefile ----------------------------------------------------------
    au BufRead,BufNewFile Makefile* set noexpandtab
  " -- npc ---------------------------------------------------------------
    au BufNewFile,BufRead *.npc set ff=unix
  endif
" -- Offscren scrolling --------------------------------------------------
set scrolloff=1
set sidescrolloff=7
set sidescroll=1
" -- Marking bad whitespace ----------------------------------------------
highlight BadWhitespace ctermbg=red guibg=red
if has('autocmd')
  au BufNewFile,BufRead *.py,*.pyw match BadWhitespace /^\t\+/
  au BufNewFile,BufRead *.py,*.pyw,*.c,*.h,*.hpp match BadWhitespace /\s\+$/
endif
" -- Searching -----------------------------------------------------------
set incsearch                   "find the next match as we type the search
set ignorecase
set hls                         "hilight search results
" -- Folding -------------------------------------------------------------
set foldmethod=indent           "fold based on indent
set foldnestmax=3               "deepest fold is 3 levels
set nofoldenable                "dont fold by default
" -- Command Line stuff --------------------------------------------------
set showcmd                     "show incomplete cmds down the bottom
set cmdheight=2
set showmode                    "show mode all the time
set wildchar=<Tab>              "use tab to autocomplete in command line
set wildmenu                    "ctrl-n and ctrl-p to scroll thru matches
set wildmode=list:longest       "cmdline tab completion similar to bash
set wildignore=*.o,*.obj,*~     "stuff to ignore when tab completing
"set statusline=%f               "tail of the filename
  " -- Git ---------------------------------------------------------------
  "set statusline+=%{fugitive#statusline()}
  set formatoptions-=o          "dont continue comments when pushing o/O
  " -- rvm ---------------------------------------------------------------
  "set statusline+=%{exists('g:loaded_rvm')?rvm#statusline():''}
  " ----------------------------------------------------------------------
"set statusline+=%=              "left/right separator
"set statusline+=%c,             "cursor column
"set statusline+=%l/%L           "cursor line/total lines
"set statusline+=\ %P            "percent through file
set laststatus=2
" -- Key mappings --------------------------------------------------------
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
"control+s save shortcut
nmap <C-s> :w<CR>
"easier buffer navigation
nnoremap <leader>b :buffers<CR>:buffer<Space>
"ease opening and sourcing the vimrc
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>
"make the current file executable
nmap <leader>x :w<CR>:!chmod +x %<CR>:e<CR>
"make a .vimsession file in current directory
nmap SQ <ESC>:mksession! .vimsession<CR>:wqa<CR>
nnoremap <leader>S ?{<CR>jV/^\s*\}?$<CR>k:sort<CR>:noh<CR>
"clear highlighted search results
noremap <silent> <leader>/ :silent nohls<CR>
set pastetoggle=<F2>
:map <F7> :w !xclip<CR><CR>
:vmap <F7> "*y
:map <S-F7> :r!xclip -o<CR>
"force save when opened while !root
cmap w!! w !sudo tee % > /dev/null
" -- Autocmd functions ---------------------------------------------------
if has('autocmd')
  function! SetCursorPosition()
    if &filetype !~ 'commit\c'
      if line("'\"") > 0 && line("'\"") <= line("$")
        exe "normal! g`\""
        normal! zz
      endif
    end
  endfunction
  au BufReadPost * call SetCursorPosition()
" ------------------------------------------------------------------------
  "" TODO map this -- don't want to mess up other people's style
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
  au BufWritePre * :call <SID>StripTrailingWhitespaces()
" ------------------------------------------------------------------------
  " .vimsession handling -------------------------------------------------
  function! RestoreSession()
    if argc() == 0 && filereadable('.vimsession')
      execute 'source .vimsession'
    end
  endfunction
  au VimEnter * call RestoreSession()
" ------------------------------------------------------------------------
endif
" ========================================================================
