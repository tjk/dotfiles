" == TJ's vimrc ==========================================================
" -- Bootstrap + pathogen ------------------------------------------------
let g:CSApprox_verbose_level=0
filetype on
filetype off
set t_Co=256
set bg=dark
colorscheme solarized
if has('gui_running')
  let g:solarized_termcolors=256
endif
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
" -- Basic stuff ---------------------------------------------------------
set nocompatible                "don't emulate vi's limitations
syntax on
let mapleader=','               "use , rather than default \ as leader
set modelines=0                 "http://www.guninski.com/vim1.html
set number                      "add line numbers
set autoread                    "watch for file changes
set cursorline
set hidden                      "hide buffers
set ruler                       "show current cursor position
set linebreak
set vb t_vb=                    "disable visual bell
set backspace=indent,eol,start  "backspace between lines, etc
set history=1000                "how big the history buffer should be
set wrap linebreak nolist
set showbreak=...
set guioptions-=T               "turn off needless toolbar on gvim/mvim
set showmatch                   "shows brace pairs
set matchpairs+=<:>             "match < and > as well
set dict=/usr/share/dict/words
" -- Indentation ---------------------------------------------------------
set tw=500 sw=2 sts=2
set expandtab
set smarttab                    "intelligent tab + backspace
set autoindent                  "use current indent level for next line
set smartindent                 "intelligent guess at next line's indent
" -- Filetype specifics --------------------------------------------------
filetype on
filetype plugin on
filetype indent on
  if has('autocmd')
  " -- PIG -------------------- requires ~/.vim/syntax/pig.vim, etc ------
    au BufNewFile,BufRead *.pig set filetype=pig syntax=pig
  " -- C + PYTHON --------------------------------------------------------
    au BufNewFile,BufRead *.py,*.pyw,*.c,*.h set sw=4 sts=4 ts=4
    au BufNewFile,BufRead *.py,*.pyw,*.c,*.h set ff=unix tw=79
  " -- Makefile ----------------------------------------------------------
    au BufRead,BufNewFile Makefile* set noexpandtab
  endif
" -- Offscren scrolling --------------------------------------------------
set scrolloff=3
set sidescrolloff=7
set sidescroll=1
" -- Marking bad whitespace ----------------------------------------------
highlight BadWhitespace ctermbg=red guibg=red
if has('autocmd')
  au BufNewFile,BufRead *.py,*.pyw match BadWhitespace /^\t\+/
  au BufNewFile,BufRead *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
endif
" -- Searching -----------------------------------------------------------
set incsearch                   "find the next match as we type the search
set ignorecase
set nohls                       "don't hilight search results
" -- Folding -------------------------------------------------------------
set foldmethod=indent           "fold based on indent
set foldnestmax=3               "deepest fold is 3 levels
set nofoldenable                "dont fold by default
" -- Stuff at bottom -----------------------------------------------------
set showcmd                     "show incomplete cmds down the bottom
set cmdheight=2
set showmode                    "show mode all the time
set wildmenu                    "ctrl-n and ctrl-p to scroll thru matches
set wildmode=list:longest       "cmdline tab completion similar to bash
set wildignore=*.o,*.obj,*~     "stuff to ignore when tab completing
set statusline=%f               "tail of the filename
  " -- Git ---------------------------------------------------------------
  set statusline+=[%{GitBranch()}]
  set formatoptions-=o          "dont continue comments when pushing o/O
  " -- rvm ---------------------------------------------------------------
  set statusline+=%{exists('g:loaded_rvm')?rvm#statusline():''}
  " ----------------------------------------------------------------------
set statusline+=%=              "left/right separator
set statusline+=%c,             "cursor column
set statusline+=%l/%L           "cursor line/total lines
set statusline+=\ %P            "percent through file
set laststatus=2
" -- Key mappings --------------------------------------------------------
map  <C-h> <C-w>h               "left  window
map  <C-j> <C-w>j               "down  window
map  <C-k> <C-w>k               "up    window
map  <C-l> <C-w>l               "right window
nmap <C-s> :w<CR>               "save file
nnoremap Y y$                   "make y behave similarly to d or c
" -- Plugins -------------------------------------------------------------
  " -- NERDTree ----------------------------------------------------------
  let NERDTreeWinPos="left"
  let NERDTreeWinSize=35
  silent! nmap <silent> <Leader>p :NERDTreeToggle<CR>
" -- Autocmd functions ---------------------------------------------------
if has('autocmd')
  au BufReadPost * call SetCursorPosition()
  function! SetCursorPosition()
    if &filetype !~ 'commit\c'
      if line("'\"") > 0 && line("'\"") <= line("$")
        exe "normal! g`\""
        normal! zz
      endif
    end
  endfunction
" ------------------------------------------------------------------------
  au BufWritePre * :call <SID>StripTrailingWhitespaces()
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
endif
" ------------------------------------------------------------------------
" == Last updated: July 23, 2011 =========================================
