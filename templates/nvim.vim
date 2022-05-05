set nocompatible

" plugins [vim-plug](https://github.com/junegunn/vim-plug)
call plug#begin()
Plug 'airblade/vim-gitgutter'       " show modified lines left of numbers
Plug 'preservim/nerdtree'           " file system explore
Plug 'Xuyuanp/nerdtree-git-plugin'  " show git status in NERDTree
Plug 'junegunn/fzf'                 " basic fzf support
Plug 'junegunn/fzf.vim'             " fzf for vim objects
" TODO Plug 'tpope/vim-fugitive'    " working with git
Plug 'dracula/vim', { 'as': 'dracula' } "colorscheme
" TODO Plug 'jmcantrell/vim-virtualenv'  " working with virtualenv
Plug 'michaeljsmith/vim-indent-object'
call plug#end()

" status line
"set wildmenu                 " display completion matches in a status line
set showcmd                  " display incomplete commands
"set wildmode=longest,list    " get bash-like tab completions

" search
set ignorecase              " case insensitive matching
set hlsearch                " highlight search results
set incsearch               " Do incremental searching when it's possible to timeout.
                            " clear search highlights
nno <ESC><ESC> :noh<CR>

" style
set number                  " add line numbers
set ruler                   " show the cursor position all the time
set showmatch               " show matching brackets.
set cc=120                  " set an 120 column border for good coding style
set scrolloff=5             " Show a few lines of context around the cursor
set sidescrolloff=10        " in all directions
set list                    " indicate hidden text
set listchars+=precedes:<,extends:>
set nowrap                  " don't wrap lines
syntax on                   " syntax highlighting

" tab
set autoindent              " indent a new line the same amount as the line just typed
filetype plugin indent on   " allows auto-indenting depending on file type
set tabstop=4               " number of columns occupied by a tab character
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing

" sys
set mouse=a                 " enable moving the cursor with a mouse click
set clipboard=unnamedplus   " use system clipboard copy paste


" keys
" let mapleader="," " , is a bad idea because it shadows reverse search
set ttimeout                " time out for key codes
set ttimeoutlen=100         " wait up to 100ms after Esc for special key

" persistence
set noswapfile              " don't write .*.swp files
set updatetime=100          " write swap after 100 ms, also update gitgutter
set history=200             " keep 200 lines of command line history
augroup vimStartup          " When opening a file, always jump to the last known cursor position.
  au!
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif

augroup END

" visual movement
nno j gj
nno k gk

" create <Cmd> maps using Alt keys for modes nvoti
fu s:A(...)
    for l:kc in range(0, a:0 - 1, 2)
        " if a:000=['x', 'y'] then l:m=' <A-x> <Cmd>y<CR>'
        " insert <CR> only if a:000[l:kc+1] doesn't contain one (<Cmd> must be matched by <CR>)
        let l:m = ' <A-'.a:000[l:kc].'> <Cmd>'.a:000[l:kc+1].(len(split(a:000[l:kc+1], '<CR>', 1)) > 1 ? '' : '<CR>')
        for l:mode in ['no', 'tno', 'ino']
            exe l:mode . l:m
        endfor
    endfor
endfu
" re-expose winc commands
for x in ['-', '+', '<', '>', '=']
    call s:A(x, 'winc ' . x)
endfor
" allow mistyping '-' as '_'
call s:A('_', 'winc -')
" winc commands where we want to go to normal mode after
for x in ['h', 'j', 'k', 'l']
    call s:A(x, 'winc ' . x . '<CR><ESC>')
endfor

" open/close splits
set splitright splitbelow
call s:A('s', 'new', 'v', 'vne', 'Q', 'q<CR><ESC>')
" open a terminal
call s:A('CR', 'vs term://$SHELL', 't', 'terminal<CR>i')
" open files
call s:A('b', 'Buffers', 'e', 'Files', 'g', 'GFiles?', 'd', 'NERDTreeToggle')
" toggle nerdtree with <A-d>, even when focused on nerdtree
let NERDTreeMapQuit='A-d'


autocmd VimResized * winc =                             " equalize split size when terminal resizes
autocmd BufWinEnter,WinEnter term://* startinsert       " insert when entering a terminal
autocmd TermOpen * setlocal nonumber norelativenumber   " don't show numbers for terminals

