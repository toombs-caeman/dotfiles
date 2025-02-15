# dotnu

Portable dotfiles based on nushell

arch + hyprland + kitty + nushell + neovim

# Installation
0. requires git and nushell
    * windows: `winget install Git.Git Nushell.Nushell`
    * ubuntu: `sudo apt install git nushell`
    * mac: `brew install git nushell`
    * arch: `sudo pacman -S git nushell`
1. clone repository and run imbue hook
```shell
# clone repository
git clone git@github.com:toombs-caeman/dotfiles.git
cd dotfiles
bin/imbue with templates/mana.yaml
```

# Imbue ISO
[create an install image](iso/README.md)

# applications
preferred application, though not installed by default
* audacity - editing audio
* krita - editing images
* godot - writing games
* steam - gaming

# publicity
* dotfiles
    * [dotfiles](https://dotfiles.github.io/)
    * [awesome-dotfiles](https://github.com/webpro/awesome-dotfiles)
    * [arch dotfiles](https://wiki.archlinux.org/title/Dotfiles)

* imbue
    * [awesome-nu](https://github.com/nushell/awesome-nu)
    * [nupm](https://github.com/nushell/nupm)
