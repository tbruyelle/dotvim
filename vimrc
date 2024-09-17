call plug#begin('~/.vim/plugged')
Plug 'govim/govim'
Plug 'junegunn/fzf.vim'
Plug 'prabirshrestha/vim-lsp'
"Plugin 'stamblerre/gocode', {'rtp': 'nvim/'} " I changed my gocode for supporting go modules.
Plug 'ervandew/supertab'
"Plug 'Townk/vim-autoclose'
Plug 'mileszs/ack.vim'
" some colors
Plug 'fatih/molokai'
Plug 'joeytwiddle/vim-diff-traffic-lights-colors'
Plug 'karoliskoncevicius/oldbook-vim'
"Plug 'ctrlpvim/ctrlp.vim'
Plug 'SirVer/ultisnips'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
" GDiff {rev} for code review
Plug 'oguzbilgic/vim-gdiff'
" fzf for checkout git branches
Plug 'stsewd/fzf-checkout.vim'
"Plug 'jparise/vim-graphql'
Plug 'tarekbecker/vim-yaml-formatter'
" Zen mode, turn on with :Goyo
Plug 'junegunn/goyo.vim'
Plug 'inkarkat/vim-SyntaxRange'
Plug 'thinca/vim-themis'
call plug#end()

" Colorscheme
syntax enable
set t_Co=256
let g:rehash256 = 1
let g:molokai_original = 1
colorscheme molokai
set colorcolumn=80
let g:markdown_fenced_languages = ['go', 'bash=sh', 'vim']
if &diff
	colorscheme traffic_lights_diff
	"colorscheme oldbook
endif
"set term=kitty

" json tab format
autocmd Filetype json setlocal tabstop=2 shiftwidth=2 expandtab

" txtar syntax hl
function s:TxTarHighlight(...)
  highlight Mine ctermfg=236 ctermbg=150 guifg=#303030 guibg=#afd787
  call SyntaxRange#IncludeEx('start="\%^" end="^\ze-- .* --$" containedin=ALL keepend', 'bash')
  let files = [
        \ [["markdown", "md"], "markdown"],
        \ [["go"], "go"],
        \ [["gno"], "go"],
        \ [["mod"], "gomod"],
        \ [["sh", "bash"], "bash"],
        \ [["json"], "json"],
        \]
  for f in files
    call SyntaxRange#IncludeEx('matchgroup=Mine start="^-- .*\.\('.join(f[0],'\|').'\)\(\.golden\)\? --$" end="^\ze-- .* --$" containedin=ALL keepend', f[1])

  endfor
  syntax match Mine '^-- .* --$' containedin=ALL
  setlocal commentstring=#%s
endfunction

function s:TxTarGoFmt()
	" Save the current cursor position
	let save_cursor = getpos('.')
	normal gg

	let start_pattern = '^-- \S\+\.\(go\|gno\)'
	let end_pattern = '^-- '
	let start_line=1

	while start_line != 0 
		" Search for start pattern and get the line number
		let start_line = search(start_pattern, 'W')
		if start_line != 0
			" Search for end pattern after the start line and get the line number
			let end_line = search(end_pattern, 'Wn')
			if end_line == 0
				" if no match, use the last line, it's probably the last file
				let end_line = line('$')
			else
				let end_line=end_line-1
			endif
			call GoFmtLines(start_line+1, end_line)
		endif
	endwhile
	
	" Restore the cursor position
  call setpos('.', save_cursor)
endfunction

function! GoFmtLines(start_line, end_line)
    let l:content = getline(a:start_line, a:end_line)

    " Write content to a temporary file
    let l:tempfile = tempname()
    call writefile(l:content, l:tempfile)

    " Run gofmt on the temporary file
    let l:formatted_content = system('gofmt ' . l:tempfile)
		if v:shell_error == 0
			" Replace original content with formatted content
			call setline(a:start_line, split(l:formatted_content, "\n"))
		endif

    " Clean up the temporary file
    call delete(l:tempfile)
