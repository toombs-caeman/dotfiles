" shout-out to http://dougblack.io/words/a-good-vimrc.html
"TODO" {{{ 
" add filetype specific stuff
" python, c, javascript snippets
" possibilities to add
" powerline https://github.com/powerline/powerline
" silver searcher https://github.com/ggreer/the_silver_searcher
" fzf
" }}}
"Folding" {{{
set foldenable
set foldnestmax=10
set foldlevel=0
set foldmethod=marker
set modeline
set modelines=1
" }}}
"Colors & Syntax" {{{
syntax enable
colorscheme neon
" }}}
"Movement" {{{
" move visually
nnoremap j gj
nnoremap k gk
" highlight last inserted text
nnoremap gv `[v`]
" }}}
"Tabstop" {{{
set tabstop=4 " number of spaces tabs are visually
set expandtab " tabs are spaces. annoying when editing python
" }}}
"UI Config" {{{
set nonumber            " hide line numbers
set wildmenu            " visual autocomplete for command menu

set lazyredraw          "redraw only when we need to
set showcmd             " shows the previously used command
set showmatch           " highlight matching [{()}]

" visual bell off
set noerrorbells
set novisualbell
set t_vb=
set tm=500
set incsearch           " search as characters are entered
set hlsearch            " highlight matches

set noswapfile          " turn off swap files
" }}}
"History" {{{
set history=700
" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo

" TODO don't remember what this does!!
" I believe it restores the cursor to where it was
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END
" }}}
"Functions" {{{
" logs a range to a logfile based on the current file name
" TODO gets wonky on multiple lines. 
" also the extra <CR> should be handled here and not in the mapping
function Log ()
  let timestamp = strftime('%y-%m-%_d') . '\#\#'
  let logfile = expand('%:p') . '.log'
  for line in getline("v",".")
    exec '!echo "' . timestamp . line . '" >>' . logfile
  endfor
  exec line("v") . "," . line(".") . "d"
endfunction

" Opens a URL 
" opens the first url appearing on that line
" local urls, starting with file:// are opened in a tab
" all others are for now opened in chromium
function! Link ()
  let line = split(getline (".")) " a list of strings split on \s
  let index = match(line, "\/\/") 
  if -1 == index
    echo "URL not found in line"
  else
    if -1 == match(line[index], "^file://")
      exec "!chronic chromium-browser " . line[index]
    else
      exec "tabedit " . split(line[index],"\/\/")[1]
    endif
  endif
endfunction
" }}}
"Keymapping" {{{
let mapleader=";"

" Log: writes the line to a log file w/ timestamp. intended for todo list
nnoremap <leader>d :call Log ()<CR><CR>

" Fold: close fold
nnoremap <leader>f zc

" Down: move to the next tab
nnoremap <leader>j :tabn<CR>

" Up: move to the previous tab
nnoremap <leader>k :tabp<CR>

" Link: open link
nnoremap <Leader>l :call Link ()<CR>

" }}}
