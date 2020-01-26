include $rc/git-subrepo/.rc

# TODO convert git-extensions to git aliases
ln -sf $rc/git/gitconfig ~/.gitconfig

gitdir=~/my
gitremote=https://github.com/toombs-caeman
gitemail='toombs.caeman@gmail.com'
# make cloning a breeze
my() {
    [[ ! -d $gitdir/$1 ]] && [[ ! -z "$1" ]] && git -C $gitdir clone $gitremote/$1.git
    cd $gitdir/$1
}
_my_complete() {
    COMPREPLY=($(compgen -W "$(ls $gitdir)" "${COMP_WORDS[1]}"))
}
complete -F _my_complete my

alias git='git -c user.email=$gitemail'
alias g=git
__git_complete g __git_main
alias gg='cd $(g root|| echo $HOME)'
