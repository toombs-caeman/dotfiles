#!/bin/bash
# Author    : Caeman Toombs

## do nothing if not in an interactive shell
case $- in
    *i*) ;;
      *) return;;
esac
shopt -s histappend
shopt -s checkwinsize
HISTSIZE=1000
HISTFILESIZE=2000

## COMPLETIONS
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# add in sudo aliases for non-root users
case $USER in
    root)
        echo "WARNING: starting root shell"
        ;;
       *)
        export PATH=$PATH:~/scripts
        alias reboot='sudo reboot'
        alias mount='sudo mount'
        alias umount='sudo umount'
        alias apt-get='sudo apt-get'
        ;;
esac

## EXPORTS
if [[ -n $(which vim) ]]; then
    export VISUAL=vim
    export EDITOR=vim
fi

export PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$"

export PS2="... "

## ALIASES
alias ls='ls --color=auto'
alias l='ls'
alias la='ls -A'
alias ll='ls -l'
alias sl='ls'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cdb='cd -'
alias xx='exit'
alias c='clear'
alias top='top;clear'
alias cls='clear;ls'
alias wget='wget -c'
alias du='du -hs'
alias mkdir='mkdir -p'
alias grep='grep --color=auto'
alias diff='colordiff'

# git
alias g='git'
alias gs='git show' # --pretty=oneline
alias gp='git pull'
# Get to the top of a git tree
cdp () {
    TEMP_PWD=$(pwd)
    cd ..
    while $(git status > /dev/null 2> /dev/null); do
        cd ..
    done
    cd $OLDPWD
    OLDPWD=$TEMP_PWD
}

# show path in a nice format
alias path='echo $PATH | tr ":" "\012"'
# trace how a process was called by pid
trace () {
    [ "${1:-$$}" = "1" ] && return
    ps -h -o comm -p ${1:-$$} 2> /dev/null
    trace $(ps -h -o ppid -p ${1:-$$} 2> /dev/null)

}

# chronic is a really cool part of moreutils
# suppresses output unless there is an error
CHRONIC=`which chronic`
[ -n "`which chromium-browser`" ] && alias ch="$CHRONIC chromium-browser "
[ -n "`which firefox`" ] && alias ff="$CHRONIC firefox "
[ -n "`which tor-browser`" ] && alias tb="$CHRONIC tor-browser "
unset CHRONIC

vi () {
    # assume the last argument is the file name

    IMG=$(which shotwell)
    PDF=$(which evince)
    OFFICE=$(which libreoffice)
    # switch for kde
    [[ -n "$IMG" ]] && IMG=$(which okular)
    [[ -n "$PDF" ]] && PDF=$(which gwenview)

    # if there are no arguments, file is unchanged
    for file in $@; do :; done

    # if this is the first call to this function, file is unset.
    # edit the most recent file listed in .viminfo
    if [[ "$file" == "" ]]; then
            vim -c "e #<1"
    elif [[ -d "$file" ]]; then
            cd $@
            ls
    # file is an image
    elif  [[ "$IMG" != "" && (
            ($file == *.png) ||
            ($file == *.jpeg) ||
            ($file == *.jpg) ||
            ($file == *.tiff) 
            )]]; then
        $IMG $@ 2> /dev/null &
    # file is a text document
    elif [[ "$OFFICE" != "" && (
            ($file == *.docx) ||
            ($file == *.doc) ||
            ($file == *.ods) ||
            ($file == *.odt)
            )]]; then
        $OFFICE $@ 2> /dev/null &
    # file is a pdf
    elif [[ "$PDF" != "" && (
            ($file == *.pdf) 
            )]]; then
        $PDF $@ 2> /dev/null &
    else
        vim $@
    fi
    #unset IMG PDF OFFICE
    # file is unset and so can be used again
}
