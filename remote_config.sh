#!/usr/bin/env bash
# Author    : Caeman Toombs

## do nothing if not in an interactive shell
case $- in
    *i*) ;;
      *) return;;
esac
# resolve the absolute name of a directory
abs_dir()
{
    [[ -f "$1" ]] && name=$(dirname "$1") || name=$1
    cd "$name" 2>/dev/null || return $?  # cd to desired directory; if fail, quell any error messages but return exit status
    echo "`pwd -P`" # output full, link-resolved path
}
export -f abs_dir
# set root
export REMOTE_CONFIG_DIR=$(abs_dir $BASH_SOURCE)
# add bin to start of path
export PATH="$REMOTE_CONFIG_DIR/bin/:$PATH"
# include scripts
. <(cat $REMOTE_CONFIG_DIR/include/*.sh)
# hook this file into .bashrc
lineinfile ~/.bashrc ". $REMOTE_CONFIG_DIR/remote_config.sh"
