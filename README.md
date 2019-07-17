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

# TODO: misc
* rename remote_config.sh -> rc
* include .bash_profile to initialize graphical interface
* oomox for theming gtk icons?
* nail down graphics pipline for x and wayland
    - make switch configurable through ricer
    - X
        * i3
        * feh
        * dunst
        * conky_maia
    - wayland
        * sway
        * swaybg
        * mako
        * system monitor?
* emulate dmenu with https://github.com/swaywm/sway/issues/1367#issuecomment-495306710
* move git-subrepo out of bin/
    - it doesn't really need to be on the path

# TODO: Theming

* https://wiki.installgentoo.com/index.php/GNU/Linux_ricing

* vim
* firefox
    - userChrome.css
    - https://www.userchrome.org/how-create-userchrome-css.html
    - https://userstyles.org/styles/98305/solarized-dark-everywhere

## TODO: vim

* have nvim autoupdate nvim.appimage and pull the correct architecture
* break vim into a self contained subrepo
* theme with this: https://stackoverflow.com/questions/37400174/can-i-set-the-vim-colorscheme-from-the-command-line
    - this will leave the self contained theme intact when ricer isn't available
configure plugins:
* Plug looks pretty easy to use
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

## potential additions / things to look at
* some sort of detach/reattach program
    * http://www.brain-dump.org/projects/abduco/
    * tmux
    * dtach
* criu 
    - checkpoint and restore processes over reboot 
    - https://access.redhat.com/articles/2455211
    - could be used for remote sessions

* https://old.reddit.com/r/dotfiles/
* http://dotfiles.github.io/

* https://old.reddit.com/r/startpages/
* https://old.reddit.com/r/FirefoxCSS/
* https://old.reddit.com/r/wallpaperdump/

* include whitefox layout

* https://www.divio.com/blog/documentation/

* track xdg-settings?
* notifications?
    - sway -> mako
    - i3 -> dunst
    * http://blog.z3bra.org/2014/04/pop-it-up.html
