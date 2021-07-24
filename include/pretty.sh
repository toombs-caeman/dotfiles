#!/bin/bash

#alias ls='ls --color=auto'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
export YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"

color () {
    # usage: color [bold | vivid] [fg COLOR] [bg COLOR]
    # colors are black red green yellow blue purple cyan white
    # TODO make this a variable escape, defaulting to 1
    # 	esc then counts the number of backslashes
    # 	this would allow its use in nested sed, printf situations

    local esc=0
    if [[ "$1" == "noesc" ]]; then
        esc=1
        shift
    fi

    if [[ "$#" -eq 0 ]]; then
        [[ $esc == 0 ]] && printf "\[\e[0m\]" || printf "\e[0m"
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
    [[ $esc == 0 ]] && printf "\[\e[%s;%s;%sm\]" $bold $[30 + $vivid + $fg] $[40 + $vivid + $bg] \
     || printf "\e[%s;%s;%sm" $bold $[30 + $vivid + $fg] $[40 + $vivid + $bg]
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

zprintf() {
    local results="$(cat -)"
    [[ ! -z "$results" ]] && printf "$1" $results
}

collapse_ps1() {
    case $# in
        0) # finalize
            export PS1="\$($PS1 printf $(color); [[ \$USER == root ]] && echo '#' || echo \$)"
            ;;
        1)
            PS1+="echo -n $1 2>/dev/null; "
            ;;
        2)
            # inline zprintf
            PS1+="r=\$(echo -n $1 2>/dev/null); [[ ! -z \"\$r\" ]] && printf \"$2\" \$r; "
            ;;
    esac
}

ctx_root() {
    sed "s,^$(git rev-parse --show-toplevel 2>/dev/null),,;s,^$HOME,${HOME/*\//}," <<< "$PWD"
}

git_short_status() {
    if status="$(git status 2>/dev/null)"; then
    	local repo="$(git rev-parse --show-toplevel 2>/dev/null)"
    	local branch="$(sed -n '
    		s/^On branch \(.*\)/\1/p;
    		s/^HEAD detached at \(.*\)/\1/p;
    		' <<<"$status")"
    	local changes="$(sed -n '/^Changes /{s/.*/✬/p;q;};' <<<"$status")"
    	local remote="$(sed -n '
    		s/^Your branch is ahead.*by \(.*\) commit.*/↑\1/p;
    		s/^Your branch is behin.*by \(.*\) commit.*/↓\1/p;
    		s/^Your branch is up to date.*/​/p;
    		' <<<"$status")"
    	# recursively handle submodules
    	(cd $repo/.. ; git_short_status ​)
    	echo  "${repo/*\//}" "${changes:-​}" "$branch" "${remote:-L} "
    fi
}

PS1=""
# print USER if it's changed since set PS1 was set (probably sudo su)
collapse_ps1 "\${USER/$USER/}" "$(color bold white red)%s "
collapse_ps1 "\${ROLE/default/}" "$(color)%s "
collapse_ps1 "; k8s_prompt" "$(color blue)%s⎈%s "
# chroot envs
collapse_ps1 "\$debian_chroot" "$(color blue)[%s] "
collapse_ps1 '; git_short_status' "$(color)%s($(color vivid red)%s$(color green)%s$(color blue)%s$(color)):"
collapse_ps1 '; ctx_root' "$(color)%s "
# errcode of the previous command, as set in PROMPT_COMMAND
collapse_ps1 "\${err/0/}" "$(color red)%d " 
collapse_ps1 # finalize

case ${TERM} in
    xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
    	# Change the window title of X terminals
    	PS1+='\[$(echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007")\]' ;;
    *) echo "not configured for terminal '$TERM'" ;;
esac
