#!/bin/bash

#TODO determine if the terminal supports true color, use that if possible
#   otherwise default to 256 and complain
alias ls='ls --color=auto'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
export YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"

color () {
    local ret
    case $1 in
        GREEN)  ret="\[\033[0;32m\]";;
        CYAN)   ret="\[\033[0;36m\]";;
        BCYAN)  ret="\[\033[1;36m\]";;
        BLUE)   ret="\[\033[0;34m\]";;
        GRAY)   ret="\[\033[0;37m\]";;
        DKGRAY) ret="\[\033[1;30m\]";;
        WHITE)  ret="\[\033[1;37m\]";;
        RED)    ret="\[\033[0;31m\]";;
        *)      ret="\[\033[0;39m\]";;
    esac
    echo $ret

}
