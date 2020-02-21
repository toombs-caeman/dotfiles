#!/usr/bin/env bash
# Author    : Caeman Toombs

## do nothing if not in an interactive shell
case $- in
    *i*) ;;
      *) return;;
esac

# set context 
export ROLE=${ROLE:-default}
ROLE_NEXT=
export rc=$(realpath $(dirname $BASH_SOURCE))
__context() {
    shopt -p
    declare -f
    complete
    alias
    set -o | sed '/on$/{s/^/set -o /;};/off$/{s/^/set +o /;};s/[ofn]*$//'
    bind -X | sed "s/^\"\(.*\)\": \"\(.*\)\"/bind -x '\"\1\":\2'/"
}


role() {
    # start a subshell with an additional rc that *almost* duplicates the default context completely
    # the only things not passed are unexported variables
    # this isolates changes made in context from the default shell, yet alllows the common configuration
    # to apply generally

    # with no arguments or if we're already in the right context, print the context and return
    if [[ $# -eq 0 ]] || [[ "$1" == "$ROLE" ]]; then
        echo $ROLE
        return 0
    fi

    # if we're in default, start the context subshell.
    # capture the exit code to indicate if we should enter another context
    if [[ "$ROLE" == "default" ]]; then
        # duplicate shell options, functions, completions, and aliases explicitly
        # then include the context specific init.sh
        # the enironment is already passed by default and .bashrc is not run
        ROLE=$1 bash --init-file <(__context; cat $rc/contexts/$1/init.sh 2>/dev/null) -i


        # capture the exit code from bash.
        # We'll arbitrarily use 60 as an exit code denoting that we should go to context[0] next
        # One quirk of this method is that you can't enter arbitrary contexts from anywhere except default.
        # 	if you want to start a context with no extra configuration (and no init.sh)
        # 	you have to do that from default
    	# the new shell isn't started here because of **scary recursion**.
    	# 	just set a flag so it's started by the prompt command in the default shell
        err=$(($? - 60))
        readarray -t a <<<$(ls $rc/contexts)
        # negative values will index from the back, but indexing off the end will expand to a null string
        # this is actually desired, since it probably means the exit code wasn't set by role()
        [[ $err -ge 0 ]] && ROLE_NEXT=${a[$err]} || ROLE_NEXT=
        return 0
    fi
    # since we're not in the right context
    # use the return code to indicate which context comes next
    readarray -t a <<<$(ls $rc/contexts)
    for index in "${!a[@]}"; do
        [[ "${a[index]}" == "$1" ]] && silent exit $(($index + 60))
    done
    echo context $1 not found
    return 1
}
_role_complete() {
    COMPREPLY=($(compgen -W "$(ls $rc/contexts)" "${COMP_WORDS[1]}"))
}
complete -F _role_complete role

silent () {
    # execute silently
    # really this is just easier to read
    "$@" &>/dev/null
}


failover() {
    # gracefully degrade if the desired application isn't installed
    which $@ 2>/dev/null | head -n1
}


slink() {
    # read a list of [TARGET] [FILE] pairs
    # create symlinks to those places store the existing file if it exists
    # option to restore those files and remove the symlinks
    :
}

include() {
    # include files
    if [[ -f "$1$2" ]]; then
    	# include the file, then redeclare each function with its source file
        source $1$2
        local new_functions="$(cat $1$2 | sed -n 's/^\([[:alnum:]_-]*\) *() *{ *$/\1/p')"
        for func in $new_functions; do
            [[ ! -z "$func" ]] && source <(declare -f $func | sed "s,^{ \$,\{ : 'from file: $1$2';,")
        done
        return
    fi

    # include every file in a directory, but don't include recursively
    if [[ -d "$1" ]]; then
    	# by default include .sh files only
	for file in $1/*${2:-.sh}; do
    	   # recurse
    	   include $file
	done
    fi
}

newpath() {
    # don't accidentially forget the PATH
    for path in "$@"; do
	export PATH="$PATH:$path"
    done
}

fzf_test() {
    # decorate and undecorate
    # the decorator must return exactly one line per item
    # example: f() { ls -ld $(cat -); }
    # this decorator allows you to select on the long form output of ls
    # but this function still only outputs the short name
    local tempfile=$(mktemp)
    local i=$(cat - | tee $tempfile | ${1:-cat} | nl -s ': ' | fzf --with-nth=2..)
    sed -n "${i/:*/}p" $tempfile
    rm $tempfile

}


# include paths and shell files
newpath $(find $rc/bin/ -maxdepth 1 -type d)
include $rc/include
include $rc/git

# preserve the error code
# enter the subshell if necessary and reset the flat
# then write the history
export PROMPT_COMMAND="err=\$?; [[ ! -z \"\$ROLE_NEXT\" ]] && role \$ROLE_NEXT; history -w"

# include the context rc if we're not in default
# this is not generally run since this file isn't sourced when starting the context
# but if we source it manually, also run the context init
[[ "$ROLE" != "default" ]] && . $rc/contexts/$ROLE/init.sh || true
