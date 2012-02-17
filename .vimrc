" == TJ's vimrc ==========================================================
" -- Bootstrap -----------------------------------------------------------
set nocompatible                "don't emulate vi's limitations
filetype off                    "required
let mapleader=','               "use , rather than default \ as leader
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
  " -- Bundles -----------------------------------------------------------
  " >> ':BundleInstall' in Vim or 'vim +BundleInstall +qall' on cmdline
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
  " -- from vimscripts ---------------------------------------------------
  Bundle 'L9'
  Bundle 'FuzzyFinder'
    highlight Pmenu guifg=whie guibg=blue ctermfg=white ctermbg=blue
  " -- finished bundle bootstrapping -------------------------------------
filetype plugin indent on       "required
" -- UI stuff ------------------------------------------------------------
" (this section needs work)
" set t_Co=256
" set bg=dark
" colorscheme solarized
" if has('gui_running')
"   let g:solarized_termcolors=256
" endif
" -- Basic stuff ---------------------------------------------------------
syntax on
set modelines=0                 "http://www.guninski.com/vim1.html
set rnu                         "add relative line numbers
set autoread                    "watch for file changes
set nocursorline                "want to see _ and diff between . & ,
set mouse=a                     "enable mouse if possible
set hidden                      "hide buffers
set title                       "let vim change terminal window's title
set ruler                       "show current cursor position
set linebreak
set nospell                     "programmers don't need spell correct
set vb t_vb=                    "disable visual bell
set noerrorbells
set backspace=indent,eol,start  "backspace between lines, etc
set whichwrap=b,s,h,l,<,>,[,]   "backspace && cursor keys wrap too
set history=1000                "how big the history buffer should be
set undolevels=1000             "how big the undo buffer should be
set wrap linebreak
set list listchars=tab:→\ ,trail:·
highlight SpecialKey term=standout ctermbg=yellow guibg=yellow
set showbreak=...
set guioptions-=T               "turn off needless toolbar on gvim/mvim
set showmatch                   "shows brace pairs
set matchpairs+=<:>             "match < and > as well
set dict=/usr/share/dict/words
" -- Cursor --------------------------------------------------------------
" set cursorline
" autocmd InsertEnter * highlight CursorLine guifg=white guibg=blue ctermfg=white ctermbg=blue
" autocmd InsertLeave * highlight CursorLine guifg=white guibg=darkblue ctermfg=white ctermbg=darkblue
" -- Indentation ---------------------------------------------------------
set tw=500 sw=2 sts=2
set expandtab
set smarttab                    "intelligent tab + backspace
set autoindent                  "use current indent level for next line
set smartindent                 "intelligent guess at next line's indent
" -- Filetype specifics --------------------------------------------------
  if has('autocmd')
  " -- PIG -------------------- requires ~/.vim/syntax/pig.vim, etc ------
    au BufNewFile,BufRead *.pig set filetype=pig syntax=pig
  " -- C + PYTHON --------------------------------------------------------
    au BufNewFile,BufRead *.py,*.pyw,*.c,*.h set sw=4 sts=4 ts=4
    au BufNewFile,BufRead *.py,*.pyw,*.c,*.h set ff=unix tw=79
  " -- Makefile ----------------------------------------------------------
    au BufRead,BufNewFile Makefile* set noexpandtab
  " -- npc ---------------------------------------------------------------
    au BufNewFile,BufRead *.npc set ff=unix
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
set hls                         "hilight search results
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
  " set statusline+=[%{GitBranch()}]
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
nnoremap ; :
cmap W w
cmap WQ wq
cmap wQ wq
cmap Q q
nnoremap Y y$
nnoremap j gj
nnoremap k gk
map  <C-h> <C-w>h
map  <C-j> <C-w>j
map  <C-k> <C-w>k
map  <C-l> <C-w>l
nmap <C-s> :w<CR>
nmap <silent> ,/ :nohls<CR>
set pastetoggle=<F2>            "don't do smart stuff when pasting buffer
cmap w!! w !sudo tee % > /dev/null
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
" ------------------------------------------------------------------------
endif
" ========================================================================
