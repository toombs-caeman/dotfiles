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
if you want to be able to pass no subcommands, declare the top function with a trailing separator
The separator must be a valid posix name character and defaults to _
'

    # the namespace to create
    [ -z "$1" ] && subtool_helpstr subtool && return 1
    local ns=$1
    # the separator
    local sep=${2:-_}
    local subs=''

    # get all the subcommands
    for potential in $(declare -F | sed 's/^.* //g'); do
        if [[ "$potential" == "$ns"* && "$potential" != "$ns" ]]; then
            # for each command, also add a help string hook as per subtool_helpstr
            subs="$subs $potential ${potential}${sep}help"
        fi
    done
    # add main help hook
    subs="$subs $ns${sep}help"

    # create final function
    local newtool="$ns () {  
            : '$(subtool_helpstr $ns)'
            # define sub functions
            $(typeset -f $subs) 
            # find which command to call
            local f='$ns'
            while [[ \"$subs\" == *\"\${f}$sep\$1\"* ]] && [ ! -z \"\$1\" ]; do
                f=\"\${f}$sep\$1\"; shift
            done
            if [ \"\$f\" == '$ns' ]; then
                # execute the main command
                $(typeset -f $ns | sed -n '${q};3,${p}')
            elif type \$f > /dev/null 2>&1; then
                # execute a subcommand
                \$f \$@
            else
                # get the help string for a command
                subtool helpstr \$( echo \$f | sed 's/${sep}help\$//')
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
