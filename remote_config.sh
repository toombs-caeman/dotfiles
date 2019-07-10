#!/usr/bin/env bash
# Author    : Caeman Toombs

## BOILERPLATE {{{
## do nothing if not in an interactive shell
case $- in
    *i*) ;;
      *) return;;
esac
## SHOPT
shopt -s expand_aliases
shopt -s histappend
shopt -s checkwinsize
HISTSIZE=1000
HISTFILESIZE=2000
HISTFILE=$REMOTE_CONFIG_DIR/.bash_history

## COMPLETIONS
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
## BOILERPLATE }}}

set -o vi
export VISUAL="nvim"
export EDITOR="nvim"
alias vi=nvim
alias vim=nvim

alias l='ls'
alias la='ls -A'
alias ll='ls -l'
alias sl='ls'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias wget='wget -c'
alias mkdir='mkdir -p'
alias cp="cp -i"
alias du='du -hs'
alias df='df -h'
alias free='free -m'

# include scripts
. <(cat $REMOTE_CONFIG_DIR/include/*.sh)
# add bin to start of path
export PATH="$REMOTE_CONFIG_DIR/bin/:$PATH"

#TODO
# start an update in the background and disown. This will not notify the shell when complete.
# Even with 'set -m'. The output is logged to a file
# 1: log file
git_autoupdate() {
    { git_update > $1 2>&1 & disown ; } 2>/dev/null;
}
# git_autoupdate $REMOTE_CONFIG_DIR/.infect_update.log