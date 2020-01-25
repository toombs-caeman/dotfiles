#!/usr/bin/env bash
# Author    : Caeman Toombs

## do nothing if not in an interactive shell
case $- in
    *i*) ;;
      *) return;;
esac

silent () {
    # execute silently
    # really this is just easier to read
    "$@" &>/dev/null
}

# gracefully degrade if the desired application isn't installed
failover() {
    which $@ 2>/dev/null | head -n1
}


lineinfile () {
: 'append a file with a string only if it isnt in the file yet'
    if ! grep -qxF -e "$2" $1; then
        echo "$2" >> $1
        return 1
    fi
    return 0
}

include() {
    if [[ -d "$1" ]]; then
	for file in $1/*${2:-.sh}; do
            . $file
	done
    fi
    [[ -f "$1$2" ]] && . $1$2
    return 0
}

newpath() {
    for path in "$@"; do
	export PATH="$PATH:$path"
    done
}

fkill () {
    : 'interactively kill a process'
    local to_kill=$(ps aux|fzf |awk '{print $2}')
    [[ -z "$to_kill" ]] || kill $1 $to_kill
}

path () {
: 'show path in a nice format'
    echo $PATH | tr ":" "\012"
}

# set context 
export rc=$(realpath $(dirname $BASH_SOURCE))
include $rc/contexts/default .sh

# include paths and shell files
newpath $(find $rc/bin/ -maxdepth 1 -type d)
include $rc/include .sh


