#!/bin/bash

# a 'stdlib'

# the following section contains the building blocks for all of the following scripts
# mostly these are utility functions and nice wrappers which need to exist before
# including anything else
missingno() {
    # list commands that are missing from a list that are expected for full functionality
    # don't try to install them here, but maybe integrate with pm
    echo TODO
}

path () {
    #show path in a nice format
    echo $PATH | tr ":" "\012"
}

fkill () {
    # interactively kill a process
    local to_kill=$(ps aux|fzf |awk '{print $2}')
    [[ -z "$to_kill" ]] || kill $1 $to_kill
}

# resolve the absolute name of a directory
abs_dir()
{
    [[ -f "$1" ]] && name=$(dirname "$1") || name=$1
    cd "$name" 2>/dev/null || return $?  # cd to desired directory; if fail, quell any error messages but return exit status
    echo "`pwd -P`" # output full, link-resolved path
}
# if the line isn't in the file, append it and return 1
# 1: a filename
# 2: a line

# call subcommands in the path based on the name of the calling file
delegate() {
    bn=$(basename $0)
    sn=$1
    if which $bn-$sn 2>&1 >/dev/null; then
        shift
        exec $bn-$sn $*
    else
        # if no subcommand is found, just print the help
        f=$BASH_SOURCE/HELP.txt
        [[ -f "$f" ]] && cat $f
        return 1
    fi
}

which_fallthrough() {
: 'return the first command which is available on the path
returns non-zero code if none are found'
    r=$(which $@ 2>/dev/null | head -n1)
    [ ! -z "$r" ] && echo $r
}

help() {
    : 'Print this string given a function name'
    case $(type -t $1) in
        function)
            typeset -f $1 | sed -n "/: '/,/';$/p;/';$/q" | sed "s/\\s*: '//;s/';$//" ;;
        file)
            man $1 ;;
        alias)
            alias $1 ;;
    esac
}
alias_options () {
: 'create a function which masks and calls an executable while injecting the passed parameters'
    local name=$1
    local cmd=$2
    shift 2
    if [[ -z "$cmd" ]] || ! which $cmd >/dev/null 2>&1;then
        return 1
    fi
    # mangle the name because the bash name resolution order is 
    # alias -> command -> function
    # this ensures our function will always be prefered even if $name is the name of a command on $PATH
    eval "function _$name { \$(which $cmd) $@ \$@; }"
    export -f _$name
    alias $name=_$name
}

silent () {
    "$@" 2>/dev/null >/dev/null
}

inline() {
    declare -f $1 | sed '1,2d;$d'
}

