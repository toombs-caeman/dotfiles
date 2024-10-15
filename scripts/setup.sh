#!/bin/sh
# try to be idempotent
# fail if any command fails

install() { yay -S --needed "$@"; }
s_sys() {
    # based on [endeavour](https://endeavouros.com/latest-release/)
    # select the i3 option
    sudo pacman -Syu
    # sudo pacman -S --needed yay i3-wm i3status i3lock picom
    install  xautolock yay ripgrep xclip ttf-firacode-nerd git firefox zsh neovim fzf bat feh kitty
    sudo chsh -s "$(which zsh)" "$(whoami)"
    timedatectl set-ntp yes
    # needed for nvim integrations, sadly
    install nodejs npm xclip
    install python python-pip

    # reverse the default scroll direction
    #sudo ln -fs "$(git rev-parse --show-toplevel)/templates/libinput.conf" /usr/share/X11/xorg.conf.d/99-libinput.conf
    # let our i3config refer to a generic emulator, but actually use kitty
    #sudo ln -fs "$(which kitty)" /usr/bin/x-terminal-emulator

    # media
    install blender krita godot lmms ardour

    # rust language
    # install toolchain installer
    install rustup
    # install default toolchain
    rustup install default stable
    
    # android studio
    install android-studio

    # audio
    install mpd mpc ffmpeg yt-dlp picard rsgain-git
    systemctl --user enable mpd.service
    systemctl --user start mpd.service
    #pactl list short sink # list soundcards
    #pactl set-default-sink alsa_output.pci-0000_28_00.3.analog-stereo

    # mime
    #xdg-mime default firefox.desktop x-scheme-handler/http
    #xdg-mime default firefox.desktop x-scheme-handler/https
}
s_dot() {
    # TODO git calls need to be idempotent
    DOTROOT=~/my
    # setup dotfiles
    mkdir -p $DOTROOT/toombs-caeman
    git -C $DOTROOT/toombs-caeman clone https://github.com/toombs-caeman/dotfiles
    git -C $DOTROOT/toombs-caeman/dotfiles remote set-url origin git@github.com:toombs-caeman/dotfiles.git
    echo "PATH=\"\$PATH:$DOTROOT/toombs-caeman/dotfiles/bin\"" >> ~/.zprofile
    echo ". $DOTROOT/toombs-caeman/dotfiles/rc.sh" >> ~/.bashrc
    echo ". $DOTROOT/toombs-caeman/dotfiles/rc.sh" > ~/.zshrc
    . ~/.profile

    # get a background image
    # TODO just include one rather than this mess
    WDIR=~/Pictures/Wallpapers
    mkdir -p "$WDIR"
    echo "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQIW2NgYGD4DwABBAEAwS2OUAAAAABJRU5ErkJggg==" | base64 -d > "$WDIR/pixel.png"
    # TODO this is glitchy as fuck, from https://onlinepngtools.com/generate-1x1-png
    # run usual reconfig
    ricer -t spacedust2
}
s_gui() {
    install greetd
    # edit /etc/greetd/config.toml to launch /usr/bin/sway
    install sway wl-clipboard swaylock sway-idle swaybar slurp grim
    install firefox kitty
}
s_laptop() {
    # TODO brightness and screen lock settings
    :
}
s_media() {
    install krita blender godot android-studio ardour8

    install steam proton-ge-custom-bin

    # music
    install mpd mpc ffmpeg yt-dlp rsgain-git
    systemctl --user enable mpd.service
    systemctl --user start mpd.service
}

s_grub() {
# [change tty resolution](https://superuser.com/questions/526757/how-to-change-the-resolution-of-the-tty-on-arch-linux)
    # replace with ${resolution}x32
    #GRUB_GFXMODE=1024x768x32
    sudo sed -i 's/^GRUB_GFXMODE.*$/GRUB_GFXMODE=1024x768x32/' /etc/default/grub
    # remove grub menu timer when booting normally
    sudo sed -i 's/^GRUB_TIMEOUT_STYLE.*$/GRUB_TIMEOUT_STYLE=hidden/' /etc/default/grub
    # apply changes
    sudo grub-mkconfig -o /boot/grub/grub.cfg
}
# XXX
# can we install ublock origin from the commandline?


