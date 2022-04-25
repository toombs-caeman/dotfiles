" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
if &compatible
  set nocompatible
endif

" plugins [vim-plug](https://github.com/junegunn/vim-plug)
call plug#begin()
Plug 'airblade/vim-gitgutter'       " show modified lines left of numbers
Plug 'preservim/nerdtree'           " file system explore
Plug 'Xuyuanp/nerdtree-git-plugin'  " show git status in NERDTree
" TODO Plug 'tpope/vim-surround'    " surround objects
" TODO Plug 'tpope/vim-fugitive'    " working with git
" TODO Plug 'dracula/vim', { 'as': 'dracula' } "colorscheme
call plug#end()

" status line
set wildmenu		        " display completion matches in a status line
set showcmd		            " display incomplete commands
set wildmode=longest,list   " get bash-like tab completions

" search
set ignorecase              " case insensitive matching
set hlsearch                " highlight search results
set incsearch               " Do incremental searching when it's possible to timeout.
                            " clear search highlights
nnoremap <ESC><ESC> :noh<CR>

" style
set number                  " add line numbers
set ruler		            " show the cursor position all the time
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
let NERDTreeMapQuit='Q'     " toggle nerdtree, even when focused on nerdtree
nnoremap Q :NERDTreeToggle<CR>


" keys
let mapleader=","
set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key

" persistence
set noswapfile              " don't write .*.swp files
set updatetime=100          " write swap after 100 ms, also update gitgutter
set history=200		        " keep 200 lines of command line history
augroup vimStartup          " When opening a file, always jump to the last known cursor position.
  au!
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif

augroup END

" visual movement
nnoremap j gj
nnoremap k gk

" TODO - one per line
" window shortcuts to <A-*> from <C-w>*
" buffer/tab shortcuts?
" nerdtree keybindings?
" ide() { cd "$1" && vi -S "$1".vim; }; __ide() { projects }
" project specific 'actions'
" terminal
" language support LSP https://neovim.io/doc/lsp/
"   shell
"   python - virtualenv aware
"   javascript
" save/restore open files / layout
" git
"   shortcut for GitGutterDiffOrig
"   show git status in nerdtree
"   native diff / merge - vim-fugitive
"
" visualize vim keymaps per mode+leader+modifier
" fzf.vim
" colorscheme https://github.com/dracula/vim/blob/master/autoload/dracula.vim
" shortcut Ctrl+/ to toggle comment https://github.com/preservim/nerdcommenter
" horizontal scrolling https://github.com/alacritty/alacritty/issues/2185
