## SHOPT
shopt -s expand_aliases checkwinsize autocd

## COMPLETIONS
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


#set editor
set -o vi
export EDITOR=$(failover vim vi)
export VISUAL=$EDITOR
alias vi=$EDITOR

# set bat
alias cat=$(failover bat batcat cat)
export PAGER=$(failover bat less)

alias wget='wget -c'
alias mkdir='mkdir -p'
alias cp="cp -i"
alias du='du -hs'
alias df='df -h'

# movement
alias ls="ls -F --color=auto"
alias l='ls'
alias la='ls -A'
alias ll='ls -l'
alias sl='ls'


cmd='..'
val='..'
for N in {1..5}; do
  alias $cmd="cd $val"
  cmd="$cmd."
  val="$val/.."
done
unset cmd val
-() { cd -; }
