export HISTDIR="$rc/history"
mkdir -p "$HISTDIR"
shopt -s histappend
export HISTCONTROL=ignoreboth
# save a separate file for each session
silent ls $HISTDIR/${HISTFILE//*\/} || export HISTFILE="$HISTDIR/history.$(date +%Y%m%d.%H%M%S).$$"
touch $HISTFILE

h() {
    # historical search with fzf
    # capture the command and print it if something was selected
    local cmd="$(cat $HISTDIR/* | sort | uniq | fzf --height=20 --layout=reverse --prompt='history> ')" && echo ${cmd:--n}
    eval "$cmd"
}
# bind h over the default reverse-search-history
bind -x '"\C-h":h'
