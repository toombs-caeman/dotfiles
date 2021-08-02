
# Author    : Caeman Toombs
# a trilingual init file for sh, bash, and zsh

## do nothing if not in an interactive shell
case $- in *i*) ;; *) return;; esac

# QUERY
os() { uname -a | cut -d' ' -f1; }
term() { printf '%s\n' "$TERM"; } # TODO
shell() { ps -p $$ -o command | cut -d' ' -f 1 | tail -n1; }
config() {
  if (( $# )); then
    # return 0 if all specified options apply
    local os term shell
    for x in "$@"; do
      case "$x" in
        mac) os=Darwin;;    nix) os=Linux;;
        iterm) term=iterm;; xterm) term=xterm;;
        zsh) shell=zsh ;;   bash) shell=bash ;; sh) shell=sh;;
        *) return 1 ;;
      esac
    done
    [ "$OS" = "${os:-$OS}" ] || return 1
    [ "$TERM" = "${term:-$TERM}" ] || return 1
    [ "${SHELL##*/}" = "${shell:-${SHELL##*/}}" ] || return 1
  else
    export OS="$(os)"
    export TERM="$(term)"
    export SHELL="$(shell)"
  fi
}; config

path() {
    # pretty print or append to $PATH
    # zsh: $path is an alias for $PATH, so don't use it as a variable
    if (( $# )); then for p in "$@"; do export PATH="$PATH:$p"; done
    else printf '%s\n' "$PATH" | tr ":" "\n"; fi
}

suggest() {
  # $1: completion function
  # $2: function to complete
  if [ "${SHELL##*/}" = zsh ]; then
    eval "_${2}_zsh() { reply=( \$($1) ); }"
    # this uses an older zsh style completion, but it parallels the bash options
    compctl -K "_${2}_zsh" "$2"
  else
    eval "_${2}_bash() { COMPREPLY=( \$(compgen -W \"\$($1)\" \"\${COMP_WORDS[1]}\") ); }"
    builtin complete -F "_${2}_bash" "$2"
  fi
}

# TODO get rid of all aliases, zsh treats them weirdly
# create aliases replacing things with nicer versions
# but fall back on the command itself if nothing else is available
# `command -v` is more consistent than `which`
# `command -v` sometimes give a full path (not zsh) but we don't really care
co() { command -v "$@" | tail -n1; }
aliasif() {
  # TODO what happens if none are valid?, don't want to nest aliases
  # TODO don't count if $2 is an alias
  if command -v "$2" >/dev/null; then local a="$1"; shift; alias "$a='$*'"; fi
}
export EDITOR="$(co vi vim)"
export PAGER="less"
export LESS="FXr"
export VISUAL=$EDITOR
alias vi=vim
# TODO new commands
# alias grep=rg
# alias ls=exa
# alias find=fd # https://github.com/sharkdp/fd
# alias cat=bat
# fzf
#coalesce cat batcat bat
alias wget='wget -c'
alias mkdir='mkdir -p'
alias cp="cp -i"
alias du='du -hs'
alias df='df -h'
alias la='ls -A'
alias ll='ls -l'
alias sl='ls'

## SHELL
# expected: zsh bash sh
# TODO can we use bind for keybindings? bash:bind vs zsh:bindkey
# $SHELL is super unreliable because it usually doesn't get reset by subshells
# this bit gets the actual shell that's running right now so we can rely on it.
case ${SHELL##*/} in
  zsh)
    RC="${(%):-%N}" # this file
    autoload -Uz compinit
    compinit
    setopt prompt_subst zle autocd
    setopt appendhistory hist_expire_dups_first hist_ignore_dups
    ;;
  bash)
    RC="$BASH_SOURCE" # this file
    shopt -s expand_aliases checkwinsize autocd
    if ! shopt -oq posix; then
      if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
      elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
      fi
    fi
    ;;
  sh)
    # TODO how to get RC here? maybe [ ${SHELL##*/} != ${0##*/} ] && RC="$0"
    # but we should probably just bail before including if we can't really locate $RC
    ;;
  *) printf 'WARNING: unrecognized shell "%s"\n' "$SHELL" >&2 ;;
esac
# dirname equivalent (for this case)
export RC="${RC%/*}"
# enable vi-style line editing
# though it doesn't do anything in sh if it's not compiled with libedit support
set -o vi

## COMPLETION
# TODO source completions
command -v kubectl >/dev/null && . <(kubectl completion ${SHELL##*/})            2>/dev/null
command -v eksctl  >/dev/null && . <(eksctl completion ${SHELL##*/})             2>/dev/null
command -v helm    >/dev/null && . <(helm completion ${SHELL##*/})               2>/dev/null
command -v inv     >/dev/null && . <(inv --print-completion-script=${SHELL##*/}) 2>/dev/null


## OS
# TODO build up OS level functions
# beep notify volume xdg_open wifimenu
# https://support.mozilla.org/en-US/kb/control-audio-or-video-playback-your-keyboard?as=u&utm_source=inproduct
# https://superuser.com/questions/1531362/control-the-video-behavior-in-another-window-using-the-keyboard
if config mac; then
    beep() { osascript -e 'beep 3'; }
    notify() { osascript -e "display notification \"${1:-"Done"}\""; }
fi
if config nix; then
    beep() { :; }
    notify() { :; }
fi

# TODO term-level config: [iTerm xterm] [window-dressing(title), copy-paste, scrollback, window-size]
# TODO ssh/kubectl/mosh migrate, copy this file as remote rc

## INCLUDE
# source everything from $RC/include
# don't use `find -exec` because it creates a subshell
while IFS= read -r f; do . "$f"; done < <(find "$RC/include" -type f -name '*.sh')
# and add $RC/bin to $PATH
path "$RC/bin"


## MISC

fkill () {
    # interactively kill a process
    local to_kill="$(ps aux | fzf | tr -s ' ' | cut -d' ' -f 2)"
    [ -n "$to_kill" ] && kill "${1:--TERM}" "$to_kill"
}
trace () { trace_pid $(ps aux | fzf | awk '{print $2}'); }
trace_pid () {
    [ "${1:-$$}" = "1" ] && return
    printf '%10s %s\n' "$(ps -h -o ppid -p ${1:-$$} 2> /dev/null)" "$(ps -h -o comm -p ${1:-$$} 2> /dev/null)"
    trace_pid $(ps -h -o ppid -p ${1:-$$} 2> /dev/null)
}

ex () {
  # archive extractor
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
      *)           printf '"%s" cannot be extracted via ex()\n' "$1" ;;
    esac
  else
    printf '"%s" is not a valid file\n' "$1"
  fi
}