endfunction
command! -range=% GoFmtSelectedLines call GoFmtLines(<line1>, <line2>)

augroup txtar_autocmd
	autocmd!
	autocmd BufNewFile,BufRead *.txtar call s:TxTarHighlight()
	autocmd BufWritePre *.txtar call s:TxTarGoFmt()
augroup END


" edit vimrc
nnoremap <Leader>ev :vsplit $MYVIMRC<cr>
nnoremap <Leader>sv :source $MYVIMRC<cr>

" toggle zen mode
nnoremap <Leader>z :Goyo<cr>

" git
function! GitCommitTag()
	let l:sha1 = expand("<cword>")
  echo system('git name-rev --tags ' . l:sha1)
endfunction
function! GitDefaultBranch()
	return trim(system("git rev-parse --abbrev-ref origin/HEAD|cut -c8-"))
endfunction
function! GitDiff()
	execute "Gdiff ".GitDefaultBranch()."...HEAD" 
endfunction
function! GitDiffSplit()
	execute "Gvdiffsplit ".GitDefaultBranch()."...HEAD:%"
endfunction
function! GitConflicts()
	execute "Gvdiffsplit!"
endfunction
nnoremap <Leader>g :G<cr>
nnoremap <Leader>gp :G push -u<cr>
nnoremap <Leader>gd :call GitDiff()<cr>
nnoremap <Leader>gq :call GitConflicts()<cr>
nnoremap <Leader>gg :call GitDiffSplit()<cr>
nnoremap <Leader>ga :G add -A<cr>
nnoremap <Leader>gs :G status -sb<cr>
nnoremap <Leader>gr :G rebase --continue<cr>
nnoremap <Leader>gb :GBranches --locals<cr>
nnoremap <Leader>gm :G blame<cr>
nnoremap <Leader>gt :call GitCommitTag()<cr>
nnoremap <Leader>gh :GBrowse<cr>
" Gbranches sort by date
let g:fzf_checkout_git_options = '--sort=-committerdate'
" \qq feed the qf with conflicted files
nnoremap <Leader>qq :call ConflictToQF()<cr>
nnoremap <Leader>gc :call ConflictToQF()<cr>
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


" Fuzzy finder
nnoremap <C-p> :FZF<cr>
nnoremap <C-b> :Buffers<cr>
nnoremap <C-g> :GFiles?<cr>
let g:fzf_preview_window = ['up:40%:hidden', 'ctrl-/']

" ag search
nnoremap <Leader>s :Ack 
"nnoremap <Leader>s :Ack --ignore={'*.pb.go','*.pb.gw.go','*.pulsar.go','*_test.go'} 
"ack setup, replace with ag
let g:ackprg = 'ag --vimgrep'
let g:ackhighlight = 1
" FilterQF removes protobuf and test go files from QF list
nnoremap <Leader>qf :call FilterQF()<cr>
function FilterQF()
	let qf = []
	for f in getqflist()
		let n = bufname(f.bufnr)
		if n =~ '\.pb\.go$' || n =~ '\.pb\.gw\.go$' || n =~ '\.pulsar\.go$' || n =~ '_test\.go' || n =~ 'testutil'
			continue
		endif
		if f.text =~ 'is deprecated'
			continue
		endif
		call add(qf, f)
	endfor
	call setqflist(qf)
endfunction


" goto file edits file
nnoremap gf :e <cfile><CR>
" open dir of current buffer
nnoremap <Leader>d :e %:p:h<CR>
" quick buffer switch
nnoremap <Leader>b :buffers<CR>:buffer<Space>

" upper case word
inoremap <c-u> <esc>viwU<esc>i
"nnoremap <c-u> viwU

" delete line in insert mode
inoremap <c-d> <esc>ddi

