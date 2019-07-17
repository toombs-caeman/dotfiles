take your config stuff with you when you shell around.

This stuff is changing a lot at the moment so be careful using anything, it is probably a little broken. On the other hand if you see something you like feel free to take it.

# Installation

direct installation is not recommended.

`git clone https://github.com/toombs-caeman/dotfiles ~/.remote_config && ~/.remote_config/remote_config.sh`


# Dependencies

core components are expected:
* bash
* coreutils

# TODO: misc
* create some sort of requirements format for required packages.
    - fzf neovim-remote mosh git
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
    - also change rc to match path

# TODO: Theming

* https://wiki.installgentoo.com/index.php/GNU/Linux_ricing

* vim
* firefox
    - userChrome.css
    - https://www.userchrome.org/how-create-userchrome-css.html
    - https://userstyles.org/styles/98305/solarized-dark-everywhere
    - https://old.reddit.com/r/FirefoxCSS/

## potential additions / things to look at
* some sort of detach/reattach program
    * http://www.brain-dump.org/projects/abduco/
    * not tmux
    * dtach
* criu 
    - checkpoint and restore processes over reboot 
    - https://access.redhat.com/articles/2455211
    - could be used for remote sessions

* https://old.reddit.com/r/dotfiles/
* http://dotfiles.github.io/

* https://old.reddit.com/r/startpages/
* https://old.reddit.com/r/wallpaperdump/

* include whitefox layout

* https://www.divio.com/blog/documentation/

* track xdg-settings?
* notifications?
    - sway -> mako
    - i3 -> dunst
    * http://blog.z3bra.org/2014/04/pop-it-up.html
