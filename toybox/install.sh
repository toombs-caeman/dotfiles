#!/usr/bin/env bash
# installing all the dependencies for dotfiles


here="$(cd "${BASH_SOURCE%/*}"; pwd)"
echo "installing to $here"
read -p  "Ctrl-C to cancel or Enter to continue"
echo continuing


has() { command -v "$@" >/dev/null ; }
missing() { for a in "$@"; do has "$a" || echo "$a"; done; }
# require that a command exists in $PATH, try to install it
require() {
    has "$@" && return
    has apt-get && sudo apt-get install "$(missing "$@")" && return
    has brew && sudo brew install "$(missing "$@")" && return
    has pip3 && sudo pip3 install "$(missing "$@")" && return
    has pip && sudo pip install "$(missing "$@")" && return
    return 1
}
require zsh kak fzf chevron || return 1

[ -f ~/.gitconfig ] || echo ln -s $here/git/gitconfig ~/.gitconfig
# TODO login level stuff goes to ~/.profile
#   ricer?
# TODO source rc.sh in .zshrc and .bashrc

# TODO test suite, install script, check for missing core programs
# TODO add check_install() for linking self to ~/.bashrc and ~/.zshrc via ricer and giving warnings
background_dir=~/Pictures/Wallpapers
template_dir=templates

if has xrdb; then
    chevron $template_dir/Xresources.template > ~/.Xresources
    xrdb -load ~/.Xresources
fi
if has i3-msg; then
    chevron $template_dir/i3config.sh >~/.i3/config
    i3-msg restart
fi
if has alacritty; then
    chevron $template_dir/alacritty.yml > ~/.alacritty.yml
fi

