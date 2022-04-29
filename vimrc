call plug#begin('~/.vim/plugged')
"Plug 'fatih/vim-go' ", {'do': ':GoUpdateBinaries'}
Plug 'govim/govim'
Plug 'jjo/vim-cue'
"Plugin 'stamblerre/gocode', {'rtp': 'nvim/'} " I changed my gocode for supporting go modules.
Plug 'ervandew/supertab'
"Plug 'Townk/vim-autoclose'
Plug 'mileszs/ack.vim'
Plug 'fatih/molokai'
"Plug 'ctrlpvim/ctrlp.vim'
Plug 'SirVer/ultisnips'
Plug 'tpope/vim-fugitive'
"Plug 'jparise/vim-graphql'
call plug#end()

" Colorscheme
syntax enable
set t_Co=256
let g:rehash256 = 1
let g:molokai_original = 1
colorscheme molokai
set colorcolumn=80

" edit vimrc
nnoremap <Leader>ev :vsplit $MYVIMRC<cr>
nnoremap <Leader>sv :source $MYVIMRC<cr>

" git
nnoremap <Leader>gc :G commit -a<cr>
nnoremap <Leader>gp :G push -u<cr>
nnoremap <Leader>gd :G diff<cr>
nnoremap <Leader>ga :G add -A<cr>
nnoremap <Leader>gs :G status -sb<cr>
nnoremap <Leader>gr :G rebase --continue<cr>


" Fuzzy finder
nnoremap <C-p> :FZF<cr>

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

" highlight line and column
hi CursorLine   cterm=NONE ctermbg=black  guibg=black
hi CursorColumn cterm=NONE ctermbg=black  guibg=black
nnoremap <Leader>x :set cursorline! cursorcolumn!<CR>

" highlight diffs
hi DiffAdd ctermfg=NONE ctermbg=green guifg=#dadada guibg=#3a3a3a
hi DiffDelete ctermfg=NONE ctermbg=red guifg=#dadada guibg=#3a3a3a
hi DiffChange ctermfg=none ctermbg=237 guifg=#dadada guibg=#3a3a3a
hi DiffText ctermfg=none ctermbg=none guifg=#dadada guibg=#3a3a3a

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
au FileType go nmap <leader>rr :GOVIMRename<cr>
au FileType go nmap <leader>b :GOVIMQuickfixDiagnostics<cr>
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>I <Plug>(go-install)
au FileType go nmap <leader>rf :GOVIMReferences<cr>
"au FileType go nmap <leader>r <Plug>(go-referrers)
nmap <Leader>d :GoDeclsDir<cr>
"call govim#config#Set("ExperimentalProgressPopups", 1)
"call govim#config#Set("Gofumpt", 1)

" \cc display the current buffer in qf list
nnoremap <Leader>cc :call BufferQF()<cr>
function BufferQF()
  let name = escape(bufname(), "/")
  execute "copen"
  execute "normal /" . name . ""
  execute "cr " . line(".")
endfunction

" \qq feed the qf with conflicted files
nnoremap <Leader>qq :call ConflictToQF()<cr>
function ConflictToQF()
  let files = system("git diff --name-only --diff-filter=U")
  if files == ""
    echo "no conflits detected"
    return
  endif
  let qf = []
  for file in split(files, "\n")
    " try to get the conflict line number
    let line = system("grep -n '<<<' ".file." | cut -f1 -d:")
    " append to qf list
    call add(qf,{'filename':file, 'lnum':line})
  endfor
  "echo qf
  call setqflist(qf)
  execute "copen"
  execute "cc"
endfunction

nnoremap <C-\> 0wi//<space><esc>j
vnoremap <C-\> 0I//<space><esc>
"nnoremap <expr> <C-\> stridx(getline(.), '//')==-1 ? '<C-]>' : '<C-[>'

" C-r ask input for  a replacement of selected text
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" /-- write a comment separator
nnoremap <Leader>-- O<esc>O//-----------------------------------------<cr>// 

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
iabbrev KE keen-eye-technologies.com

au FileType go :iabbrev pln fmt.Println("
au FileType go :iabbrev pfn fmt.Printf("

" jk to <esc>
inoremap jk <esc>
"inoremap <esc> <nop>

