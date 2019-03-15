#!/bin/bash

#TODO
# add function to strip out the help string so that it isn't repeated in wrapped tools
# add flag so that a tool isn't wrapped multiple times, allow subfunctions to be modified
# add bash completions for subcommands

function subtool_helpstr {
    : 'Print this string given a function name'
    typeset -f $1 | sed -n "/: '/,/';$/p;/';$/q" | sed "s/\\s*: '//;s/';$//"
}

function subtool {
: 'Description
This is a tool to collect bash functions under a single namespace using the subcommand pattern
subcommands must be bash functions named after the top level command with an underscore
use ${argv[0]} instead of $1 if your function really cares about correct word spliting
'

    # the namespace to create
    [ -z "$1" ] && subtool_helpstr subtool && return 1
    local ns=$1
    local subs=''

    # get all the subcommands
    for potential in $(declare -F | sed 's/^.* //g'); do
        if [[ "$potential" == "$ns"* && "$potential" != "$ns" ]]; then
            # for each command, also add a help string hook as per subtool_helpstr
            subs="$subs $potential ${potential}_help"
        fi
    done
    # add main help hook
    subs="$subs ${ns}_help"

    # create final function
    local newtool="$ns () {  
            : '$(subtool_helpstr $ns)'
            # define sub functions
            $(typeset -f $subs) 
            # find which command to call
            local f='$ns'
            while [[ \"$subs\" == *\"\${f}_\$1\"* ]] && [ ! -z \"\$1\" ]; do
                f=\"\${f}_\$1\"; shift
            done
            if [ \"\$f\" == '$ns' ]; then
                # execute the main command
                $(typeset -f $ns | sed -n '${q};3,${p}')
            elif type \$f > /dev/null 2>&1; then
                # execute a subcommand with with preserved wordspliting
                local argv=( )
                while [[ ! -z "\$1" ]]; do 
                        argv+=(\"\$1\")
                        shift 
                done
                \$f \"\${argv[@]}\"
            else
                # get the help string for a command
                subtool helpstr \$( echo \$f | sed 's/_help\$//')
            fi
            # unset sub functions
            unset -f $subs
    }"
    # unset all the previously defined subcommands
    unset -f $subs
    # create the final function
    eval "$newtool"
    # export for use in subshells
    export -f $ns
}

subtool subtool
