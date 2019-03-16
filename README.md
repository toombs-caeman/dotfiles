take your config stuff with you when you shell around.

Only really for basic config files like:
* .vimrc
* .bashrc
* .tmux.conf

but others might work alright

# Design

# Configuration

# Usage

# TODO
* configure find for vim open

* prefer neovim
    - add 'select' command to pm? only install the first of a list of options
* update repo with git subtree pattern to include plugins

* make test docker container to try to thoroughly isolate files to REMOTE_CONFIG_DIR
    * move bash history into config, gitignore
* trim the fat, try to get the total size down to a few kilobytes
    * main culprit is vim/vim81, most of which isn't needed
        - remove translation files, examples
    * get rid of ranger, replace with netwr w/ config
        - https://shapeshed.com/vim-netrw/#netrw-the-unloved-directory-browser
* backup script
* integrate t/T tabbing with terminal
* configure clipboard integration for X, wayland
    * looks like neovim has wayland support through wlclipboard, which vim8 might not
* SUBTOOL slightly BREAKS PARAMETER PASSING!!!
    * this is given a hard fix with the ${argv[0]} syntax
## bash includes
* add ssh pass through for infect
* add bash completions to subtool
    * https://stackoverflow.com/questions/17879322/how-do-i-autocomplete-nested-multi-level-subcommands
* change infect ssh to use mosh, default to ssh

## additions
* browsh
    - maybe not, requires firefox to be running, full color terminal
* i3 config
##look and feel
* SOLARIZED
    - https://github.com/altercation/solarized
    - tmux
    - bash
    - vim
* consistent/integrated status line
    - vim
    - tmux
    - bash
* xterm
    - expect at least xterm 256 and possibly xterm full color
    - introduce terminal font 'powerline/hack' or maybe a full unicode font
    - include xresources to set color palette/font on xterm-likes `xrdb`

##integrations:
* use pm to install core programs on infect install
    * vim
    * tmux
    * mosh
    * peco/fzf
    * git
* vim-tmux
    * add mouse select pane for tmux
        * integrate with vim to also pass through to move the cursor
    * https://thoughtbot.com/blog/seamlessly-navigate-vim-and-tmux-splits

# plugins
* vim
    * netwr
        - can be used to browse over ssh/mosh, inspect directories
        - https://kgrz.io/editing-files-over-network.html
    * ctags?
    * vim-tmux
    * vim-terraform
* tmux
