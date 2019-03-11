function pm_help {
    echo '
Description
    This is a unified package manager that lets someone who distro-hops quickly install 
    common packages on whatever system they find themselves.
    In the config section you can change the priority for which manager is tried first.

TODO
    gracefully handle multiple packages at a time
    add more manager definitions
    separate out config?
'
}
# allows one layer of bash variable indirection
function pm_unwrap {
    eval "echo \"\$${1:-{1:-\}}\""
}

function pm_ {
    # use sudo unless root
    local sudo="sudo"
    [[ "$(whoami)" == "root" ]] && sudo=''

    ## CONFIG {{{
    # pre must be defined for each manager. use double quotes.
    # use $sudo if that manager needs sudo
    # use one space if the manager doesn't need any setup

    local pip_pre="$sudo"
    local pip_installed="install"
    local pip_removed="uninstall"

    local pacman_pre="$sudo"
    local pacman_installed='-S'
    local pacman_removed='-R'

    local yaourt_pre=" "
    local yaourt_installed='-S'
    local yaourt_removed='-R'
    # a list of software managers, listed by priority
    # a package will try to install on the first manager its available on
    local managers='pip pacman yaourt'
    ## CONFIG }}}

    local operation=$1; shift
    for man in $managers; do
        local pre="$(pm_unwrap ${man}_pre)"
        local cmd="$(which $man 2>/dev/null)"
        local op="$(pm_unwrap ${man}_$operation)"
        # ensure the current man is fully configured for the current operation
        # otherwise skip it
        if [[ -z "$pre" || -z "$cmd" || -z "$op" ]]
        then
            continue
        fi

        # show what we're about to do
        echo "pm: $pre $(basename $cmd) $op $1"
        # run the command. if it succeeds, then don't continue
        if $pre $cmd $op $1 ;then 
            return 0
        fi
    done
    echo pm: no candidate manager found
}
subtool pm
