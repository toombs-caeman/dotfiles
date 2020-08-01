" shout-out to http://dougblack.io/words/a-good-vimrc.html
 
let mapleader=";"

" what is the name of the directory containing this file?
let s:portable = expand('<sfile>:p:h')

" Isolate the runtime to the current directory
let &runtimepath = s:portable . ',/usr/local/opt/fzf'
let &packpath = s:portable

if &compatible
  set nocompatible
endif



"Settings" {{{

" Colors
syntax enable
colorscheme theme " this theme is dynamically generated, but defaults to solarized dark
try
        colorscheme ricer
catch /.*/
endtry

"Tabstop
set tabstop=4   " number of spaces tabs are visually
set shiftwidth=4
set softtabstop=4
set expandtab   " tabs are spaces. annoying when editing python
set bs=2        " allow backspace after insert mode

if has('mouse') " enable mouse support
  set mouse=n
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
" move visually
nnoremap j gj
nnoremap k gk

" tab movement
nnoremap t gt
nnoremap T gT


" close fold
nnoremap <leader>f zc

" highlight last inserted text
nnoremap gv `[v`]


" use leader to navigate splits in any mode
tnoremap <leader>h <C-w>h
tnoremap <leader>j <C-w>j
tnoremap <leader>k <C-w>k
tnoremap <leader>l <C-w>l
inoremap <leader>h <C-\><C-N><C-w>h
inoremap <leader>j <C-\><C-N><C-w>j
inoremap <leader>k <C-\><C-N><C-w>k
inoremap <leader>l <C-\><C-N><C-w>l
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

" use shift-leader to move splits in any mode
tnoremap <leader>H <C-w>H
tnoremap <leader>J <C-w>J
tnoremap <leader>K <C-w>K
tnoremap <leader>L <C-w>L
inoremap <leader>H <C-\><C-N><C-w>H
inoremap <leader>J <C-\><C-N><C-w>J
inoremap <leader>K <C-\><C-N><C-w>K
inoremap <leader>L <C-\><C-N><C-w>L
nnoremap <leader>H <C-w>H
nnoremap <leader>J <C-w>J
nnoremap <leader>K <C-w>K
nnoremap <leader>L <C-w>L


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

" }}}
"History" {{{
nmap U <C-r>
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

" protect changes between writes, and from editing the same file twice
set swapfile
set directory^=s:portable./swapdir//
" protect against crash-during-write
set writebackup
" but do not persist backup after successful write
set nobackup
" use rename-and-write-new method whenever safe
set backupcopy=auto
" patch required to honor double slash at end
if has("patch-8.1.0251")
	" consolidate the writebackups -- not a big
	" deal either way, since they usually get deleted
	set backupdir^=s:portable./backup//
end


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
"NETRW" {{{
let g:netrw_banner=0
let g:netrw_browse_split=1
let g:netrw_winsize=25
let g:netrw_liststyle=4
let g:netrw_altv=1

"NETRW" }}}
function! TwiddleCase(str)
  if a:str ==# toupper(a:str)
    let result = tolower(a:str)
  elseif a:str ==# tolower(a:str)
    let result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
  else
    let result = toupper(a:str)
  endif
  return result
endfunction
vnoremap ~ y:call setreg('', TwiddleCase(@"), getregtype(''))<CR>gv""Pgv
set hidden

" system clipboard
vmap <leader>y "+y
nmap <leader>p "+p

" TERM {{{
set shell=bash
if has('termguicolors')
    set termguicolors
endif
tnoremap <Esc><Esc> <C-\><C-n>

function! Tapi_cd(bufnum, arglist)
    execute 'cd' fnameescape(a:arglist[0])
    let t:wd = fnameescape(a:arglist[0])
endfunction
" tab local working directory
au TabEnter * if exists("t:wd") | exe "cd" t:wd | endif

" }}}
