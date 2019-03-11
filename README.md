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

* test more programs and add examples
* move bash history into config, gitignore
* add vim/airline tmux.line etc. for consistent powerlining
* create a consistent look and feel
    * really maybe this is a local term configuration?
    * introduce terminal font 'powerline/hack' or maybe a full unicode font
    * include xresources to set color palette on xterm-likes `xrdb`
    * consistent solarized theme based on xterm-256color
        - bash
        - vim
        - ranger
        - tmux
        - xterm
* trim the fat, try to get the total size down to a few kilobytes
    * main culprit is vim/vim81, most of which isn't needed
* configure rifle/scope to respect aliases
* make bash_includes/ and scripts
* add bash completions to subtool

