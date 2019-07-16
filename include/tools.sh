#!/bin/bash

fkill () {
: 'interactively kill a process'
    local to_kill=$(ps aux|fzf |awk '{print $2}')
    [[ -z "$to_kill" ]] || kill $1 $to_kill
}

path () {
: 'show path in a nice format'
    echo $PATH | tr ":" "\012"
}


trace () {
: 'use fzf to find '
  trace_pid $(ps aux | fzf | awk '{print $2}')
}
trace_pid () {
: 'trace how a process was called by pid'
    [ "${1:-$$}" = "1" ] && return
    printf '%10s %s\n' "$(ps -h -o ppid -p ${1:-$$} 2> /dev/null)" "$(ps -h -o comm -p ${1:-$$} 2> /dev/null)"
    trace_pid $(ps -h -o ppid -p ${1:-$$} 2> /dev/null)
}

ex () {
: 'archive extractor'
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

export -f fkill trace ex path
