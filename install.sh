#!/usr/bin/env bash
here="$(cd "${BASH_SOURCE%/*}"; pwd)"
echo "installing to $here"
read -p  "Ctrl-C to cancel or Enter to continue"
echo continuing

[[ -f ~/.gitconfig ]] || echo ln -s $here/git/gitconfig ~/.gitconfig
# TODO login level stuff goes to ~/.profile
#   ricer?
# TODO source rc.sh in .zshrc and .bashrc

# TODO test suite, install script, check for missing core programs
# TODO add check_install() for linking self to ~/.bashrc and ~/.zshrc via ricer and giving warnings
