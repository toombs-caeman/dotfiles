HISTDIR=$rc/history
[[ ! -d $HISTDIR ]] && mkdir $HISTDIR

shopt -s histappend
# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# save a separate file for each session
export HISTFILE="$HISTDIR/history.$(date +%Y%m%d.%H%M%S).$$"


h() {
    # historical search with fzf
    # capture the command and print it if something was selected
    local cmd="$(cat $HISTDIR/* | sort | uniq | fzf)" && echo ${cmd:--n}
    eval "$cmd"
}
# bind h over the default reverse-search-history
bind -x '"\C-r":h'