" operator first parenthesis
onoremap if( :<c-u>normal! 0f(vi(<cr>
" operator last parenthesis
onoremap il( :<c-u>normal! $F)vi(<cr>

" quote word
nnoremap <leader>" viw<esc><esc>a"<esc>bi"<esc>lel
nnoremap <leader>' viw<esc><esc>a'<esc>bi'<esc>lel

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
"augroup write_html
"	autocmd!
"	autocmd BufWritePre *.html :normal gg=G ``
"augroup END

" yaml format
"autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" highlight line and column
highlight CursorLine   cterm=NONE ctermbg=black  guibg=black
highlight CursorColumn cterm=NONE ctermbg=black  guibg=black
nnoremap <Leader>x :set cursorline! cursorcolumn!<CR>

"cnext/cprevious mapping on location
map <C-Left> :bprevious<CR>
map <C-Right> :bnext<CR>
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
" enquote mapping
nnoremap "" ciw"<esc>pa",<esc>
vnoremap "" c"<esc>pa",<esc>

set tabstop=2
set softtabstop=2
set shiftwidth=2
set noexpandtab
set noswapfile
"always show statusline
set laststatus=2
" Format the status line
set statusline=[%n]\ %t%m%r%h\ %w%y%<\ \ Cwd:%r%{getcwd()}%h\ \ %=\ Enc:%{strlen(&fenc)?&fenc:'none'},%{&ff}\ \ Line:%l\,%c\/%L\ \[%P\]\ %o

" enable mouse
set mouse=a

" 7 characters limit when j/k
set scrolloff=7

set relativenumber
set number


filetype plugin indent on

autocmd BufRead,BufNewFile *.vugu set filetype=html

" Markdown config
autocmd BufRead,BufNewFile *.md set filetype=markdown
autocmd FileType markdown setlocal tw=79
autocmd FileType markdown nnoremap BB ciw**<esc>pa**<esc>
autocmd FileType markdown vnoremap BB c**<esc>pa**<esc>

autocmd BufRead,BufNewFile mail setlocal tw=72

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

" supertab use gocode
let g:SuperTabDefaultCompletionType = "context"


" Go stuff

"Open the relevant Godoc for the word under the cursor with <leader>gd or open it vertically with <leader>gv
"au FileType go nmap <Leader>gd <Plug>(go-doc)
"au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
autocmd FileType go nmap gd <Plug>(go-def-split)
"go commands
autocmd FileType go nmap <leader>i :call GOVIMHover()<cr>
autocmd FileType go nmap <leader>rr :GOVIMRename<cr>
autocmd FileType go nmap <leader>c :GOVIMQuickfixDiagnostics<cr>
autocmd FileType go nmap <leader>t <Plug>(go-test)
autocmd FileType go nmap <leader>I <Plug>(go-install)
autocmd FileType go nmap <leader>rf :GOVIMReferences<cr>
autocmd FileType go nmap <leader>ri :GOVIMImplements<cr>
"au FileType go nmap <leader>r <Plug>(go-referrers)
"call govim#config#Set("ExperimentalProgressPopups", 1)
call govim#config#Set("Gofumpt", 1)
call govim#config#Set("GoImportsLocalPrefix", "github.com/cosmos/cosmos-sdk,cosmossdk.io,github.com/gnolang/gno,github.com/cosmos/interchain-security,github.com/cometbft/cometbft,github.com/cosmos/ibc-go,github.com/atomone-hub/govgen,github.com/ignite/cli")

" \tt ask set a new build tag
nnoremap <Leader>tt :call SetBuildTag()<cr>
function SetBuildTag()
	let tag = input($GOFLAGS.' - Input new build tag: ')
	let line = 'let $GOFLAGS="-tags='.tag.'"'
	call writefile([line], glob('~/gotags.vim'))
	redraw
	echomsg line.' now quit and restart vim'
endfunction
try
	source ~/gotags.vim
catch
	" no gotags
endtry

" Gno config
augroup gno_autocmd
	autocmd!
	autocmd BufNewFile,BufRead *.gno
		\ set filetype=gno |
		\ set syntax=go
augroup END
" Gno LSP config
if (executable('gnols'))
	autocmd User lsp_setup  call lsp#register_server({
		\ 'name': 'gnols',
		\ 'cmd': ['gnols'],
		\ 'allowlist': ['gno'],
		\ 'config': {},
		\ 'workspace_config': {
		\		'gno' : '/home/tom/go/bin/gno',
		\		'gopls' : '/home/tom/go/bin/gopls',
    \   'precompileOnSave' : v:true,
    \   'buildOnSave' : v:true,
    \   'root' : '/home/tom/src/gno',
		\ },
		\ 'languageId': {server_info->'gno'},
		\ })
	let g:lsp_show_workspace_edits = 1
	let g:lsp_log_verbose = 1
	let g:lsp_log_file = expand('~/log/vim-lsp.log')
endif
" register test command
"function! s:gnols_test(context)
"	"let l:command = get(a:context, 'command', {})
"	echomsg context
"endfunction
"call lsp#register_command('gnols.test', function('s:gnols_test'))
	
function! s:on_lsp_buffer_enabled() abort
	setlocal omnifunc=lsp#complete
	setlocal signcolumn=yes
	autocmd! BufWritePre *.gno LspDocumentFormatSync
	nmap <buffer> gd <plug>(lsp-definition)
	nmap <buffer> <leader>rr <Plug>(lsp-rename)
	nmap <buffer> <leader>ri <Plug>(lsp-implementation)
	nmap <buffer> <leader>rf <Plug>(lsp-references)
	nmap <buffer> <leader>i <Plug>(lsp-hover)
	nmap <buffer> <leader>t :call s:gnols_test()<cr>
endfunction
function! s:gnols_test()
	call lsp#ui#vim#execute_command#_execute({
		\ 'command_name':'gnols.test',
		\ 'command_args': [bufname(), 'Test'],
		\ 'server_name':'gnols',
	\ })
