set nocompatible

" plugins [vim-plug](https://github.com/junegunn/vim-plug)
call plug#begin()
Plug 'airblade/vim-gitgutter'           " show modified lines left of numbers
Plug 'preservim/nerdtree'               " file system explore
Plug 'Xuyuanp/nerdtree-git-plugin'      " show git status in NERDTree
Plug 'junegunn/fzf'                     " basic fzf support
Plug 'junegunn/fzf.vim'                 " fzf for vim objects
" TODO Plug 'tpope/vim-fugitive'        " working with git
" TODO https://github.com/tpope/vim-unimpaired
" https://github.com/tpope/vim-eunuch
" https://github.com/pechorin/any-jump.vim
" https://github.com/yegappan/mru
" TODO https://vimawesome.com/plugin/syntastic
" https://github.com/dense-analysis/ale
Plug 'dracula/vim', { 'as': 'dracula' } " colorscheme
Plug 'wellle/targets.vim'               " a wide range of new text objects
Plug 'kana/vim-textobj-user'            " textobj base library
Plug 'D4KU/vim-textobj-comment'         " textobj comment
Plug 'toombs-caeman/vim-smoothie'       " smooth scrolling, fork of 'psliwka/vim-smoothie'
call plug#end()

" status line
set showcmd                 " display incomplete commands
set wildmode=longest:full   " get bash-like tab completions
set ruler                   " show the cursor position all the time

" search
set ignorecase              " case insensitive matching. see :help \c
set hlsearch                " highlight search results
set incsearch               " Do incremental searching
" clear search highlights
nno <ESC><ESC> <Cmd>noh<CR>

" style
colo dracula                " set colorscheme
set tgc                     " use 24-bit colors
set number                  " add line numbers
set showmatch               " show matching brackets
set cc=120                  " highlight column 120
set scrolloff=5             " Show a few lines of context around the cursor
set sidescrolloff=10        " in all directions
set list                    " indicate hidden text
set listchars+=precedes:<,extends:>
set nowrap                  " don't wrap lines
syntax on                   " syntax highlighting
set foldlevelstart=99       " start with all folds open

" smooth scroll commands, start with defaults
let g:smoothie_remapped_commands = smoothie#default_commands + smoothie#experimental_commands + [ '{', '}' ]

" gui
set guifont=FiraCode

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
" resize windows
for x in ['-', '+', '<', '>', '=']
    call s:A(x, 'winc '.x)
endfor
" allow mistyping '-' as '_'
call s:A('_', 'winc -')
" winc commands where we want to go to normal mode after
for x in ['h', 'j', 'k', 'l']
    call s:A(x, 'winc '.x.'<CR><ESC>')
endfor

" open/close splits
set splitright splitbelow
call s:A('s', 'new', 'v', 'vne', 'Q', 'q<CR><ESC>')
" open/close tabs and navigate by number
call s:A('t', 'tabnew', 'W', 'tabc<CR><ESC>')
for x in range(9)
    call s:A(x, 'tabn '.x.'<CR><ESC>')
endfor
" use the same keys to open tabs and splits in fzf
let g:fzf_action = { 'alt-t': 'tab split', 'alt-s': 'split', 'alt-v': 'vsplit' }
aug fzf_keys
    au!
    " forward these keys to fzf rather than opening directly
    au FileType fzf tno <buffer> <A-t> <A-t>
    au FileType fzf tno <buffer> <A-s> <A-s>
    au FileType fzf tno <buffer> <A-v> <A-v>
    " we don't want to move away from the fzf window accidentally
    " these also match commands bound in $FZF_DEFAULT_OPTS
    " for moving up and down the options
    au FileType fzf tno <buffer> <A-h> <A-h>
    au FileType fzf tno <buffer> <A-j> <A-j>
    au FileType fzf tno <buffer> <A-k> <A-k>
    au FileType fzf tno <buffer> <A-l> <A-l>
aug END

" open a terminal
call s:A('CR', 'vs term://$SHELL', 'S-CR', 'terminal<CR>i')
" open files
call s:A('b', 'Buffers', 'e', 'Files', 'g', 'GFiles?', 'd', 'NERDTreeToggle')
" toggle nerdtree with <A-d>, even when focused on nerdtree
let NERDTreeMapQuit='A-d'



" grow or shrink selection symmetrically
vno H holo
vno J joko
vno K kojo
vno L loho

aug bruh
    au!
    au VimResized * winc =                             " equalize split size when terminal resizes
    au BufWinEnter,WinEnter term://* startinsert       " insert when entering a terminal
    au TermOpen * setlocal nonumber norelativenumber   " don't show numbers for terminals
    au FileType *sh ino <buffer> vv "${}"<Left><Left>
    au FileType *sh ino <buffer> va "${[@]}"<Left><Left><Left><Left><Left>
aug END

