include $rc/git-subrepo/.rc

# TODO make sure that ~/.gitconfig is linked out correctly
# TODO convert git-extensions to git aliases

alias g=git
__git_complete g __git_main
alias gg='cd $(g root|| echo $HOME)'
