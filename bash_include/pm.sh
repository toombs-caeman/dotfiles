#!/usr/bin/env bash
## CONFIG {{{
function pm_config {
: 'print the currently configured managers in order by priority'
    #declare -F | sed -n 's/.*pm_config_//p'
    echo 'pip pacman yaourt apk apt'
}

function pm_config_yaourt {
    op=$1; shift
    case $op in
        install) $sudo yaourt -S $@;;
        remove) $sudo yaourt -R $@;;
        list) yaourt -Ssq | grep -e $@;;
        query) yaourt -Qq $@;;
    esac
    return $?
}
function pm_config_pacman {
    op=$1; shift
    case $op in
        install) $sudo pacman -S $@;;
        remove) $sudo pacman -R $@;;
        list) pacman -Ssq | grep -e $@;;
        query) pacman -Qq $@;;
        update) $sudo pacman -Sy ;;
    esac
    return $?
}
function pm_config_pip {
    op=$1; shift
    case $op in
        install) $sudo pip install $@;;
        remove) $sudo pip uninstall $@;;
        list) pip list | grep -e $@;;
        query) pip search $@ | sed 's/^\([^ ]*\) .*/\1/';;
    esac
    return $?
}
function pm_config_apt {
    op=$1; shift
    case $op in
        install) $sudo apt install $@;;
        remove) $sudo apt remove $@;;
        list) apt list $@ | grep -e $@ ;;
        query) apt search $@ ;;
        update) apt update ;;
    esac
    return $?
}
function pm_config_apk {
    op=$1; shift
    case $op in
        install) $sudo apk add $@;;
        remove) $sudo apk del $@;;
        list) apk list | sed 's/^\([^ ]*\) .*/\1/' | grep -e $@ ;;
        query) apk search $@ ;;
        update) apk update ;;
    esac
    return $?
}
#function pm_config_template {
#    op=$1; shift
#    case $op in
#        install) ;;
#        remove) ;;
#        list) ;;
#        query) ;;
#        update) ;;
#    esac
#    return $?
#}
## CONFIG }}}

function pm {
: '
    Prime Minister is a unified package manager that lets someone who distro-hops quickly install 
    common packages on whatever system they find themselves.
'
    if [[ -z "$1" ]]; then
        pm help
        return 1
    fi
    local operation=$1; shift
    # use sudo unless root
    local sudo="sudo"
    [[ "$(whoami)" == "root" ]] && unset sudo
    # try to get permission if we need it so that we don't ask later
    $sudo echo "===== delegating =====" || return $?

    # if we're updating or listing, create a dummy target so we enter the loop
    local up=''
    [[ "update list" == *"$operation"* ]] && up=' '

    for package in "$@$up"; do
        for man in $(pm_config); do
            # if we can't find the manager then continue
            if ! which $man >/dev/null 2>&1 ; then continue; fi
            echo "===== $man ====="
            # exit the loop if we've successfully completed the operation
            pm_config_$man $operation $package && break
        done
    done
}

subtool pm
