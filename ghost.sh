#!/bin/bash --init-file

export REMOTE_CONFIG_DIR=$(mktemp -d)

git clone https://github.com/toombs-caeman/dotfiles $REMOTE_CONFIG_DIR

source $REMOTE_CONFIG_DIR/remote_config.sh
