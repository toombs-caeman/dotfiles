include $rc/git-subrepo/.rc


# source git completions
include $rc/include/git-completion.bash
# TODO make sure that ~/.gitconfig is linked out correctly

alias g=git
__git_complete g __git_main
alias gg='cd $(g root|| echo $HOME)'
