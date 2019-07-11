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

set -o vi
export VISUAL="nvim"
export EDITOR="nvim"
alias vi=nvim
alias vim=nvim

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