endfunction
augroup lsp_install
	autocmd!
	autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" Format go.plush files
function! GoPlushFmt()
	execute "silent! %s/<%= /appxxxx/g|norm!``"
	execute "silent! %s/ %>/appyyyy/g|norm!``"
	execute "silent! write!"
	cexpr system('gofumpt -e -w ' . expand('%'))
	cexpr system('goimports -w -local appxxxx ' . expand('%'))
	edit!
	execute "silent! %s/appxxxx/<%= /g|norm!``"
	execute "silent! %s/appyyyy/ %>/g|norm!``"
	execute "silent! write!"
endfunction
command! GoPlushFmt call GoPlushFmt()
augroup goplush_autocmd
	autocmd!
	autocmd BufNewFile,BufRead *.go.plush set filetype=go
	autocmd BufWritePost *.go.plush GoPlushFmt
augroup END

" \cc select the current buffer filename in qf list
nnoremap <Leader>cc :call BufferQF()<cr>
function BufferQF()
	let name = escape(bufname(), "/")
	let wid = win_getid()
	execute "copen 10"
	let line = search(name)
	if line > 0
		call cursor(line, 1)
		execute "cr " . line(".")
	else
		echo "No error in current buffer"
		call win_gotoid(wid)
	endif
endfunction

"nnoremap <C-\> 0i//<space><esc>j
vnoremap <C-\> 0I//<space><esc>
nnoremap <expr> <C-\> stridx(getline('.'), '//')==-1 ? '0I//<space><esc>j' : '0/\/\/<cr>xxj'

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

" jk to <esc>
inoremap jk <esc>
"iunmap jk
"inoremap <esc> <nop>
abbreviate coalb Co-authored-by: Albert Le Batteux <contact@albttx.tech>
abbreviate cogui Co-authored-by: Giuseppe Natale <giuseppe.natale@tendermint.com>

function! GetSelectedText()
	" Why is this not a built-in Vim script function?!
	let [line_start, column_start] = getpos("'<")[1:2]
	let [line_end, column_end] = getpos("'>")[1:2]
	let lines = getline(line_start, line_end)
	if len(lines) == 0
	    return ''
	endif
	let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
	let lines[0] = lines[0][column_start - 1:]
	return join(lines, "\n")
endfunction
