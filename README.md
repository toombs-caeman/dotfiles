This repository is intended as a one stop shop for maintaining a consistent configuration across several machines.

Sub-projects are included using [git-subrepo](https://github.com/ingydotnet/git-subrepo).
This allows a fully functional copy of the repo with only `git clone`, while still keeping project histories cleanly separate.


# Installation

direct installation is not recommended. Instead use this as a pattern for constructing you're own dotfiles.

If you are interested in using this repo directly, it's probably better to make your own fork. Also beware that running ricer may overwrite important config files on your system.

# cygwin considerations
* redo terminal colors https://github.com/mathiasbynens/dotfiles/blob/master/.bash_prompt
    - may need modification considering ricer
* The default shell is zsh
* alacritty is basically non-functional, so base on iterm3 instead.
* ricer is essentially useless here
* still need to fix the shell commands a bit. cd is squirrelly
* consider moving fully to exa/kak/fzf. making use of moreutils.
* add brew to pm
* git-fzf search is broken?
 
* make a context switcher that will set things like the git folder, venv folder
    - context
    - REMOTE_CONFIG_DIR
    - GIT DIRS
    - GIT REMOTE
    - VENV DIRS

``` bash
git clone https://github.com/toombs-caeman/dotfiles ~/.remote_config
echo . ~/.remote_config/rc >> ~/.bashrc
```


# Dependencies

core components are expected:
* alacritty or iterm2
* bash or zsh
* coreutils

tools will be configured if they are available:
* kubectl
* python virtualenv
* golang
* git
* mosh

# TODO: misc
* fix dmenu launch replacement, needs some history
* create some sort of requirements format for required packages.
    - fzf mosh git
* include .bash_profile to initialize graphical interface
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
* notifications? http://blog.z3bra.org/2014/04/pop-it-up.html

# TODO: Theming

* https://wiki.installgentoo.com/index.php/GNU/Linux_ricing

future:
* firefox
    - userChrome.css
    - https://www.userchrome.org/how-create-userchrome-css.html
    - https://userstyles.org/styles/98305/solarized-dark-everywhere
    - https://old.reddit.com/r/FirefoxCSS/
* track xdg-settings
* oomox for theming gtk icons?
* https://old.reddit.com/r/wallpaperdump/

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

* include whitefox layout

* https://www.divio.com/blog/documentation/
* unified backup utility, use restic?
