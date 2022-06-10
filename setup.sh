#!/bin/sh

DOTROOT=~/my
# try to be idempotent
# fail if any command fails
set -e
PACKAGES=''
# update package list and packages
if command -v apt; then
    # for ubuntu
    sudo apt update
    sudo apt upgrade
    INSTALL='sudo apt install '
    PACKAGES+=' i3 picom'
fi
if command -v pacman; then
    # for manjaro-i3 
    sudo pacman -Syu
    INSTALL='sudo pacman -S --needed '
    PACKAGES+=' yay'
    # yay -S --needed
    EXTRA='nerd-font-fira-code'
fi

# laptop settings, what condition to check?
if true; then
    # battery check?
fi
PACKAGES+=' git firefox zsh neovim fzf feh'
eval "$INSTALL $PACKAGES"
sudo chsh -s "$(which zsh)" "$(whoami)"
# sudo ln -s libinput.conf
# sudo ln -s gitconfig


# setup dotfiles
mkdir -p $DOTROOT/toombs-caeman
git -C $DOTROOT/toombs-caeman clone https://github.com/toombs-caeman/dotfiles
git -C $DOTROOT/toombs-caeman/dotfiles remote set-url origin git@github.com:toombs-caeman/dotfiles.git
# TODO idempotent add to file? maybe add comment line as marker?
echo "PATH=\"\$PATH:$DOTROOT/toombs-caeman/dotfiles/bin\"" >> ~/.profile
echo ". $DOTROOT/toombs-caeman/dotfiles/rc.sh" >> ~/.bashrc
echo ". $DOTROOT/toombs-caeman/dotfiles/rc.sh" > ~/.zshrc
. ~/.profile

# get a background image
WDIR=~/Pictures/Wallpapers
mkdir -p "$WDIR"
# TODO this is glitchy as fuck, from https://onlinepngtools.com/generate-1x1-png
echo "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQIW2NgYGD4DwABBAEAwS2OUAAAAABJRU5ErkJggg==" | base64 -d > "$WDIR/pixel.png"

# run usual reconfig
ricer -t dracula
logout

# XXX
# can we install ublock origin from the commandline?
# fonts? get FiraCode Nerd Font
# change tty resolution [change tty resolution](https://help.ubuntu.com/community/ChangeTTYResolution)
