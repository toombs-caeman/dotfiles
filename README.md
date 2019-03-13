take your config stuff with you when you shell around.

Only really for basic config files like:
* .vimrc
* .bashrc
* .tmux.conf
* ranger

but others might work alright

# Design

This script creates bash aliases which inject a custom config path.
This is prefered over simlinks or copying files out to the usual locations so that config on the remote is not persistent.
The aliases will disappear after logout

# Configuration
all config files are kept in a directory and enabled with a special enable_configs file
For now this directory must be

# Usage

To install locally, clone, and add the following the ~/.bashrc

```
source ~/path/to/repo/remote_config.sh
```
This should really be the only thing in there.


To use call:
```
ssh user@remote remote_config.sh
```
OR
```
mosh user@remote ghost.sh
```

This will start a bash session on the remote with all the correct aliases in place.


# TODO

* add ssh pass through for infect
* add bash completions to subtool
    * https://stackoverflow.com/questions/17879322/how-do-i-autocomplete-nested-multi-level-subcommands
* change infect ssh to use mosh, default to ssh
* create some sort of vault?
* print warnings if core programs not found
    * vim
    * tmux
    * mosh
    * browsh
    * peco/fzf
    * 
    * use pm to install core on 'infect install'
* tmux
    * integrate with vim split
        - https://thoughtbot.com/blog/seamlessly-navigate-vim-and-tmux-splits

* make test docker container to try to thoroughly isolate files to REMOTE_CONFIG_DIR
    * move bash history into config, gitignore
* create a consistent look and feel
    * SOLARIZED
        - https://github.com/altercation/solarized
        - tmux
        - bash
        - vim
    * powerline?
        - vim
        - tmux
        - bash
    * xterm
        - expect at least xterm 256 and possibly xterm full color
        - introduce terminal font 'powerline/hack' or maybe a full unicode font
        - include xresources to set color palette/font on xterm-likes `xrdb`
* trim the fat, try to get the total size down to a few kilobytes
    * main culprit is vim/vim81, most of which isn't needed
        - remove translation files, examples
    * get rid of ranger, replace with netwr w/ config
        - https://shapeshed.com/vim-netrw/#netrw-the-unloved-directory-browser
* add browsh
* re add mouse support for vim
* add mouse select pane for tmux
    * integrate with vim to also pass through to move the cursor

* include i3 config
* bind tab to a function that allows complete and menu-complete w/ background highlights
* vim plugins
    * netwr
        - can be used to browse over ssh/mosh, inspect directories
        - https://kgrz.io/editing-files-over-network.html
    * ctags?
    * vim-tmux
