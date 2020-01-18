#!/bin/bash

#alias ls='ls --color=auto'
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

# sh doesn't support all of the following features well, so just go with the default and exit
if [[ "$SHELL" == *"/sh" ]]; then
    export PS1="$(color RED)\u$(color):$(color BLUE)\w $(color)$"
    return 0
fi
surround() {
    # uses the first parameter as a format
    # but evaluates everything else and only formats if there's output
    local r="$(${*:2} 2>/dev/null)"
    [[ -z "$r" ]] && return 1
    printf "$1" $r
}

ps1_next() {
    # append an item onto the prompt using args
    # ps1_next COLOR FORMAT COMMAND ...
    export PS1="$PS1$(color $1)\$(surround \"$2\" \"${@:3}\" )"
}

# start with a clean prompt
PS1=""

#TODO determine if the terminal supports true color, use that if possible
#   otherwise default to 256 and complain
case ${TERM} in
    xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
    	# Change the window title of X terminals
    	PS1=$PS1'$(echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007")' ;;
    *) echo "not configured for terminal '$TERM'" ;;
esac

ps1_next "" "%s" "echo \${ctx_name/default/}" # display the current dirs context
ps1_next BLUE "⎈%s" k8s_prompt # k8s context TODO get alans per session one
ps1_next BLUE " [%s]" "echo $debian_chroot" # chroot envs
ps1_next GREEN " ⎇ %s" "git rev-parse --abbrev-ref HEAD" # git branch
ps1_next BCYAN ":%s" "echo \${PWD#\$(dirname \$(git root || echo $HOME))/}" # git aware pwd
ps1_next RED " %d" "echo \${err/0/}" # errcode of the previous command
ps1_next RED " ROOT # " "[[ \$USER == root ]]" # if the user has changed since setting the prompt (probably sudo)
ps1_next "" " $" "echo true" # always end with $ in the default color

# preserve the error code while doing the magic
export PROMPT_COMMAND="export err=\$?; history -w"
