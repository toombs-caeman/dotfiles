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
alias wget='wget -c'
alias mkdir='mkdir -p'
alias cp="cp -i"
alias du='du -hs'
alias df='df -h'
alias free='free -m'

# movement
shopt -s autocd
cmd='..'
val='..'
for N in {1..5}; do
  alias $cmd="cd $val"
  cmd="$cmd."
  val="$val/.."
done
unset cmd val
-() {
  cd -
  tput cuu1; tput el1; tput el; # erase the extra data about OLDPWD
}

cd () {
  # if called through autocd, then erase that annoying extra line
  # this isn't 100% reliable of course, but it's probably good enough
  if [[ "$1" == "--" ]]; then
    tput cuu1; tput el1; tput el; 
  fi
  builtin cd "$@"
}