#!/usr/bin/env nu

# set up nushell environment
# the only external command this should rely on already existing is pacman; it will try to download other dependencies with pacman.
#
# keep state in a yaml file /path/to/repo/.state
# track config files and their hashes
# note if a file has changed from its hash before overwritting it
# if a file is not yet tracked and exists, don't overwrite it


install() {
    # function is run once
    # TODO list all dependencies
    sudo pacman -S --needed --noconfirm nushell starship neovim fzf

    # TODO generate nushell config

    # enable starship
    mkdir ($nu.data-dir | path join "vendor/autoload")
    starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
}

update() {
    # update config files
    # update vim packages
}



# TODO cd to git root or fail

# run once
# TODO .gitignore lock file
if [ ! -f .state ]; then
    install
fi
update
