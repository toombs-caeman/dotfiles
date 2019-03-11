#!/bin/bash --init-file
# Author    : Caeman Toombs

# BOILERPLATE {{{
## do nothing if not in an interactive shell
case $- in
    *i*) ;;
      *) return;;
esac

## SHOPT
set -o vi
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
if [ -d $REMOTE_CONFIG_DIR/scripts ]; then
    export PATH="$PATH:$REMOTE_CONFIG_DIR/scripts"
fi
# BOILERPLATE }}}

# BASH
# unlike most other injected params, the remote config here should be escaped so that the same
# function can be applied across different machines via 'infect ssh'
infect options bash --rcfile \$REMOTE_CONFIG_DIR/$(basename $BASH_SOURCE)
infect options vim -u $REMOTE_CONFIG_DIR/vim/vimrc
export VISUAL=vim
export EDITOR=vim

export RANGER_LOAD_DEFAULT_RC=FALSE
infect options ranger -u $REMOTE_CONFIG_DIR/ranger/

infect options tmux -f $REMOTE_CONFIG_DIR/tmux.conf


## PROMPT {{{
# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

export PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$"
export PS2="... "
# PROMPT }}}
## COLORS {{{
colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}
alias ls='ls --color=auto'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
export YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"
# COLORS }}}
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

# ALIASES }}}
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

# FUNCTIONS }}}

infect autoupdate
