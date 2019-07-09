#!/bin/bash

# initialize a new remote config

export REMOTE_CONFIG_DIR=${REMOTE_CONFIG_DIR:-~/.remote_config}
if [ ! -d $REMOTE_CONFIG_DIR ]; then
    git clone https://github.com/toombs-caeman/dotfiles $REMOTE_CONFIG_DIR
    source $REMOTE_CONFIG_DIR/remote_config.sh
fi
lineinfile ~/.bashrc "export REMOTE_CONFIG_DIR=$REMOTE_CONFIG_DIR"
lineinfile ~/.bashrc ". \$REMOTE_CONFIG_DIR/remote_config.sh"