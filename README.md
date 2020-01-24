This repository is intended as a one stop shop for maintaining a consistent configuration across several machines.

This allows a fully functional copy of the repo with only `git clone`, while still keeping project histories cleanly separate.

# Principles
* context should be:
	* on a per shell basis
	* dislayed clearly in the prompt
	* unchanging, unless explicitly set in that session
* context includes
	* history - separate global and shell searching
	* prompt
	* shortcuts
	* path/declarations
* include subprojects using [git-subrepo](https://github.com/ingydotnet/git-subrepo).

# Installation

direct installation is not recommended. Instead use this as a pattern for constructing you're own dotfiles.
If you fork this repo for your own use, you will want to change:
* contexts/default/
* themes.yml
* the prompt in pretty.sh

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
* bat
* ripgrep
* exa
* fzf

# TODO: general
* set fzf to use rg as the search command
* bring shell up to zsh
* git subrepo push
* git workflow
	* forgit interactive git https://github.com/wfxr/forgit
	* update git aliases
* consider moving fully to exa/kak/fzf. making use of moreutils.
* git-fzf search is broken?, try combining with 'git grep' or ripgrep

# TODO: linux graphics pipeline
* copy mac keybindings to bring over to linux
* fix dmenu launch replacement, needs some history
* include bash profile to initialize graphical interface
* nail down graphics pipline for x and wayland
    - make switch configurable through ricer
    - X
        * i3
        * feh
        * dunst
        * conky maia
    - wayland
        * sway
        * swaybg
        * mako
        * system monitor?
* notifications? http://blog.z3bra.org/2014/04/pop-it-up.html
* oomox for theming gtk icons?
* https://wiki.installgentoo.com/index.php/GNU/Linux_ricing
* https://old.reddit.com/r/wallpaperdump/

# TODO: Cygwin
* add brew to pm
* track xdg-settings, somehow unify xdg-open and mac's open -a

## potential additions / things to look at
* https://old.reddit.com/r/dotfiles/
* http://dotfiles.github.io/
* https://old.reddit.com/r/startpages/
* include whitefox layout
* unified backup utility, use restic?
* firefox
    - userChrome.css
    - https://www.userchrome.org/how-create-userchrome-css.html
    - https://userstyles.org/styles/98305/solarized-dark-everywhere
    - https://old.reddit.com/r/FirefoxCSS/
* mosh
* https://github.com/andreyorst/fzf.kak
* path extractor https://github.com/edi9999/path-extractor
* entr for inotifywatch like file change watching
* gron for grepping json
