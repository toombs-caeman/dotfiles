#!/usr/bin/env bash
# Author    : Caeman Toombs

## do nothing if not in an interactive shell
case $- in
    *i*) ;;
      *) return;;
esac

export rc="$(realpath ${BASH_SOURCE%/*})"

#editor inversion
export EDITOR="vim -u $rc/vim/.vimrc"
export VISUAL=$EDITOR
if [[ -z "$VIMRUNTIME" ]] && vim --version 2>/dev/null | grep '+terminal' >/dev/null; then
    $EDITOR -c "call InvertShell()"
    exit
fi

## SHOPT
shopt -s expand_aliases
shopt -s checkwinsize
shopt -s autocd

# interface with vim functions
tapi() { 
    local cmd="$1"; shift
    local args=""
    local IFS='","'
    [[ "$1" ]] && args="\"${*:1}\""
    printf "\033]51;[\"call\", \"Tapi_$cmd\", [$args]]\007";
}
vi() { printf "\033]51;[\"drop\", \"$(realpath $1)\"]\007"; }
export PROMPT_COMMAND='history -w; tapi cd $PWD'


# execute silently
# really this is just easier to read
silent () { "$@" &>/dev/null; }

# gracefully degrade if the desired application isn't installed
failover() { which "$@" 2>/dev/null | head -n1; }

# don't accidentially forget the PATH
newpath() { for path in "$@"; do export PATH="$PATH:$path"; done; }

include() {
    # include files
    if [[ -f "$1" ]]; then
    	# include the file, then redeclare each function with its source file
        source $1
        local new_functions="$(cat $1 | sed -n 's/^\([[:alnum:]_-]*\) *() *{ *$/\1/p')"
        for func in $new_functions; do
            [[ ! -z "$func" ]] && source <(declare -f $func | sed "s,^{ \$,\{ : 'from file: $1';,")
        done
        return
    fi

    # include every file in a directory, but don't include recursively
    if [[ -d "$1" ]]; then
    	# by default include .sh files only
      for file in $1/*.sh; do include $file; done
    fi
}
## COMPLETIONS
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi



# set 
alias cat="$(failover bat cat)"
export PAGER="$(failover bat less)"

alias wget='wget -c'
alias mkdir='mkdir -p'
alias cp="cp -i"
alias du='du -hs'
alias df='df -h'

# movement
alias ls="$(failover exa ls)"
alias l='ls'
alias la='ls -A'
alias ll='ls -l'
alias sl='ls'
cmd='..'
val='..'
for N in {1..5}; do
  alias $cmd="cd $val"
  cmd="$cmd."
  val="$val/.."
done
unset cmd val
-() {
  cd $OLDPWD
}



# include paths and shell files
newpath $(find $rc/bin/ -maxdepth 1 -type d)
include "$rc/include"
include "$rc/git"

