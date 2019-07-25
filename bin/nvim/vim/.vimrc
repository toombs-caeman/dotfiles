" shout-out to http://dougblack.io/words/a-good-vimrc.html
 
let mapleader=";"

" what is the name of the directory containing this file?
let s:portable = expand('<sfile>:p:h')

" Isolate the runtime to the current directory
let &runtimepath = s:portable
let &packpath = s:portable

if &compatible
  set nocompatible
endif


"Settings" {{{

" Colors
if has('termguicolors')
    set termguicolors
endif
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
set clipboard+=unnamedplus " TODO supposed to allow system clipboard
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
" use alt-<num> to move splits in any mode
tnoremap <A-1> <C-\><C-N>1gt
inoremap <A-1> <C-\><C-N>1gt
nnoremap <A-1> 1gt

tnoremap <A-2> <C-\><C-N>2gt
inoremap <A-2> <C-\><C-N>2gt
nnoremap <A-2> 2gt

tnoremap <A-3> <C-\><C-N>3gt
inoremap <A-3> <C-\><C-N>3gt
nnoremap <A-3> 3gt

tnoremap <A-4> <C-\><C-N>4gt
inoremap <A-4> <C-\><C-N>4gt
nnoremap <A-4> 4gt

tnoremap <A-5> <C-\><C-N>5gt
inoremap <A-5> <C-\><C-N>5gt
nnoremap <A-5> 5gt

tnoremap <A-6> <C-\><C-N>6gt
inoremap <A-6> <C-\><C-N>6gt
nnoremap <A-6> 6gt

tnoremap <A-7> <C-\><C-N>7gt
inoremap <A-7> <C-\><C-N>7gt
nnoremap <A-7> 7gt

tnoremap <A-8> <C-\><C-N>8gt
inoremap <A-8> <C-\><C-N>8gt
nnoremap <A-8> 8gt

" close fold
nnoremap <leader>f zc

" highlight last inserted text
nnoremap gv `[v`]

" use ESC to exit the terminal
" this does mask 'set -o vi' but we don't care
tnoremap <Esc> <C-\><C-n>

" use alt to navigate splits in any mode
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" use shift-alt to move splits in any mode
tnoremap <A-H> <C-\><C-N><C-w>H
tnoremap <A-J> <C-\><C-N><C-w>J
tnoremap <A-K> <C-\><C-N><C-w>K
tnoremap <A-L> <C-\><C-N><C-w>L
inoremap <A-H> <C-\><C-N><C-w>H
inoremap <A-J> <C-\><C-N><C-w>J
inoremap <A-K> <C-\><C-N><C-w>K
inoremap <A-L> <C-\><C-N><C-w>L
nnoremap <A-H> <C-w>H
nnoremap <A-J> <C-w>J
nnoremap <A-K> <C-w>K
nnoremap <A-L> <C-w>L

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
"" move the cursor anywhere
" set virtualedit=all
