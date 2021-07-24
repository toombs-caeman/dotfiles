#!/bin/bash

# EXPORTS {{{
# exported functions start with pm_
pm_help () {
    echo '
add -- adds a new package
rm -- removes an installed package
query -- searches for available packages
list -- lists installed packages
update -- updates listed packages or all
sync -- sync all databases or listed package managers
'
}
pm_sync() {
    _all sync
}
pm_list () {
    _all list $@
}
pm_query() {
    _all query $@
}
pm_update() {
    _all update $@
}
pm_add () { 
    _select "$(_which query $1)" add $1
}
pm_rm () {
    _select "$(_which list $1)" rm $1
}
# }}}
# Util {{{
# unexported functions start with _

# return a list of supported and installed package managers
_config () {
    basename -a $(for man in "$PM_MANAGERS"; do
        which $man 2>/dev/null
    done)
}

# return a list of managers that track the specified package
# this depends on a manager returning non-zero if it can't find a package
# 1: action (query|list)
# 2: package
_which () {
    for manager in "$(_config)"; do
        if _$manager $1 $2; then
            echo $manager
        fi
    done
}
# apply an action to every available manager
# 1: action
# 2: package
_all() {
    local action=$1
    shift
    for manager in $(_config); do
        echo -e "\e[1mtrying $action for $manager\e[0m"
        _$manager $action $@
    done
}

# apply an action to a selected package manager
# 1: manager list
# 2: action
# 3: package
_select() {
    local list="$1"
    shift
    select SELECTION in $list; do
        if [[ ! -z "$SELECTION" ]]; then
            _$SELECTION $@ && break
        else
            break
        fi
    done
}
# }}}
# package managers {{{

#_template() {
#    op=$1; shift
#    case $op in
#        add);;
#        rm);;
#        query);;
#        list);;
#        update);;
#        sync) ;;
#    esac
#    return $?
#}

_yaourt () {
    op=$1; shift
    case $op in
        add) $_sudo yaourt -S $@;;
        rm) $_sudo yaourt -R $@;;
        query) yaourt -Qq $@;;
        list) yaourt -Ssq | grep -e $@;;
        update) _yaourt add $@;;
        sync) yaourt -Sy;;
    esac
    return $?
}

_pacman () {
    op=$1; shift
    case $op in
        add) $_sudo pacman -S $@;;
        rm) $_sudo pacman -R $@;;
        query) pacman -Qq $@;;
        list) pacman -Ssq | grep -e $@;;
        update) _pacman add $@;;
        sync) $_sudo pacman -Sy ;;
    esac
    return $?
}
_pip () {
    op=$1; shift
    case $op in
        add) $_sudo pip install $@;;
        rm) $_sudo pip uninstall $@;;
        query) pip search $@ | sed 's/^\([^ ]*\) .*/\1/';;
        list) pip list | grep -e $@;;
        update) pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U ;;
        sync) ;;
    esac
    return $?
}
_apt () {
    op=$1; shift
    case $op in
        add) $_sudo apt install $@;;
        rm) $_sudo apt remove $@;;
        query) apt search $@ ;;
        list) apt list $@ | grep -e $@ ;;
        update) $_sudo apt upgrade;;
        sync) $_sudo apt update  ;;
    esac
    return $?
}
_apk () {
    op=$1; shift
    case $op in
        add) $_sudo apk add $@;;
        rm) $_sudo apk del $@;;
        query) apk search $@ ;;
        list) apk list | sed 's/^\([^ ]*\) .*/\1/' | grep -e $@ ;;
        update) $_sudo apk upgrade ;;
        sync) $_sudo apk update ;;
    esac
    return $?
}
# }}}
# MAIN {{{
pm () {
    PM_MANAGERS='pip pacman yaourt apk apt'
    COMMANDNAME=$0

    # calls sudo only if needed
    _sudo="sudo"
    [[ "$(whoami)" == "root" ]] && unset _sudo

    if [[ -z "$1" ]]; then
        pm_help
    else
        op=$1
        shift
        if declare -F pm_$op >/dev/null; then
            pm_$op $@
        else
            pm_help
        fi
    fi
}
# }}}
pm $@
