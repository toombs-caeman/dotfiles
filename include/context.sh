# set the context
ctx() {
    if [[ $# -eq 1 ]]; then
        include $rc/contexts/$1 .sh
        ctx_name=$1
    fi

    # the variables used/set by context
    echo rc=$rc
    echo ctx_name=$ctx_name
    echo gitdir=$gitdir
    echo gitremote=$gitremote
    echo venvdir=$venvdir
}
_ctx_complete() {
    COMPREPLY=($(compgen -W "$(ls $rc/contexts)" "${COMP_WORDS[1]}"))
}
complete -F _ctx_complete ctx

notes() {
    vi $rc/notes.md
}

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
    if [[ "$1" == "deactivate" ]]; then
        deactivate
        return 0
    fi
    
    if [[ "$1" == "new" ]] && [[ ! -z "$2" ]]; then
        virtualenv $venvdir/$2
        shift
    fi
    source $venvdir/$1/bin/activate
}
_venv_complete() {
    COMPREPLY=($(compgen -W "$(ls $venvdir) new deactivate" "${COMP_WORDS[1]}"))
}
complete -F _venv_complete venv

