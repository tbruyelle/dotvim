execute pathogen#infect()

"filetype off
"filetype plugin indent off
"set runtimepath+=$GOROOT/misc/vim
"autocmd BufWritePost *.go :silent Fmt

syntax on
filetype plugin indent on

"always show statusline
set laststatus=2
" Format the status line
set stl=[%n]\ %t%m%r%h\ %w%y%<\ \ Cwd:%r%{getcwd()}%h\ \ %=\ Enc:%{strlen(&fenc)?&fenc:'none'},%{&ff}\ \ Line:%l\,%c\/%L\ \[%P\]
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
"Open the relevant Godoc for the word under the cursor with <leader>gd or open it vertically with <leader>gv
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
au FileType go nmap gd <Plug>(go-def-split)
"go commands
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)


"au VimEnter * NERDTreeToggle
"au BufWritePost *.go silent! !ctags -R &

let g:godef_same_file_in_same_window=1

nmap <F3> :NERDTreeToggle<CR>
"nmap <F4> :TagbarToggle<CR>

" supertab use gocode
let g:SuperTabDefaultCompletionType = "context"

" enable mouse
set mouse=a

" 7 characters limit when j/k
set so=7

set relativenumber
set number

" Ctrl-j/k deletes blank line below/above, and Alt-j/k inserts.
"nnoremap <silent><C-j> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
"nnoremap <silent><C-k> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>
"nnoremap <silent><A-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
"nnoremap <silent><A-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>

" nnoremap <silent><C-j> m
" nnoremap <silent><C-k> m`:silent -g/\m^\s*$/d<CR>`
" nnoremap <silent><A-j> :set paste<CR>m`o<Esc>`
" nnoremap <silent><A-k> :set paste<CR>m`O<Esc>`
"
" `
" nnoremap <silent><C-j> m
" nnoremap <silent><C-k> m`:silent -g/\m^\s*$/d<CR>`
" nnoremap <silent><A-j> :set paste<CR>m`o<Esc>`
" nnoremap <silent><A-k> :set paste<CR>m`O<Esc>`
"
" `
"Gotags config
"let g:tagbar_type_go = {
"    \ 'ctagstype' : 'go',
"    \ 'kinds'     : [
"        \ 'p:package',
"        \ 'i:imports:1',
"        \ 'c:constants',
"        \ 'v:variables',
"        \ 't:types',
"        \ 'n:interfaces',
"        \ 'w:fields',
"        \ 'e:embedded',
"        \ 'm:methods',
"        \ 'r:constructor',
"        \ 'f:functions'
"    \ ],
"    \ 'sro' : '.',
"    \ 'kind2scope' : {
"        \ 't' : 'ctype',
"        \ 'n' : 'ntype'
"    \ },
"    \ 'scope2kind' : {
"        \ 'ctype' : 't',
"        \ 'ntype' : 'n'
"    \ },
"    \ 'ctagsbin'  : 'gotags',
"    \ 'ctagsargs' : '-sort -silent'
"    \ }
