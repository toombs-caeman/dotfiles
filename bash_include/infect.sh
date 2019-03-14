#!/bin/bash

# depends on subtool
# set config dir if it isn't yet and get the config if it isn't there
function infect {
: 'install the infect config set and add an include to ~/.bashrc'
    export REMOTE_CONFIG_DIR=${REMOTE_CONFIG_DIR:-~/.remote_config}
    if [ ! -d $REMOTE_CONFIG_DIR ]; then
        git clone https://github.com/toombs-caeman/dotfiles $REMOTE_CONFIG_DIR
        source $REMOTE_CONFIG_DIR/remote_config.sh
    fi
    infect_lineinfile ~/.bashrc "export  REMOTE_CONFIG_DIR=$REMOTE_CONFIG_DIR"
    infect_lineinfile ~/.bashrc "source \$REMOTE_CONFIG_DIR/remote_config.sh"
}

function infect_lineinfile {
: 'append a file with a string only if it isnt in the file yet'
    f=$1
    s=$2
    if ! grep -qxF -e "$2" $1; then
        echo "$2" >> $1
    fi
}
function infect_options {
: 'create a function which masks and calls an executable while injecting the passed parameters'
    #have to give a default value because passing no parameters is a bad time. 
    # with the default it is essentially a no-op
    local cmd=${1:-echo}
    shift
    eval "function $cmd { which $cmd >/dev/null && \$(which $cmd) $@ \$@; }"
    export -f $cmd
}

# 
function infect_update {
: 'update the infect tool and related config from the repo'
    local done='Your branch is up to date'
    # if there are changes to the upstream
    # pull the new changes and load those instead
    git --git-dir $REMOTE_CONFIG_DIR/.git fetch
    if [[ "$done" == *"$(git --git-dir $REMOTE_CONFIG_DIR/.git status)"* ]]; then
        echo $done
    else
        # pull and start processing the new file
        if git --git-dir $REMOTE_CONFIG_DIR/.git pull ; then
            source $REMOTE_CONFIG_DIR/remote_config.sh
        else
            echo pulling the config failed, not reconfiguring
        fi
    fi
}
function infect_autoupdate {
: 'start an update in the background and disown. This will not notify the shell when complete.
Even with 'set -m'. The output is logged to REMOTE_CONFIG_DIR/.infect_update.log'
    { infect_update >$REMOTE_CONFIG_DIR/.infect_update.log 2>&1 & disown ; } 2>/dev/null;
}

subtool infect