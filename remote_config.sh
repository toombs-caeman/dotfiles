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
export PATH="$(find $REMOTE_CONFIG_DIR/bin/ -maxdepth 1 -type d | tr "\n" ":")$PATH"
# include scripts
. <(cat $(find $REMOTE_CONFIG_DIR/include/ -name '*.sh' | xargs))
# hook this file into .bashrc
if ! lineinfile ~/.bashrc ". $REMOTE_CONFIG_DIR/remote_config.sh"; then
    echo 'added remote_config.sh to local .bashrc'
fi
make_prompt
