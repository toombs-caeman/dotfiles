take your config stuff with you when you shell around.

This stuff is changing a lot at the moment so be careful using anything, it is probably a little broken. On the other hand if you see something you like feel free to take it.

# Dependencies

core components are expected:
* bash
* coreutils
* git

extra components will cause graceful degradation if not found:
* mosh
* ssh
* fzf


## vim

* integrate t/T tabbing with :term
    * how to detect vim from bash? use [[ ! -z $VIM ]]
* how to get the directory of the current file instead of where vim was opened for netwr?
* search
    * git repo level search (cd $(git rev-parse --show-toplevel) && grep -rn $1)
    * search relative to the current file
    * in text search
    * find usages
* open links with xdg-open/lynx/elinks
* https://alex.dzyoba.com/blog/vim-revamp/
* autocomplete |ins-completion|
* sessions
* plugin commentary
* plugin netwr
    - https://shapeshed.com/vim-netrw/#netrw-the-unloved-directory-browser
    - can be used to browse over ssh/mosh, inspect directories
    - https://kgrz.io/editing-files-over-network.html
    - fff instead?
* https://thoughtbot.com/blog/seamlessly-navigate-vim-and-tmux-splits
* syntax
    * terraform
    * fatih/vim-go
    * rustlang

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
* vim/tmux
    * substitute vim sessions when tmux isn't available
    * fine tune tmux/vim/vim-terminal/terminal interaction
* vim/git
    * git doesn't use vim config for editing commit messages (calls editor directly?)
    * git integration (vimagit?)

## potential additions
* i3 config
