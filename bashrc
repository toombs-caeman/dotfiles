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

## EXPORTS
[[ -d ~/scripts ]] && export PATH=$PATH:~/scripts
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

alias reboot='sudo reboot'
alias mount='sudo mount'
alias umount='sudo umount'
alias apt-get='sudo apt-get'


# music downloading with youtube-dl
m.add () { 
    echo $@ >> ~/scripts/m.util/urls 
}
alias m.update='youtube-dl -i -a ~/scripts/m.util/urls --download-archive ~/scripts/m.util/archive -x --no-playlist --restrict-filenames -o "~/Music/%(title)s.%(ext)s"'

# show path in a nice format
alias path='echo $PATH | tr ":" "\012"'
# trace how a process was called by pid
trace () {
    [ "${1:-$$}" = "1" ] && return
    ps -h -o comm -p ${1:-$$} 2> /dev/null
    trace $(ps -h -o ppid -p ${1:-$$} 2> /dev/null)

}
wttr () {
        curl wttr.in/$1
}
#TODO this needs work
live () {
        file=$1
        # whenever $1 is written to, execute the following command
        shift
        echo Command is: "$@"
        while ! inotifywait -e close_write $file; do $@; done
}
CLASSPATH=$CLASSPATH:/usr/share/java/mysql.jar
export CLASSPATH
