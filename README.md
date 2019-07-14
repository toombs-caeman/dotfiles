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
* rename remote_config.sh -> .profile
* rename themer -> ricer
* split out ricer and git extensions
* have nvim autoupdate nvim.appimage and pull the correct architecture

# TODO: Theming

probably want to separate this into a few stages.
* determine background image and palette
    * http://charlesleifer.com/blog/suffering-for-fashion-a-glimpse-into-my-linux-theming-toolchain/
    * http://blog.z3bra.org/2015/06/vomiting-colors.html
* template config files with the palette
    - https://www.reddit.com/r/unixporn/comments/8giij5/guide_defining_program_colors_through_xresources/
* execute callbacks to update running programs
* default to solarized theme https://github.com/altercation/solarized

ideas:
* palette creation should fail if the input image isn't very color diverse
    - this should prevent any unreadable configs
* may want to steer around xresources considering wayland is a thing
* fonts
* https://wiki.installgentoo.com/index.php/GNU/Linux_ricing

components:
* i3 / sway
* vim
* alacritty
* firefox
    - userChrome.css
    - https://userstyles.org/styles/98305/solarized-dark-everywhere

## TODO: vim

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