" grow or shrink selection symmetrically
vno H holo
vno J joko
vno K kojo
vno L loho

autocmd FileType *sh ino <buffer> vv "${}"<Left><Left>
autocmd FileType *sh ino <buffer> va "${[@]}"<Left><Left><Left><Left><Left>
ino kk []()<Left><Left><Left>

"" (s)urround inspired by [surround-vim](https://github.com/tpope/vim-surround)
" also big ups to [operator-user](https://github.com/kana/vim-operator-user)
" and [textobj-user](https://github.com/kana/vim-textobj-user)
" test case: normalmode, visual, line, block, .(repeat), u(undo)
" shortcuts
no s  <Cmd>call Surround()<CR>g@
"ono s <Cmd>call Surround(0)<CR>
vno s <Cmd>call Surround(1)<CR>
" nno <expr> ds join(["yi", "gv`[o`]a", "p"], nr2char(getchar()))
vno <expr> ds join(["yi", "gv`[o`]a", "p"], nr2char(getchar()))
" Surround(object='')
fu! Surround(...)
    " setup
    if ! a:0 || a:1
        call inputsave()
        let @s = getchar()
        call inputrestore()
        set opfunc=Surround
    endif
    if ! a:0
        return
    endif
    echo 'ran?'
    " save state
    let l:sel_save = &selection
    let &selection = "inclusive"
    let l:mode=mode()

    if index(['line', 'char', 'block'], a:1) > -1
        " if we're an operator (from normal mode), go into visual mode as if we were called like that.
        exe "normal! " . ((a:1 == 'line') ? "`[V`]" : (a:1 == 'char') ? "`[v`]" : "`[<C-v>`]")
    endif

    " make call
    if exists("*S" . @s)
        "echo "calling S" . @s . "()"
        call function("S" . @s)()
    else
        let l:c = nr2char(@s)
        let l:c .= [l:c, ']', '}', ')', '>'][index(['[', '{', '(', '<'], l:c) + 1]
        echo l:c
        exe "normal! c" . l:c . "\<ESC>Pgvlolo\<ESC>"
    endif

    " restore state
    let &selection = sel_save
endfu
" called for 't' tag object
" compliance criteria for a text object X
" * supply maps `iX` and `aX`
" * supply function named `"S" . char2nr("X")` which assumes it is called from
"   a visual mode and alters the selected text such that
"   iX would select the original text and aX would select the new text.
"   marks '< and '> should be set such that `gv` is equivalent to `viX`
" * `sXyiX
fu! S116()
    call inputsave()
    let l:t = input("tag: ")
    call inputrestore()
    exe "normal! c<".l:t.">\<ESC>p`]a<".l:t."/>\<ESC>"
endfu




"onoremap ac :call 
" autocmd FileType sh vmap 'e '"gv:s/\([$"]\)/\\\1/g<CR>
" vnoremap '/ c/**/<ESC>hPll

" XXX - one per line
"
" for each text object X define a function SX such that SX(I) matches 'aX' and 'iX' matches I
" vmap expr s S
" define ic and ac: comments as text objects
" add case to Surround (sc) to insert comment
"
" map <C-c> and <C-v> to yy p, which combos nicely with clipboard
"
"   we can still send <C-c> to terminal, so no tmap
" buffer/tab shortcuts?
" make tab shortcuts <A-[0-9]> similar to i3
" python ide in vim
" project specific 'actions'
" language support LSP https://neovim.io/doc/lsp/
"   shell
"   python - virtualenv aware
"   javascript
" save/restore open files / layout
" airline?
" git
"   shortcut for GitGutterDiffOrig
"   show git status in nerdtree
"   native diff / merge - vim-fugitive
"
" colorscheme https://github.com/dracula/vim/blob/master/autoload/dracula.vim
"   set termguicolors, but use colorscheme based on ansi codes?
" shortcut Ctrl+/ to toggle comment https://github.com/preservim/nerdcommenter
"   /* */ <!-- --> " # //
" horizontal scrolling https://github.com/alacritty/alacritty/issues/2185
" write to readonly file https://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work
"
" '<,'>p without changing clipboard contents?
" unify fzf 'open in split/vsplit' with nerdtree keybindings
"
