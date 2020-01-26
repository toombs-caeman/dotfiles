
notes() {
    vi $rc/notes.md
}

export venvdir=~/my/venv
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

