#!/bin/bash

# depends on subtool
# set config dir if it isn't yet and get the config if it isn't there
function infect {
: 'infect main help'
    export REMOTE_CONFIG_DIR=${REMOTE_CONFIG_DIR:-~/.remote_config}
    if [ ! -d $REMOTE_CONFIG_DIR ]; then
        git clone https://toombs-caeman/dotfiles $REMOTE_CONFIG_DIR
        echo "    
export  REMOTE_CONFIG_DIR=$REMOTE_CONFIG_DIR
source \$REMOTE_CONFIG_DIR/remote_config.sh
" >> ~/.bashrc
        source $REMOTE_CONFIG_DIR/remote_config.sh
    fi
}

# create a function which masks and calls an executable while injecting the passed parameters
function infect_options {
    #have to give a default value because passing no parameters is a bad time. 
    # with the default it is essentially a no-op
    local cmd=${1:-echo}
    shift
    eval "function $cmd { which $cmd >/dev/null && \$(which $cmd) $@ \$@; }"
    export -f $cmd
}

#function infect_ssh {
#    # make a random, temp install directory unless 'persistent'
#    local cmd='REMOTE_CONFIG_DIR=\$(mktemp -d) infect; bash;rm -rf \$REMOTE_CONFIG_DIR'
#    if [[ "$1" == "-p" ]];then
#        cmd='infect; bash'
#        shift
#    fi
#
#    ssh $@ "$(typeset -f infect bash);$cmd"
#}

# reload this config file
function infect_update {
    local done='Your branch is up to date'
    # if there are changes to the upstream
    # pull the new changes and load those instead
    git --git-dir $REMOTE_CONFIG_DIR/.git fetch
    if [[ "$done" == *"$(git --git-dir $REMOTE_CONFIG_DIR/.git status)"* ]]; then
        # pull and start processing the new file
        if git --git-dir $REMOTE_CONFIG_DIR/.git pull ; then
            source $REMOTE_CONFIG_DIR/remote_config.sh
        else
            echo pulling the config failed, not reconfiguring
        fi
    else
        echo $done
    fi
}
function infect_autoupdate {
# calling the function in this way allows the logs and also
# doesn't notify when it finishes, even with `set -m`
    { infect_update >$REMOTE_CONFIG_DIR/.infect_update.log 2>&1 & disown ; } 2>/dev/null;
}

subtool infect
