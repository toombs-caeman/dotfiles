take your config stuff with you when you shell around.

This stuff is changing a lot at the moment so be careful using anything, it is probably a little broken. On the other hand if you see something you like feel free to take it.

# Core components

* bash
* vim
* tmux
* ssh
* git
* xterm

My workflow is built around these tools so I've configured the crap out of them.
Also, since these tools are installed already (or easily available) on pretty much every linux box and I'm a minimalist nut I've attempted to reduce the dependencies of this entire project to only those 5 tools and the gnu coreutils, so that it's possible to have an immediately consistent experience on any machine or linux flavor.

# New Tools
a few new command/scripts have been written, and put in bash_include/

* pm - Prime Minister

A unified interface for package management. Have a fedora, ubuntu, and arch machine? Ever forget how to install things for each separate system? Don't remember if you installed that package through pip, npm or apt? The Prime Minister has got your back. pm will install packages through the highest priority package manager which provides the package and remove them from any manager which has that package installed. Still a work in progress and is only intended to support basic usage common across most managers (install, remove, query available, list installed).

* subtool

A utility used to create a bash function with the 'subcommand' pattern. It also provides automatic help commands and will soon provide bash completions for the subcommand names. Totally not trying to create namespaces in a scripting language *cough cough*

* infect

used to inject options, autoupdate the repo, create prefixed subshells, etc.

# TODO

* update repo with git subtree pattern to include plugins rather than directly include them
* make test docker container to try to thoroughly isolate files to REMOTE_CONFIG_DIR
* trim the fat, try to get the total size down to a few kilobytes
    * main culprit is vim/vim81, most of which isn't needed
        - remove translation files, examples
* pushd/popd?
* figure out the best search/indexing option
    * find
    * grep -rn

## subtool

* SUBTOOL slightly BREAKS PARAMETER PASSING!!!
    * this is given a hard fix with the ${argv[0]} syntax
    * need to have more extensive testing
* add proper getopt support
* add bash completions to subtool
    * https://stackoverflow.com/questions/17879322/how-do-i-autocomplete-nested-multi-level-subcommands

## pm

* restructure to search each manager for the package before attempting to install it
* add more managers
* add 'select' command? only install the first of a list of options
* use pm to install core programs on infect install
    * neovim
    * tmux
    * mosh
    * peco/fzf
    * git

## infect

* prefix seems to break bash completion for everything after exit
* fix ssh passthrough and add infect install
* change infect ssh to use mosh, default to ssh

## xterm

* expect at least xterm 256 and possibly xterm full color
* introduce terminal font 'powerline/hack' or maybe a full unicode font
* include xresources to set color palette/font on xterm-likes `xrdb`

## vim

* add feature detection to vimrc since different systems will have different features compiled in by default
* integrate t/T tabbing with :term
    * how to detect vim from bash?
* how to get the directory of the current file instead of where vim was opened?
* search
    * git repo level search
    * search relative to the current file
    * in text search
    * find usages
* open links with xdg-open/lynx/elinks
* https://alex.dzyoba.com/blog/vim-revamp/
* autocomplete |ins-completion|
* sessions
* git integration (vimagit?)
* plugin commentary
* plugin netwr
    - https://shapeshed.com/vim-netrw/#netrw-the-unloved-directory-browser
    - can be used to browse over ssh/mosh, inspect directories
    - https://kgrz.io/editing-files-over-network.html
* https://thoughtbot.com/blog/seamlessly-navigate-vim-and-tmux-splits
* vim-terraform syntax
* language based linting integration

## integrations

some things need to be integrated among each core component.

* SOLARIZED theme
    - https://github.com/altercation/solarized
    - tmux
    - bash
    - vim
* consistent/integrated status line
    - vim
    - tmux
    - bash
* substitute vim sessions when tmux isn't available
* configure clipboard integration for X, wayland
    * looks like neovim has wayland support through wlclipboard, which vim8 might not
* vim-tmux
    * add mouse select pane for tmux
        * integrate with vim to also pass through to move the cursor

## potential additions
* i3 config
* bash_include/tuikit.sh - for tui based commands 
