include $rc/git-subrepo/.rc

# TODO convert git-extensions to git aliases

# link the gitconfig out to home
[[ -f ~/.gitconfig ]] || ln -s $rc/git/gitconfig ~/.gitconfig

export gtree_dir=~/my/
gtree_user=toombs-caeman
my() {
    # collect cloned git repositories into a single directory
    # using a 'user/repo' directory structure
    # configured with gtree_{dir,protocol,remote,user}
    # will fail to clone if gtree_user is not set and user field is not provided

    # set defaults
    local protocol remote user repo
    protocol=${gtree_protocol:-https}
    remote=${gtree_remote:-github.com}

    # figure out the structure of the input
    # $1 could be 'repo', 'user/repo','site/user/repo', or 'protocol//site/user/repo'
    # don't set user or repo, if only the repo was set, then default to * for lookup
    # 	but to $gtree_user for cloning using ${:-}
    readarray -td/ a <<<"$1"
    case ${#a[@]} in
        4) protocol=${a[0]}; 	a=("${a[@]:1}");&
        3) remote=${a[0]}; 	a=("${a[@]:1}");&
        2) user=${a[0]}; 	a=("${a[@]:1}");&
        1) repo=${a[0]}; 	a=("${a[@]:1}");;
    esac

    #echo protocol: $protocol
    #echo remote: $remote
    #echo user: $user
    #echo repo: $repo

    # if the directory exists, go there and exit
    d=$(cd $gtree_dir; for r in ${user:-*}/${repo:-*}; do echo "$r"; done | fzf -1)
    # if we selected something, try to go there
    # if both user and repo are set, but the repo hasn't been cloned yet
    # 	fzf will auto-select the one option, cd will fail, and we'll continue on below
    [[ ! -z "$d" ]] && cd $gtree_dir/$d 2>/dev/null && return


    # the directory doesn't exist, so try to clone it and then go there
    
    # construct full path
    # normalize weirdness related to ssh naming
    remote=${remote#git@} # remove possible remote user git
    repo=${repo%.git} # remove possible .git on repo name
    local full_path
    case $protocol in
        http)  ;& # disallow http by dropping through to https
        https)
            full_path=https://$remote/$user/$repo
            ;;
        ssh)
            full_path=ssh://git@$remote:$user/$repo.git
            ;;
        *)
            echo unrecognized protocol $protocol
            return 1
            ;;
    esac

    echo remote: $full_path
    # ensure user directory is there
    mkdir -p $gtree_dir/${user:-$gtree_user}
    # clone and go

    git -C $gtree_dir/${user:-$gtree_user} clone $full_path \
        && cd $gtree_dir/$user/$repo
}
_my_complete() {
    COMPREPLY=($(compgen -W "$(cd $gtree_dir;for r in */*; do echo $r;echo ${r#*/}; done)" "${COMP_WORDS[1]}"))
}
complete -F _my_complete my

alias git='git -c user.email=$gitemail'
alias g=git
__git_complete g __git_main
alias gg='cd $(g root|| echo $HOME)'
