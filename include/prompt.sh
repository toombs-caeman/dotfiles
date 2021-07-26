# don't let virtualenv do weird stuff
VIRTUAL_ENV_DISABLE_PROMPT=yes

## COLORS
define() {
    # generate functions like red_blue that print things in foreground_background colors
    # $tpush and $tpop are set in prompt() in order to correctly escape prompt widths.
    # This gets wonky if $tpush or $tpop are set elsewhere
    local black=0 red=1 green=2 yellow=3 blue=4 magenta=5 cyan=6 white=7
    # zsh: array definitions conflict, just copy it here
    for f in black red green yellow blue magenta cyan white; do
        # zsh: `${!f}` is incompatible so use "\$$f"
        eval "fc=\$$f;"
        # foreground OR background
        eval "
               $f   () { printf \"\$tpush$(           tput setaf $fc)\$tpop%s\$tpush$(tput sgr0)\$tpop\n\" \"\$*\"; };
              _$f   () { printf \"\$tpush$(           tput setab $fc)\$tpop%s\$tpush$(tput sgr0)\$tpop\n\" \"\$*\"; };
               ${f}_() { printf \"\$tpush$(tput bold; tput setaf $fc)\$tpop%s\$tpush$(tput sgr0)\$tpop\n\" \"\$*\"; };
              _${f}_() { printf \"\$tpush$(tput bold; tput setab $fc)\$tpop%s\$tpush$(tput sgr0)\$tpop\n\" \"\$*\"; }"
        for b in black red green yellow blue magenta cyan white; do
            # foreground AND background
            eval "bc=\$$b;"
            eval "
              ${f}_$b   () { printf \"\$tpush$(           tput setaf $fc; tput setab $bc)\$tpop%s\$tpush$(tput sgr0)\$tpop\n\" \"\$*\"; };
              ${f}_${b}_() { printf \"\$tpush$(tput bold; tput setaf $fc; tput setab $bc)\$tpop%s\$tpush$(tput sgr0)\$tpop\n\" \"\$*\"; }"
        done
    done
}; define && unset define

if config zsh; then
  # enable drawing the prompt every $TMOUT seconds
  TMOUT=2
  TRAPALRM() { (( TMOUT )) && zle && zle reset-prompt; }
fi

# zsh uses $PROMPT as an alias for $PS1 where bash doesn't.
# setting PS1, then PROMPT allows us to set them properly for both
PS1='$(prompt)\$ '
PROMPT='$(prompt)%# '
prompt() {
    {
        # capture the exit code of the last command
        # need to assign it before using local, since that resets $?
        local EXIT=${?##0} tpush tpop
        # set tpush and tpop which are used for size escaping of non-printable characters in the prompt
        tpush='\001' tpop='\002'
        if config zsh; then
            # zsh uses different size escapes
            tpush='%%{' tpop='%%}';
            # expands to bolded [time]
            print -P '%{%B%}[%{%*%}]%{%b%} '
        else
            # equivalent to time above, but it doesn't stay fresh, so dim it
            printf "$tpush$(tput dim)$tpop[$(date +%T)]$tpush$(tput sgr0)$tpop "
        fi
        # virtual env
        [ -n "$VIRTUAL_ENV" ] && green "(${VIRTUAL_ENV##*/})"
        # kubernetes context and namespace
        command -v kubectl >/dev/null && blue "($(k8s_ctx_ns | tr ' ' '⎈'))"
        location
        [ -n "$EXIT" ] && red " $EXIT"
    }  | tr -d "\n\000"
}

# get the kubernetes context and namespace
k8s_ctx_ns() { kubectl config get-contexts | grep '^\*' | tr -s ' ' | cut -d' ' -f 2,5; }

# Output a string like `gitrepo(*master↓2↑1):/dir/path` if in a git repository.
location() {
    # this means you are in directory '/dir/path' relative to a git repository in 'sub' which
    # is checked out to commit '9ab9999'. 'sub' is nested inside a git repo at 'toplevel' which
    # is checked out to master which is two commits behind origin/master and one ahead.
    # The '*' shows that 'toplevel' is dirty. It's the default color if there are only untracked files
    # but it is red if there are modifications or additions.
    # If not in a git repository just print the current working directory.
    local d="$(git rev-parse --show-toplevel 2>/dev/null)"
    if [ -n "$d" ]; then
        printf '%s%s/\n' "$(_location 2>/dev/null | tr -d '\n')" "${PWD#"$d"}"
    else
        printf '%s\n' "${PWD//${HOME}/~}"
    fi
}
_location() {
    # inner recursive part of location()
    # zsh: $status is a special var so use status_
    local x remote branch status_ left right
    # goto top level and return if we're not in a git repo
    x="$(git rev-parse --show-toplevel)" && cd "$x" || return
    # check to see if we're nested, process the outer repo first
    (cd .. && _location)
    # collect data.
    remote="$(git remote | head -n1)" # lets hope that they only have one remote, probably 'origin'
    branch="$(git branch --show-current || git rev-parse --short HEAD)"
    status_="$(git status --porcelain)"
    left="$( git rev-list --left-only  --count remotes/$remote/$branch...$branch)"
    right="$(git rev-list --right-only --count remotes/$remote/$branch...$branch)"
    # start output
    printf "$tpush$(tput sgr0)$tpop%s(" "${PWD##*/}"
    if [ -n "$status_" ]; then echo "$status_" | grep -qv '^??'  && red '*' || printf '*'; fi
    green "$branch"
    (( left  )) && blue "↓$left"  # branch is behind by left
    (( right )) && blue "↑$right" # branch is ahead  by right
    git rev-parse $remote/$branch >/dev/null || blue 'L' # branch has no remote branch
    printf '):'
}

