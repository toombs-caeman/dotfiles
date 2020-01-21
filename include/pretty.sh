#!/bin/bash

#alias ls='ls --color=auto'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
export YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"

color () {
    # usage: color [bold | vivid] [fg COLOR] [bg COLOR]
    # colors are black red green yellow blue purple cyan white
    if [[ "$#" -eq 0 ]]; then
        printf "\e[0m"
        return 0
    fi
    local bold vivid fg bg
    bold=0
    vivid=0
    case $1 in
        bold) bold=1; shift ;;
        vivid) vivid=60; shift ;;
    esac

    color_code() {
        local c=8
        case $1 in
            black) c=0; shift ;;
            red) c=1; shift ;;
            green) c=2; shift ;;
            yellow) c=3; shift ;;
            blue) c=4; shift ;;
            purple) c=5; shift ;;
            cyan) c=6; shift ;;
            white) c=7; shift ;;
        esac
        echo $c
    }
    fg=$(color_code $1)
    bg=$(color_code $2)
    printf "\e[%s;%s;%sm" $bold $[30 + $vivid + $fg] $[40 + $vivid + $bg]
}

# sh doesn't support all of the following features well, so just go with the default and exit
if [[ "$SHELL" == *"/sh" ]]; then
    export PS1="$(color red)\u$(color):$(color blue)\w $(color)$"
    return 0
fi

ps1_next() {
    # append an command onto the prompt
    # ps1_next COLOR FORMAT COMMAND...
    export PS1+="$(color $1)\$(r=\"\$(${@:3} 2>/dev/null)\"; [[ -z \"\$r\" ]] || printf \"$2\" \$r)"
}

# start with a clean prompt
PS1=""

#   otherwise default to 256 and complain
case ${TERM} in
    xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
    	# Change the window title of X terminals
    	PS1+='$(echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007")' ;;
    *) echo "not configured for terminal '$TERM'" ;;
esac

ps1_next 'bold white red' "%s" "[[ \"\$USER\" != \"$USER\" ]] && echo \$USER" # if the user has changed since setting the prompt (probably sudo su)
ps1_next "" "%s " "echo \${ctx_name/default/}" # display the current dirs context
ps1_next blue "%s⎈%s" k8s_prompt # k8s context TODO get alans per session one
ps1_next blue " [%s]" "echo $debian_chroot" # chroot envs
ps1_next green " ⎇ %s" "git rev-parse --abbrev-ref HEAD" # git branch
ps1_next 'vivid red' "*" "git status --short" # is repo clean
ps1_next 'bold cyan' " %s " "echo \${PWD#\$(dirname \$(git root || echo $HOME))/}" # git aware pwd
ps1_next red "%d " "echo \${err/0/}" # errcode of the previous command
ps1_next "" "%s" "[[ \"\$USER\" == \"root\" ]] && echo '#' || echo '$'" # always end with $ in the default color

# preserve the error code while doing the magic and write the history
export PROMPT_COMMAND="export err=\$?; history -w"
