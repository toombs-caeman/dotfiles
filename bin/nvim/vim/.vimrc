" shout-out to http://dougblack.io/words/a-good-vimrc.html
 
let mapleader=";"

" what is the name of the directory containing this file?
let s:portable = expand('<sfile>:p:h')

" Isolate the runtime to the current directory
let &runtimepath = s:portable

if &compatible
  set nocompatible
endif

"Settings" {{{
" break bad habits
inoremap <Up>    <NOP>
inoremap <Down>  <NOP>
inoremap <Left>  <NOP>
inoremap <Right> <NOP>
vnoremap <Up>    <NOP>
vnoremap <Down>  <NOP>
vnoremap <Left>  <NOP>
vnoremap <Right> <NOP>
nnoremap <Up>    <NOP>
nnoremap <Down>  <NOP>
nnoremap <Left>  <NOP>
nnoremap <Right> <NOP>

" Colors
if has('termguicolors')
    set termguicolors
endif
syntax enable
colorscheme theme " this theme is dynamically generated, but defaults to solarized dark

"Tabstop
set tabstop=4   " number of spaces tabs are visually
set expandtab   " tabs are spaces. annoying when editing python
set bs=2        " allow backspace after insert mode
set clipboard+=unnamedplus " TODO supposed to allow system clipboard
if has('mouse') " enable mouse support
  set mouse=a
endif

filetype plugin indent on

set display=truncate
set nonumber            " hide line numbers
set wildmenu            " visual autocomplete for command menu
set ruler               " show line,column on the statusbar

set lazyredraw          "redraw only when we need to
set showcmd             " shows the previously used command
set showmatch           " highlight matching [{()}]

set foldenable
set foldnestmax=10
set foldlevel=0
set foldmethod=marker

" visual bell off
set noerrorbells
set novisualbell
set t_vb=
set tm=500
set incsearch           " search as characters are entered
set hlsearch            " highlight matches

set noswapfile          " turn off swap files
" }}}
"Movement" {{{
" TODO panel movement
" move visually
nnoremap j gj
nnoremap k gk
" highlight last inserted text
nnoremap gv `[v`]
nnoremap t gt
nnoremap T gT
" close fold
nnoremap <leader>f zc

" Down: move to the next tab
nnoremap <leader>j :tabn<CR>

" Up: move to the previous tab
nnoremap <leader>k :tabp<CR>
" }}}
"History" {{{
" persistent undo
let undodir=printf("%s/undodir/", s:portable)
exe "set undodir=".undodir
if !isdirectory(undodir)
    call mkdir(undodir, 'p')
endif
set undofile
set history=700
" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
set viminfo='10,\"100,:20,%

" allow vim to write to non exisistent directories by recursively creating the needed directories
function s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

augroup vimStartup
  au!
  " When editing a file, always jump to the last known cursor position.
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ |   exe "silent! normal! zOzz"
    \ | endif
augroup END
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif
" }}}
"Terminal" {{{
" check to see if we have a terminal
if has('termainal')
    set termwinkey=CTRL-W
    "TODO allow an embedded terminal to reuse the existing vim session instead of nesting instances
    function Tapi_edit(bufnum, arglist)
        execute "e ".fnameescape(a:arglist[0])
    endfunc
    
    "TODO allow the embedded terminal to paste the contents of the yank buffer
endif

"Terminal" }}}
"NETRW" {{{
let g:netrw_banner=0
let g:netrw_browse_split=1
let g:netrw_winsize=25
let g:netrw_liststyle=4
let g:netrw_altv=1

"NETRW" }}}
