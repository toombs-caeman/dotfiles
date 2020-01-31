export HISTDIR=$rc/history
[[ ! -d $HISTDIR ]] && mkdir $HISTDIR

shopt -s histappend
# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# save a separate file for each session
silent ls $HISTDIR/${HISTFILE//*\/} || export HISTFILE="$HISTDIR/history.$(date +%Y%m%d.%H%M%S).$$"
# touch file so it exists, and context switchs won't reset the histfile
touch $HISTFILE

h() {
    # historical search with fzf
    # capture the command and print it if something was selected
    local cmd="$(cat $HISTDIR/* | sort | uniq | fzf --height=20 --layout=reverse --prompt='history> ')" && echo ${cmd:--n}
    eval "$cmd"
}
# bind h over the default reverse-search-history
bind -x '"\C-h":h'
