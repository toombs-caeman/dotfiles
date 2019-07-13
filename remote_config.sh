#!/usr/bin/env bash
# Author    : Caeman Toombs

## do nothing if not in an interactive shell
case $- in
    *i*) ;;
      *) return;;
esac

# set root
export REMOTE_CONFIG_DIR=$(realpath $(dirname $BASH_SOURCE))

# add bin to start of path
export PATH="$(find $REMOTE_CONFIG_DIR/bin/ -maxdepth 1 -type d | tr "\n" ":")$PATH"

#TODO once pm is idempotent, assert that all dependencies are met

# include scripts
. <(cat $(find $REMOTE_CONFIG_DIR/include/ -name '*.sh' | xargs))

# hook this file into .bashrc, and initialize things if it isn't there
if ! lineinfile ~/.bashrc ". $REMOTE_CONFIG_DIR/remote_config.sh"; then
    echo 'added remote_config.sh to local .bashrc'
    
    # link out i3 config
    mkdir -p ~/.i3
    ln -sf $REMOTE_CONFIG_DIR/i3config.sh ~/.i3/config
fi
make_prompt
