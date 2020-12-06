call plug#begin()
"Plug 'https://git.sr.ht/~tbruyelle/mds'
"Plug '~/src/mds'
"Plug 'fatih/vim-go' ", {'do': ':GoUpdateBinaries'}
Plug 'govim/govim'
"Plugin 'stamblerre/gocode', {'rtp': 'nvim/'} " I changed my gocode for supporting go modules.
Plug 'ervandew/supertab'
"Plug 'Townk/vim-autoclose'
Plug 'mileszs/ack.vim'
Plug 'fatih/molokai'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'SirVer/ultisnips'
Plug 'jparise/vim-graphql'
call plug#end()

" Colorscheme
syntax enable
set t_Co=256
let g:rehash256 = 1
let g:molokai_original = 1
colorscheme molokai

" edit vimrc
nnoremap <Leader>ev :vsplit $MYVIMRC<cr>
nnoremap <Leader>sv :source $MYVIMRC<cr>

" goto file edits file
nnoremap gf :e <cfile><CR>

" force use hjkl
nnoremap <Up> <nop>
nnoremap <Down> <nop>
nnoremap <Left> <nop>
nnoremap <Right> <nop>
inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>

" format html on save
augroup write_html
  autocmd!
  autocmd BufWritePre *.html :normal gg=G ``
augroup END

augroup filetype_go
  autocmd!
  autocmd FileType go nnoremap <buffer> <localleader>c I//<esc>
augroup END

" highlight line and column
hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>

"cnext/cprevious mapping on location
map <C-Left> :bp<CR>
map <C-Right> :bn<CR>
"cnext/cprevious mapping on location
map <C-Down> :lnext<CR>
map <C-Up> :lprevious<CR>
"close location mapping
nnoremap <leader>q :lclose<CR>
"cnext/cprevious mapping on quickfix
noremap <C-l> :clast<CR>
noremap <C-n> :cnext<CR>
noremap <C-m> :cprevious<CR>
"close quickfix mapping
nnoremap <leader>a :cclose<CR>
" show filepath
nnoremap <leader>f :echo @%<CR>

set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set noswapfile
"always show statusline
set laststatus=2
" Format the status line
set stl=[%n]\ %t%m%r%h\ %w%y%<\ \ Cwd:%r%{getcwd()}%h\ \ %=\ Enc:%{strlen(&fenc)?&fenc:'none'},%{&ff}\ \ Line:%l\,%c\/%L\ \[%P\]\ %o

" enable mouse
set mouse=a

" 7 characters limit when j/k
set so=7

set relativenumber
set number


filetype plugin indent on

au BufRead,BufNewFile *.vugu set filetype=html

" Markdown config
au BufRead,BufNewFile *.md set filetype=markdown
au FileType markdown setl tw=79

au BufRead,BufNewFile mail setl tw=72

" Bubble single lines
"nmap <C-K> ddkP
"nmap <C-J> ddp
" Smart way to move between windows
nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-h> <C-W>h
nmap <C-l> <C-W>l

" ctrlp works in working dir
let g:ctrlp_working_path_mode = 0

" better key bindings for UltiSnipsExpandTrigger
"let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

"ack setup, replace with ag
let g:ackprg = 'ag --vimgrep'

" supertab use gocode
let g:SuperTabDefaultCompletionType = "context"


"Open the relevant Godoc for the word under the cursor with <leader>gd or open it vertically with <leader>gv
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
au FileType go nmap gd <Plug>(go-def-split)
"go commands
au FileType go nmap <leader>i :call GOVIMHover()<cr>
au FileType go nmap <leader>r :GOVIMRename<space>
au FileType go nmap <leader>b :cwindow<cr>
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>I <Plug>(go-install)
au FileType go nmap <leader>c <Plug>(go-callers)
au FileType go nmap <leader>r <Plug>(go-referrers)
nmap <Leader>d :GoDeclsDir<cr>

nnoremap <C-\> 0wi//<space><esc>
vnoremap <C-\> 0I//<space><esc>
"nnoremap <expr> <C-\> stridx(getline(.), '//')==-1 ? '<C-]>' : '<C-[>'

" To get hover working in the terminal we need to set ttymouse. See
"
" :help ttymouse
"
" for the appropriate setting for your terminal. Note that despite the
" automated tests using xterm as the terminal, a setting of ttymouse=xterm
" does not work correctly beyond a certain column number (citation needed)
" hence we use ttymouse=sgr
"set ttymouse=sgr

" Suggestion: By default, govim populates the quickfix window with diagnostics
" reported by gopls after a period of inactivity, the time period being
" defined by updatetime (help updatetime). Here we suggest a short updatetime
" time in order that govim/Vim are more responsive/IDE-like
set updatetime=500

" Suggestion: To make govim/Vim more responsive/IDE-like, we suggest a short
" balloondelay
set balloondelay=250

" Suggestion: Turn on the sign column so you can see error marks on lines
" where there are quickfix errors. Some users who already show line number
" might prefer to instead have the signs shown in the number column; in which
" case set signcolumn=number
set signcolumn=yes

" Suggestion: turn on auto-indenting. If you want closing parentheses, braces
" etc to be added, https://github.com/jiangmiao/auto-pairs. In future we might
" include this by default in govim.
set autoindent
set smartindent
filetype indent on

" Suggestion: define sensible backspace behaviour. See :help backspace for
" more details
set backspace=2

" Suggestion: show info for completion candidates in a popup menu
if has("patch-8.1.1904")
  set completeopt+=popup
  set completepopup=align:menu,border:off,highlight:Pmenu
endif

" abbrev
inoremap tgk #TG-romain-keen-eye-platform-
inoremap tgu #TG-romain-unicorn-
iabbrev KE keen-eye-technologies.com