"" (s)urround inspired by [surround-vim](https://github.com/tpope/vim-surround)
" also big ups to [operator-user](https://github.com/kana/vim-operator-user)
" and [textobj-user](https://github.com/kana/vim-textobj-user)
" shortcuts
nno s  <Cmd>call Surround()<CR>g@
"ono s <Cmd>call Surround(0)<CR>
vno s <Cmd>call Surround()<CR>g@`<
" nno <expr> ds join(["yi", "gv`[o`]a", "p"], nr2char(getchar()))
" vno <expr> ds join(["yi", "gv`[o`]a", "p"], nr2char(getchar()))
" for count supplied to movement (and <C-U>) see :help v:count
fu! Surround(...)
    """ todo
    " how do we handle counts?
    " test case: normalmode, visual, line, block, .(repeat), u(undo),
    "   marks(keepjumps?), as straight function call.
    "

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
    " save state
    let l:sel_save = &selection
    let &selection = "inclusive"
    if index(['line', 'char', 'block'], a:1) > -1
        " if we're called as an operator (through g@), go into visual mode
        " this should simplify things for our plugins
        exe "normal! ".((a:1 == 'line') ? "`[V`]" : (a:1 == 'char') ? "`[v`]" : "`[<C-v>`]")
    endif


    " make call if plugin exists
    if exists('*S'.@s)
        call function('S'.@s)()
    else
        " TODO add support for default objects s and p
        " handle builtin text objects but if all else fails,
        " just duplicate the given character on the left and right
        let l:c = nr2char(@s)
        " unalias the default text objects
        let l:c = (l:c.'  [{{((<')[match('wW]}B)b>', '\C'.l:c) + 1]
        " add the matching right hand side, or duplicate
        let l:c.= (l:c.']})>')[match('[{(<', l:c) + 1]
        exe "normal! c".l:c."\<ESC>Pgvlolo\<ESC>`<"
    endif

    " restore state
    let &selection = l:sel_save
endfu
nno <expr> ds join(["yi", "va", "p"], nr2char(getchar()))
" fu! Desurround
"    if ! a:0 || a:1
"        call inputsave()
"        let @s = getchar()
"        call inputrestore()
"        set opfunc=Surround
"    endif
"    if ! a:0
"        return
"    endif
"endfu
" compliance criteria for a text object X
" * supply maps `iX` and `aX`
" * supply function named `"S" . char2nr("X")` which assumes it is
"   called from a visual mode and alters the selected text such that
"   iX would select the original text and aX would select the new text.
"   marks '< and `> should be set such that `gv` is equivalent to `viX`
"   the cursor should be left at `<
" * `sXyiXgvaXp` is assumed to be a no-op
fu! S116() " called for 't' text object
    call inputsave()
    let l:t = input("tag: ")
    call inputrestore()
    exe "normal! c<".l:t.">\<ESC>pgv`[o`]\<ESC>a</".l:t.">\<ESC>`<"
endfu
" version that doesn't make the cursor jump all over
" also allows attributes
fu! S116(...) " called for 't' text object 
    if visualmode() == "<C-v>"
        echom "this doesn't really make sense?"
    endif
    if ! a:0
        call inputsave()
        normal! "1c<>
        aug S116 | au InsertLeave <buffer> call S116(1) | aug END
        startinsert
    else
        aug S116 | au! | aug END
        " don't use F here since it it could span multiple lines
        " try vi<`<eyvi<\<ESC>
        " TODO fails with single letter tag??? like <p>
        exe "normal! vi<`<eyvi<l\<ESC>\"1p`]a</>\<ESC>P"
        call inputrestore()
    endif
endfu
" ino kk <Cmd>call MdLink()<CR>
fu! MdLink(...)
    if ! a:0
        call inputsave()
        exe "normal! i[]()\<ESC>F]"
        aug MdLink | au InsertLeave <buffer> call MdLink(1) | aug END
        startinsert
    else
        aug MdLink | au! | aug END
        exe "normal! f)"
        call inputrestore()
        startinsert
    endif
endfu


fu! S99() " called for textobj (c)omment
    let l:mode = visualmode()
    let l:begin = getpos("`<")[1:2]
    let l:end   = getpos("`>")[1:2]
    " parse &commentstring
    let l:l = matchlist(&comments, "\(^\|,\)[^sme,:]*:\([^,]*\)")[2]
    let l:s = matchlist(&comments, "s[^:,]*:\([^,]*\)")[1]
    let l:m = matchlist(&comments, "m[^:,]*:\([^,]*\)")[1]
    let l:e = matchlist(&comments, "e[^:,]*:\([^,]*\)")[1]

    " select comment type
    " if we've only got one line try to use a l:l
    if l:end[0] == l:begin[0]
    endif

    if l:mode == 'V'
            " use blocks
            return
        endif
        " use a line
        exe "normal C".l:l
        return
    endif

    " do comment
endfu

ono ii <Cmd>call Indent(0)<CR>
ono ai <Cmd>call Indent(1)<CR>
vno ii <Cmd>call Indent(0)<CR>
vno ai <Cmd>call Indent(1)<CR>
fu! Indent(around) " I105
    " align mark `< and `>
    if match(mode(), 'o\|x') != -1
        normal! gv`[o`]
    endif
    let l:begin = getpos("`<")[1]
    let l:end   = getpos("`>")[1]
    let l:indent = len(matchstr(getline(l:begin), '^ *'))
    if a:around

endfu
fu! IndentLevel(line)
    if empty(a:line)
        return -1
    endif
    len(matchlist(a:line, '\(^[\t ]*\)[^\t ]')[1])
endfu

" digraphs
" take a look at :digraphs for handling apl input
" join
dig ji 10781 j] 10197 j[ 10198 jo 10199
" open circle arrows
dig <Q 8634 >Q 8635
dig := 8788 =: 8789

" compress digraphs after the fact
nn < <Cmd> exe "normal! diW"<bar>exe "normal! a\<C-k>".@"<CR>

no 0 <Cmd>if col('.') - 1<bar>exe "normal! 0"<bar>else<bar> exe "normal! $"<bar>endif<CR>

fu! S105() " called for textobj (i)ndent
    let l:correct = ''
    if visualmode() != <C-v>
        let l:correct = '\<C-v>'
    endif
    exe 'normal! '.l:correct.'0I\<tab>'
endfu
" highlight hex color codes with that color
" mostly for editing ricer themes
fu! Colorify()
    aug Colorify
        au!
        au InsertLeave,TextChanged <buffer> call Colorify()
    aug END
    for line in getline(1, line('$'))
        let l:hex = matchstr(line, '\x\{6}')
        exe 'let l:bright=(0x'.l:hex[0:1].'+0x'.l:hex[2:3].'+0x'.l:hex[4:5].' > 384) ? "000000" : "ffffff"'
        exe 'syn keyword BG'.l:hex.' '.l:hex
        exe 'hi BG'.l:hex.' guibg=#'.l:hex.' guifg=#'.l:bright
    endfor
endfu


" autocmd FileType sh vmap 'e '"gv:s/\([$"]\)/\\\1/g<CR>
" vnoremap '/ c/**/<ESC>hPll

" XXX - one per line
" https://github.com/justinmk/vim-sneak
" no <expr> f "/".nr2char(getchar().nr2char(getchar())."/<CR>"
" is there a good reason we dedicate fFtT;,nN/? all to seeking to characters?
"

" file navigation
" learn/configure netrw instead can we still get git integration?
" cd NERDTree along with self or rather wouldn't it be better to move self along with a terminal cd?
" unify fzf 'open in split/vsplit' with nerdtree/netrw keybindings
" use b:root=directory?

" text objects
" for each text object X define a function SX such that SX(I) matches 'aX' and 'iX' matches I
" shortcut Ctrl+/ to toggle comment with Surround and ic/ac

" sys integration
" au CursorHold try :wa?
" map <A-r> exe '!ricer' | source $MYVIMRC
" copy and paste
" no <C-v> <Cmd>set paste<CR>p<Cmd>set nopaste<CR>
"   we can still send <C-c> to terminal, so no tmap
" neovide?
" it would be super cool to embed firefox/a browser as a split 
" open http:// in browser
" horizontal scrolling https://github.com/alacritty/alacritty/issues/2185
" i3 as nvim? can we use i3 to do splits and tabs (to a single nvim server in the background)
"   which would let us have a 'split' for external programs? like a virtual i3:// handler
"   wi³nk - winc[md] and i3
"   use selenium / firefox --marionette for allowing vim-style motions and text input
"   see: https://github.com/fu5ha/i3-vim-nav
"   see: https://github.com/mhinz/neovim-remote
"   see: `i3-msg -t get_tree` with :help json_encode()
"   xdg-open urls etc.

" language integration
" python ide in vim
" project specific 'actions'
" language support LSP https://neovim.io/doc/lsp/
"   shell
"   python - virtualenv aware
"   javascript
" golang setup (equalprg=gofmt) https://github.com/fatih/vim-go
" https://github.com/sheerun/vim-polyglot

" save/restore open files / layout
" airline?
" git
"   shortcut for GitGutterDiffOrig
"   show git status in nerdtree
"   native diff / merge - vim-fugitive

" colors
" what does the dracula theme actually get us https://github.com/dracula/vim/blob/master/autoload/dracula.vim
"   set termguicolors, but use colorscheme based on ansi codes?

" markdown support
" fold on headers/lists
" change/renumber lists (~)
" toggle checklists
" indent text object
let g:markdown_folding = 1
" misc
" write to readonly file https://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work
" '<,'>p without changing clipboard contents?
" https://github.com/Konfekt/vim-CtrlXA
" custom start page https://github.com/mhinz/vim-startify
" bionic reading mode? https://bionic-reading.com/
" let 'gf' open urls in browser
" alter url-click behavior to open in firefox
