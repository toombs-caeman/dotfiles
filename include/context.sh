# create and restore contexts by including .sh files from a specified directory
# set the context
ctx() {
    [[ $# -eq 0 ]] && echo $ctx_name && return 0

    #clear everything set by the previous context
    unset $ctx_declares
    export PATH=${PATH/$ctx_path/}

    # record the declarations and path
    ctx_declares="$(declare -F | cut -f 3 -d ' ' -)"
    ctx_paths=$PATH


    # load the new context
    if [[ $# -eq 1 ]] && [[ -f $rc/contexts/$1 ]]; then
        include $rc/contexts/$1 .sh
        ctx_name=$1
    fi

    # see what changed
    export ctx_path=${PATH/$ctx_path/}
    _tmp="$(declare -F | cut -f 3 -d ' ' -)"
    export ctx_declares="${_tmp/ctx_declares/}"
}
_ctx_complete() {
    COMPREPLY=($(compgen -W "$(ls $rc/contexts)" "${COMP_WORDS[1]}"))
}
complete -F _ctx_complete ctx

# make cloning a breeze
my() {
    [[ ! -d $gitdir/$1 ]] && [[ ! -z "$1" ]] && git -C $gitdir clone $gitremote/$1.git
    cd ~/my/$1
}
_my_complete() {
    COMPREPLY=($(compgen -W "$(ls $gitdir)" "${COMP_WORDS[1]}"))
}
complete -F _my_complete my

# python virtualenvironment
venv() {
    if [[ "$1" == "new" ]] && [[ ! -z "$2" ]]; then
        virtualenv $venvdir/$2
        shift
    fi
    source $venvdir/$1/bin/activate
}
_venv_complete() {
    COMPREPLY=($(compgen -W "$(ls $venvdir) new" "${COMP_WORDS[1]}"))
}
complete -F _venv_complete venv

