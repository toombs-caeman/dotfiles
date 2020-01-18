## SHOPT
shopt -s expand_aliases
shopt -s checkwinsize
shopt -s autocd

## COMPLETIONS
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

alias cygwin='[[ $(uname -a) == *"Darwin"* ]]'

set -o vi
export VISUAL=kak
export EDITOR=kak
export PAGER=less
alias vi=kak

alias wget='wget -c'
alias mkdir='mkdir -p'
alias cp="cp -i"
alias du='du -hs'
alias df='df -h'

# movement
alias ls="$(failover exa ls)"
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
-() {
  cd $OLDPWD
}
