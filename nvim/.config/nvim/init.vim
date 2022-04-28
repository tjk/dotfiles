"let g:coc_node_args = ['--nolazy', '--inspect=6045']
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
let mapleader=','
filetype off " is this still necessary?
call plug#begin(stdpath('data') . '/plugged')
Plug 'altercation/vim-colors-solarized'
  syntax enable
  set background=light
Plug 'neoclide/coc.nvim', {'branch': 'release'}
  let g:coc_global_extensions = [
  \   'coc-css',
  \   'coc-diagnostic',
  \   'coc-emmet',
  \   'coc-eslint',
  \   'coc-git',
  \   'coc-go',
  \   'coc-html',
  \   'coc-json',
  \   'coc-lists',
  \   'coc-solargraph',
  \   'coc-yaml',
  \   'https://github.com/rodrigore/coc-tailwind-intellisense',
  \   'coc-tsserver',
  \   '@yaegassy/coc-volar',
  \ ]
  silent! nmap <silent> <leader>F :CocList<CR>
  silent! nmap <silent> <leader>f :CocList files<CR>
  silent! nmap <silent> <leader>g :CocList grep<CR>
  silent! nmap <silent> <leader>m :CocList mru<CR>
  silent! nmap <silent> <leader>d :CocList diagnostics<CR>
  silent! nmap <silent> <C-p> :CocList files<CR>
  " Remap for do codeAction of current line
  nmap <leader>a  <Plug>(coc-codeaction)
  " Fix autofix problem of current line
  nmap <leader>qf  <Plug>(coc-fix-current)
  "let g:ruby_host_prog='~/.rbenv/shims/neovim-ruby-host'
  let ruby_spellcheck_strings=1
  let g:python_host_prog='/Users/tj/.asdf/shims/python'
  let g:python3_host_prog='/usr/local/bin/python3'
  " https://github.com/neoclide/coc.nvim/issues/1775#issuecomment-757764053
  let g:coc_disable_transparent_cursor = 1
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
  let NERDTreeWinPos="left"
  let NERDTreeWinSize=30
  let NERDTreeIgnore=['\.pyc$', '\.gcov$', '\.gcda$', '\.gcno$']
  "autocmd vimenter * NERDTree
  silent! nmap <silent> <leader>p :NERDTreeToggle %<CR>
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-sleuth' " put this after vim-polyglot
" Plug 'sgur/vim-editorconfig' " after other two indentation plugins
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
call plug#end()
colorscheme solarized
filetype plugin indent on
""" basic stuff
syntax on
set number relativenumber       "hybrid
set autoread                    "watch for file changes
set nocursorline                "want to see _ and diff between . & ,
set mouse=a                     "enable mouse if possible
set mousehide                   "hide mouse while characters are typed
set scrolloff=8
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
"set directory=~/.vim/swap,.     "all swap files in one place
set clipboard=unnamed           "yank/delete to system clipboard by default
" TODO denite allows finding by string as well... consider replace LeaderF?
set grepprg=rg\ --vimgrep\ $*
set grepformat=%f:%l:%c:%m
" automatically open quickfix window
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow
" automatically close quickfixlist when select
autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>
""" coc.nvim recommended settings
" if hidden is not set, TextEdit might fail.
set hidden
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup
" Better display for messages
set cmdheight=2
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" Highlight symbol under cursor on CursorHold
" XXX SLOW? -- autocmd CursorHold * silent call CocActionAsync('highlight')
" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)
" Remap for format selected region
"xmap <leader>f  <Plug>(coc-format-selected)
"nmap <leader>f  <Plug>(coc-format-selected)
augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  " XXX SLOW? -- autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
"xmap <leader>a  <Plug>(coc-codeaction-selected)
"nmap <leader>a  <Plug>(coc-codeaction-selected)
" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)
" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)
" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')
" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
""" keybindings
nnoremap ; :
"allow navigating through long lines that span multiple rows (unless count)
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
"improve movement through windows by removing a keystroke
map  <C-h> <C-w>h
map  <C-j> <C-w>j
map  <C-k> <C-w>k
map  <C-l> <C-w>l
" ease opening and sourcing the vimrc
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>
nmap <silent> <leader>ec :CocConfig<CR>
"clear highlighted search results
noremap <silent> <leader>/ :silent nohls<CR>
"force save when opened while !root
cmap w!! w !sudo tee % > /dev/null
""" delete end of line whitespace
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
"autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
