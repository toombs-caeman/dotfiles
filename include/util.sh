#!/bin/bash

# a 'stdlib'

# if the line isn't in the file, append it and return 1
# 1: a filename
# 2: a line
lineinfile () {
: 'append a file with a string only if it isnt in the file yet'
    if ! grep -qxF -e "$2" $1; then
        echo "$2" >> $1
        return 1
    fi
    return 0
}

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
    typeset -f $1 | sed -n "/: '/,/';$/p;/';$/q" | sed "s/\\s*: '//;s/';$//"
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

export -f alias_options help delegate lineinfile
