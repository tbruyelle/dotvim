call plug#begin()
"Plug 'fatih/vim-go' ", {'do': ':GoUpdateBinaries'}
Plug 'govim/govim' ", {'do': ':GoUpdateBinaries'}
"Plugin 'stamblerre/gocode', {'rtp': 'nvim/'} " I changed my gocode for supporting go modules.
Plug 'ervandew/supertab'
"Plug 'Townk/vim-autoclose'
Plug 'mileszs/ack.vim'
Plug 'fatih/molokai'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'SirVer/ultisnips'
Plug 'jparise/vim-graphql'
"Plug 'Valloric/YouCompleteMe'
call plug#end()

" highlight line and column
hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>

" ctrlp works in working dir
let g:ctrlp_working_path_mode = 0

let g:ycm_complete_in_comments = 1
"let g:ycm_auto_trigger = 0
let g:ycm_min_num_of_chars_for_completion=1
" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
"let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
"let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" Colorscheme
syntax enable
set t_Co=256
let g:rehash256 = 1
let g:molokai_original = 1
colorscheme molokai

"gvim setup
set gfn="Monospace 11"
set guioptions-=m
set guioptions-=T

"ack setup, replace with ag
let g:ackprg = 'ag --vimgrep'

"cnext/cprevious mapping on location
map <C-Left> :bp<CR>
map <C-Right> :bn<CR>
"cnext/cprevious mapping on location
map <C-Down> :lnext<CR>
map <C-Up> :lprevious<CR>
"close location mapping
nnoremap <leader>q :lclose<CR>
"cnext/cprevious mapping on quickfix
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
"close quickfix mapping
nnoremap <leader>a :cclose<CR>
" show filepath
nnoremap <leader>f :echo @%<CR>

"filetype off
"set runtimepath+=$GOROOT/misc/vim
"autocmd BufWritePost *.go :silent Fmt

set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

filetype plugin indent on

au BufRead,BufNewFile *.vugu set filetype=html

" Markdown config
au BufRead,BufNewFile *.md set filetype=markdown
au FileType markdown setl tw=79

au BufRead,BufNewFile mail setl tw=72

set noswapfile
set backspace=2
"always show statusline
set laststatus=2
" Format the status line
set stl=[%n]\ %t%m%r%h\ %w%y%<\ \ Cwd:%r%{getcwd()}%h\ \ %=\ Enc:%{strlen(&fenc)?&fenc:'none'},%{&ff}\ \ Line:%l\,%c\/%L\ \[%P\]\ %o
" Bubble single lines
nmap <C-K> ddkP
nmap <C-J> ddp
" Smart way to move between windows
nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-h> <C-W>h
nmap <C-l> <C-W>l

"vim-go mappings
"show go-info under cursor0
let g:go_auto_type_info = 0
let g:go_fmt_command = "goimports"
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_rename_command='gopls'
"let g:go_fmt_options = "-s"

"Open the relevant Godoc for the word under the cursor with <leader>gd or open it vertically with <leader>gv
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>i <Plug>(go-info)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
au FileType go nmap gd <Plug>(go-def-split)
"go commands
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>I <Plug>(go-install)
au FileType go nmap <leader>c <Plug>(go-callers)
au FileType go nmap <leader>r <Plug>(go-referrers)
nmap <Leader>d :GoDeclsDir<cr>

" go huiglights
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_auto_sameids = 0

let g:godef_same_file_in_same_window=0

" supertab use gocode
let g:SuperTabDefaultCompletionType = "context"

" enable mouse
set mouse=a

" 7 characters limit when j/k
set so=7

set relativenumber
set number

" To get hover working in the terminal we need to set ttymouse. See
"
" :help ttymouse
"
" for the appropriate setting for your terminal. Note that despite the
" automated tests using xterm as the terminal, a setting of ttymouse=xterm
" does not work correctly beyond a certain column number (citation needed)
" hence we use ttymouse=sgr
set ttymouse=sgr

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
