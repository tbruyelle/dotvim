execute pathogen#infect()
filetype off
filetype plugin indent off
set runtimepath+=$GOROOT/misc/vim
autocmd BufWritePost *.go :silent Fmt
filetype plugin indent on
syntax on
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
nnoremap <silent><C-j> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><C-k> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><A-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><A-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>

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
