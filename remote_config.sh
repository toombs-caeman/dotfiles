#!/bin/bash --init-file
# Author    : Caeman Toombs

## BOILERPLATE {{{
## do nothing if not in an interactive shell
case $- in
    *i*) ;;
      *) return;;
esac

## always start in tmux if it's available
if [[ -z "$TMUX"  ]] && which tmux 2> /dev/null; then
    tmux -f $REMOTE_CONFIG_DIR/tmux.conf
    exit 0
fi
    
## SHOPT
shopt -s expand_aliases
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

## INCLUDES
source $REMOTE_CONFIG_DIR/bash_include/subtool.sh
source $REMOTE_CONFIG_DIR/bash_include/pm.sh
source $REMOTE_CONFIG_DIR/bash_include/infect.sh
source $REMOTE_CONFIG_DIR/bash_include/git.sh
if [ -d $REMOTE_CONFIG_DIR/scripts ]; then
    export PATH="$PATH:$REMOTE_CONFIG_DIR/scripts"
fi
## BOILERPLATE }}}
## READLINE {{{
set -o vi
## READLINE }}}
## COLORS {{{
#TODO determine if the terminal supports true color, use that if possible
#   otherwise default to 256 and complain
alias ls='ls --color=auto'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
export YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"

color () {
#TODO collapsing function here
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

## COLORS }}}
## PROMPT {{{
xterm_prompt() {
    # Change the window title of X terminals
    echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"
    export PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$"
    export PS2="... "
}
tmux_prompt() {
#TODO use solarized colors
    local err="$(echo $? | sed 's/^0$//')"
    # set the status line of tmux
    echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"
    # let us know if we're in a git repo
    local branch="$(git branch 2>/dev/null | sed -n 's/^\* \(.*\)/(\1) /p')"
    export PS1="$(color GREEN)$branch$(color BCYAN)\w $(color RED)$err$(color)$"
}

case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND=xterm_prompt ;;
	screen*)
		PROMPT_COMMAND=tmux_prompt ;;
        *)
        export PS1="\u@\h: \w$"
        export PS2="... "
        echo "not configured for terminal '$TERM'" ;;
esac


## PROMPT }}}
## ALIASES {{{
alias l='ls'
alias la='ls -A'
alias ll='ls -l'
alias sl='ls'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias wget='wget -c'
alias mkdir='mkdir -p'
alias cp="cp -i"

alias du='du -hs'
alias df='df -h'
alias free='free -m'
alias vi='vim'

## ALIASES }}}
## FUNCTIONS {{{
# show path in a nice format
alias path='echo $PATH | tr ":" "\012"'
# trace how a process was called by pid
trace () {
    [ "${1:-$$}" = "1" ] && return
    ps -h -o comm -p ${1:-$$} 2> /dev/null
    trace $(ps -h -o ppid -p ${1:-$$} 2> /dev/null)

}
#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
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

## FUNCTIONS }}}
## INFECT {{{
export VISUAL=vim
export EDITOR=vim

export RANGER_LOAD_DEFAULT_RC=FALSE
infect options vim -u $REMOTE_CONFIG_DIR/vim/vimrc
infect options ranger -r $REMOTE_CONFIG_DIR/ranger/
infect options tmux -f $REMOTE_CONFIG_DIR/tmux.conf

infect autoupdate
## INFECT }}}
