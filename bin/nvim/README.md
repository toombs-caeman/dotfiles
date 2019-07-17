my self-contained nvim configuration.

uses [git subrepo](https://github.com/ingydotnet/git-subrepo) and vim8's pack to include plugins

# Try it
``` bash
git clone https://github.com/toombs-caeman/scnvim
cd scnvim
./nvim
```

#TODO
* nvr https://github.com/mhinz/neovim-remote
    * configure as git editor


* have nvim autoupdate nvim.appimage and pull the correct architecture
configure plugins:
* Plug looks pretty easy to use
    * https://hkupty.github.io/2016/Ditching-TMUX/
    * setup terminal escapes
* netwr
    - https://shapeshed.com/vim-netrw/#netrw-the-unloved-directory-browser
    - can be used to browse over ssh/mosh, inspect directories
    - https://kgrz.io/editing-files-over-network.html
* more at https://github.com/tpope/
    * commentary https://github.com/tpope/vim-commentary
    * git integration (vimagit/vim-fugitive)
* more at https://github.com/akrawchyk/awesome-vim
    * vim-indent-guides
    * targets.vim
    * vim-lastplace

other:
* syntax highlighting for
    * terraform
    * rustlang
    * golang  https://github.com/fatih/vim-go
* correct panel movement
* how to get the directory of the current file instead of where vim was opened for netwr?
* open links with xdg-open/lynx/elinks
* https://alex.dzyoba.com/blog/vim-revamp/
* sessions
* https://thoughtbot.com/blog/seamlessly-navigate-vim-and-tmux-splits
* vim sessions?
* default 'IDE' panels
* default file manager panels (netwr)
* https://github.com/rhysd/NyaoVim
