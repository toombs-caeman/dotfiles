#!/usr/bin/env bash
# Author    : Caeman Toombs

## BOILERPLATE {{{
## do nothing if not in an interactive shell
case $- in
    *i*) ;;
      *) return;;
esac
## SHOPT
shopt -s expand_aliases
shopt -s histappend
shopt -s checkwinsize
HISTSIZE=1000
HISTFILESIZE=2000
HISTFILE=$REMOTE_CONFIG_DIR/.bash_history

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
for f in $REMOTE_CONFIG_DIR/bash_include/*.sh; do
    source $f
done
## BOILERPLATE }}}
## DETECT VIM {{{
set -o vi
export VISUAL="vi"
export EDITOR="vi"
infect options vi vim -u $REMOTE_CONFIG_DIR/vim/vimrc -i $REMOTE_CONFIG_DIR/vim/viminfo
## DETECT VIM }}}
## COLORS {{{
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

## COLORS }}}
## PROMPT {{{

#collapsing function that produces prompt_command
make_prompt() {
    local who branch term_line err_code

    case ${TERM} in
    	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
            # Change the window title of X terminals
    		term_line='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"' ;;
            *) echo "not configured for terminal '$TERM'" ;;
    esac
    # if we're not running in vim or tmux then let's say who we are
    #[[ -z "$VIM_TERMINAL$TMUX" ]] && who="$(color RED)\u@\h:"
    
    # check if git is available
    which git >/dev/null 2>&1 && branch="$(color GREEN)\$(git branch 2>/dev/null | sed -n 's/^\* \(.*\)/(\1) /p')"

    eval "prompt_command() {
        # get the err code, this must be the first thing run in the prompt to be useful
        local err=\"$(color RED)\$(echo \$? | sed 's/^0$//')\"
        $term_line
        export PS1=\"$branch$who\${debian_chroot:+$(color BLUE)[\$debian_chroot]}$(color BCYAN)\w\$err $(color)$\"
    }"
    PROMPT_COMMAND=prompt_command
}
make_prompt
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

## ALIASES }}}
## FUNCTIONS {{{
fkill () {
    local to_kill=$(ps aux|peco |awk '{print $2}')
    [[ -z "$to_kill" ]] || kill $1 $to_kill
}
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

infect options tmux tmux -2 -f $REMOTE_CONFIG_DIR/tmux.conf
#infect options bash --init-file $REMOTE_CONFIG_DIR/remote_config.sh

# make git open a prefix shell
git () {
	$(which git) $@
}
git_tree() {
    echo $@
    git $@ log --graph --all --oneline --color 
}
git_shell() {
    infect prefix "git $* " "git> "
}
subtool git

# auto update this config
infect autoupdate
## INFECT }}}
