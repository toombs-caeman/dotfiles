#!/usr/bin/env bash
# Author    : Caeman Toombs

## do nothing if not in an interactive shell
case $- in
    *i*) ;;
      *) return;;
esac

# set context 
export SHL_CONTEXT=${SHL_CONTEXT:-default}
SHL_CONTEXT_NEXT=
export rc=$(realpath $(dirname $BASH_SOURCE))

ctx() {
    # with no arguments or if we're already in the right context, print the context and return
    if [[ $# -eq 0 ]] || [[ "$1" == "$SHL_CONTEXT" ]]; then
        echo $SHL_CONTEXT
        return 0
    fi

    # if we're in default, start the context subshell
    # capture &5 as the context to enter next
    if [[ "$SHL_CONTEXT" == "default" ]]; then
        SHL_CONTEXT=$1 bash -i
        err=$(($? - 60))
        readarray -t a <<<$(ls $rc/contexts)
        [[ $err -ge 0 ]] && SHL_CONTEXT_NEXT=${a[$err]} || SHL_CONTEXT_NEXT=
        return 0
    fi
    # since we're not in the right context
    # use the return code to indicate which context comes next
    # the new shell isn't started here because of **scary recursion**
    # it's started by the prompt command in the default shell
    readarray -t a <<<$(ls $rc/contexts)
    for index in "${!a[@]}"; do
        [[ "${a[index]}" == "$1" ]] && silent exit $(($index + 60))
    done
    echo context $1 not found
}
_ctx_complete() {
    COMPREPLY=($(compgen -W "$(ls $rc/contexts)" "${COMP_WORDS[1]}"))
}
complete -F _ctx_complete ctx

silent () {
    # execute silently
    # really this is just easier to read
    "$@" &>/dev/null
}

failover() {
    # gracefully degrade if the desired application isn't installed
    which $@ 2>/dev/null | head -n1
}

include() {
    # include files, or entire directories
    [[ -f "$1$2" ]] && . $1$2
    if [[ -d "$1" ]]; then
    	# by deult include .sh files only
	for file in $1/*${2:-.sh}; do
            . $file
	done
    fi
}

newpath() {
    # don't accidentially forget the PATH
    for path in "$@"; do
	export PATH="$PATH:$path"
    done
}

# include paths and shell files
newpath $(find $rc/bin/ -maxdepth 1 -type d)
include $rc/include
include $rc/git

# preserve the error code
# enter the subshell if necessary and reset the flat
# then write the history
export PROMPT_COMMAND="err=\$?; [[ ! -z \"\$SHL_CONTEXT_NEXT\" ]] && ctx \$SHL_CONTEXT_NEXT; history -w"

# include the context if we're doing that
[[ "$SHL_CONTEXT" != "default" ]] && . $rc/contexts/$SHL_CONTEXT/init.sh || true
