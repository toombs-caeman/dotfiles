# dotfiles

arch + hyprland + kitty + nushell + neovim

# Normal Usage
`bin/imbue` is a nushell script which manages installing and configuring programs.
* Config files kept under version control.
* Config files are templates which are rendered then written to their standard location.
* Config files don't overwrite changes made at the destination unless imbue is passed `-f`/`--force`
* Callbacks can notify programs that can hot-reload configuration
* Configuration is only written if the program being configured is present, unless `-i`/`--install` is passed.
    In that case it tries to install all configured tools first.
* `imbue` is itself configured with a yaml file.
    * `imbue with config.yml` sets the default configuration file.
    * The file itself is kept under git, and a stub is installed at a known location.
* `imbue watch` watches the templates directory for changes and automatically renders changed files.
* It also handles downloading music and wallpapers.

## Fresh Arch Installs
`bin/bootstrap` is used to create an custom arch linux disk image and a bootable flash drive.
* The ISO is modified to enable easy bootstrapping with these dotfiles.
* This part requires a bit more testing, since I don't spin up new machines that often,
    but it gets smoother every time I do.

## Mac / Windows Usage
It is possible in theory to use this same repo on a mac or windows machine, for a job or something,
but I've not done that since the last major rewrite.
* install base dependencies for `imbue`:
    * windows: `winget install Git.Git Nushell.Nushell`
    * ubuntu: `sudo apt install git nushell`
    * mac: `brew install git nushell`
* `imbue` would need a custom configuration, with the installer set to either `winget install` or `brew install`

# Manual Installation
1. clone repository and run imbue hook
```
# clone repository
git clone git@github.com:toombs-caeman/dotfiles.git
cd dotfiles
bin/imbue with templates/nix.yaml
```

# Preferred Applications
This is stuff I don't usually use/install often,
but I'd like to keep the list here so I don't forget about useful tools.

* audacity - editing audio
* krita - editing images
* obs - livestreaming
* godot - writing games
* steam - gaming
* xournalpp - pdf editing & signing
* asciinema - terminal recording
* docker - containers
