take your config stuff with you when you shell around.

This stuff is changing a lot at the moment so be careful using anything, it is probably a little broken. On the other hand if you see something you like feel free to take it.

# Installation

direct installation is not recommended.

`git clone https://github.com/toombs-caeman/dotfiles ~/.remote_config && ~/.remote_config/remote_config.sh`

# Dependencies

core components are expected:
* bash
* coreutils

extra components will cause graceful degradation if not found:
* git
* ssh
* mosh
* fzf

# TODO: Theming
ideas:
* http://charlesleifer.com/blog/suffering-for-fashion-a-glimpse-into-my-linux-theming-toolchain/
* solarized theme as default? https://github.com/altercation/solarized
* fonts
* https://wiki.installgentoo.com/index.php/GNU/Linux_ricing

components:
* i3
* vim
* xterm
* .Xresources

## TODO: vim

configure plugins:
* nvr https://github.com/mhinz/neovim-remote
    * https://hkupty.github.io/2016/Ditching-TMUX/
    * setup terminal escapes
* netwr
    - https://shapeshed.com/vim-netrw/#netrw-the-unloved-directory-browser
    - can be used to browse over ssh/mosh, inspect directories
    - https://kgrz.io/editing-files-over-network.html
* more at https://github.com/tpope/
    * commentary https://github.com/tpope/vim-commentary
    * git integration (vimagit/vim-fugitive)

other:
* syntax highlighting for
    * terraform
    * rustlang
    * golang  https://github.com/fatih/vim-go
* correct panel movement
* setup fzf/git-fzf bindings
* how to get the directory of the current file instead of where vim was opened for netwr?
* open links with xdg-open/lynx/elinks
* https://alex.dzyoba.com/blog/vim-revamp/
* sessions
* https://thoughtbot.com/blog/seamlessly-navigate-vim-and-tmux-splits
* vim sessions?

## potential additions / things to look at
* https://github.com/rhysd/NyaoVim
* some sort of detach/reattach program
    * http://www.brain-dump.org/projects/abduco/
    * tmux
    * dtach
* criu 
    - checkpoint and restore processes over reboot 
    - https://access.redhat.com/articles/2455211
    - could be used for remote sessions
* fonts
* http://blog.z3bra.org/2014/04/pop-it-up.html
* http://blog.z3bra.org/2015/06/vomiting-colors.html
* https://old.reddit.com/r/dotfiles/
* http://dotfiles.github.io/

* https://old.reddit.com/r/startpages/
* https://old.reddit.com/r/FirefoxCSS/
* https://old.reddit.com/r/wallpaperdump/

* include whitefox layout