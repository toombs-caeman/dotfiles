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

# default installation
see [mana.yaml](templates/mana.yaml)
* hyprland
    * waybar
    * mako

* kitty
    * nushell
* firefox

# applications
preferred application, though not installed by default
* audacity - editing audio
* krita - editing images
* obs - livestreaming
* godot - writing games
* steam - gaming
* xournalpp - pdf editing & signing
* asciinema - terminal recording

# tabless firefox
* convert every new tab to a window [extension](https://github.com/jscher2000/I-Hate-Tabs---SDI-extension)
* enable userChrome: go to `about:config`, and change the value of `toolkit.legacyUserProfileCustomizations.stylesheets` to true.
* copy userChrome.css to `~/.mozilla/firefox/*.default/chrome/userChrome.css`

# publicity
* dotfiles
    * [dotfiles](https://dotfiles.github.io/)
    * [awesome-dotfiles](https://github.com/webpro/awesome-dotfiles)
    * [arch dotfiles](https://wiki.archlinux.org/title/Dotfiles)

* imbue
    * [awesome-nu](https://github.com/nushell/awesome-nu)
    * [nupm](https://github.com/nushell/nupm)
