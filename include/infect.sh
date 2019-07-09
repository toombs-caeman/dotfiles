#!/bin/bash

# depends on subtool
# set config dir if it isn't yet and get the config if it isn't there
function infect {
: 'install the infect config set and add an include to ~/.bashrc'

setup_remote_config () {
    export REMOTE_CONFIG_DIR=${REMOTE_CONFIG_DIR:-~/.remote_config}
    if [ ! -d $REMOTE_CONFIG_DIR ]; then
        git clone https://github.com/toombs-caeman/dotfiles $REMOTE_CONFIG_DIR
        source $REMOTE_CONFIG_DIR/remote_config.sh
    fi
    lineinfile ~/.bashrc "export REMOTE_CONFIG_DIR=$REMOTE_CONFIG_DIR"
    lineinfile ~/.bashrc "source \$REMOTE_CONFIG_DIR/remote_config.sh"
}


function infect_remote {
: 'returns a command that will introduce the infect namespace to a remote host'
    echo bash -c "\"\$SHELL -i --rcfile <(echo "$(printf '%q' "$(declare -f infect)")")\""
}

function infect_prefix {
: 'start an interactive subshell which prefixes every command with a given argument.
    $1 = command prefix
    $2 = prompt
'
    local cmd_prefix="${argv[0]}"
    local prompt="${argv[1]:-$cmd_prefix}"

    local old_complete_e="$(complete -p -E 2>/dev/null)"
    local old_complete_d="$(complete -p -D 2>/dev/null)"
    function new_complete {
        echo asdf
        $(complete -p "$cmd_prefix$1" 2>/dev/null|sed 's/complete/compgen/')
    }
    complete -D 'new_complete'
    complete -E 'new_complete'

    while read -e -p "$prompt" line; do
        $cmd_prefix$line
    done

    # clean up
    $old_complete_e
    $old_complete_d
    unset -f new_complete
    echo
    
    
}

git_autoupdate $REMOTE_CONFIG_DIR/.infect_update.log