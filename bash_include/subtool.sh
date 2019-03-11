#!/bin/bash

subtool_help () {
    echo  ' Description
This is a tool to collect bash functions under a single namespace using the subcommand pattern
if you want to be able to pass no subcommands, declare the top function with a trailing separator
The separator must be a valid posix name character and defaults to _
'
}

function subtool_ {
    # the namespace to create
    [ -z "$1" ] && subtool_help && return 1
    local ns=$1
    # the separator
    local sep=${2:-_}
    local subs=''

    # get all the subcommands
    for potential in $(declare -F | sed 's/^.* //g'); do
        # if the candidate starts with $ns but is not $ns
        if [[ "$potential" == "$ns"* && "$potential" != "$ns" ]]; then
            subs="$subs $potential "
        fi
    done
    # create final function
    f="$ns () {  
            $(typeset -f $subs) 
            local f='$ns'
            while [[ \"$subs\" == *\"\${f}$sep\$1\"* ]] && [ ! -z \"\$1\" ]; do
                f=\"\${f}$sep\$1\"; shift
            done
            [ \"\$f\" == '$ns' ] && f=\${f}$sep
            if type \$f > /dev/null 2>&1; then
                \$f \$@
            else
                echo \$0: subcommand \$f not found
            fi
            unset -f $subs
    }"
    # unset all the previously defined subcommands
    unset -f $subs
    # create the final function
    eval "$f"
    # export for use in subshells
    export -f $ns
}

subtool_ subtool
