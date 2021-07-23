
# Author    : Caeman Toombs
# a trilingual init file for sh, bash, and zsh

## do nothing if not in an interactive shell
case $- in *i*) ;; *) return;; esac

# rather than relying on $SHELL or other unreliable nonsense
# lets see which builtins exist
is_zsh()  { (builtin setopt) 2>/dev/null >&2; }
is_bash() { (builtin shopt) 2>/dev/null >&2; }
is_sh() { ! (is_zsh || is_bash); }

if is_zsh; then
    setopt PROMPT_SUBST ZLE
    # bash will hard exit when idle for $TMOUT seconds but
    # this TRAPALRM() will make zsh redraw the prompt every $TMOUT seconds
    TMOUT=2; TRAPALRM() { zle reset-prompt; }
fi
if is_bash; then
    shopt -s expand_aliases checkwinsize autocd
fi

# enable vi-style line editing, though it doesn't do anything in sh
set -o vi

define_colors() {
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
                  ${f}_$b   () { _ \"\$tpush$(           tput setaf $fc; tput setab $bc)\$tpop%s\$tpush$(tput sgr0)\$tpop\n\" \"\$*\"; };
                  ${f}_${b}_() { _ \"\$tpush$(tput bold; tput setaf $fc; tput setab $bc)\$tpop%s\$tpush$(tput sgr0)\$tpop\n\" \"\$*\"; }"
        done
    done
}; time define_colors && unset define_colors


# precmd() is a special zsh value equivalent to bash's PROMPT_COMMAND
# export PROMPT_COMMAND=precmd
# precmd() { :; }

prompt() {
    {
        # capture the exit code of the last command
        # also set tpush and tpop which are used for size escaping of non-printable characters in the prompt
        local EXIT=${?##0} tpush='\001' tpop='\002'
        # zsh uses different size escapes
        if is_zsh; then tpush='%%{' tpop='%%}'; fi

        location
        # TODO history -w
        red "${EXIT:+ $EXIT}"
    } 2>/dev/null | tr -d "\n\000"
}
# zsh uses $PROMPT as an alias for $PS1 where bash doesn't.
# setting PS1, then PROMPT allows us to set them properly for both
# this will fail however if zsh opens a bash subshell
export    PS1='$(prompt)\$ '
export PROMPT='$(prompt)%# '

location() {
    # Output a string like `toplevel(*master↓2↑1):sub(9ab9999):/dir/path` if in a git repository.
    # this means you are in directory '/dir/path' relative to a git repository in 'sub' which
    # is checked out to commit '9ab9999'. 'sub' is nested inside a git repo at 'toplevel' which
    # is checked out to master which is two commits behind origin/master and one ahead.
    # The '*' shows that 'toplevel' is dirty. It's the default color if there are only untracked files
    # but it is red if there are modifications or additions.
    # If not in a git repository just print the current working directory.
    local d="$(git rev-parse --show-toplevel 2>/dev/null)"
    # printf '\[test\]'
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
    left="$( git rev-list --left  --count $remote/$branch...$branch)"
    right="$(git rev-list --right --count $remote/$branch...$branch)"
    # start output
    printf "$tpush$(tput sgr0)$tpop%s(" "${PWD##*/}"
    if [ -n "$status_" ]; then echo "$status_" | grep -qv '^??'  && red '*' || printf '*'; fi
    green "$branch"
    (( left  )) && blue '↓%s' "$left"  # branch is behind by left
    (( right )) && blue '↑%s' "$right" # branch is ahead  by right
    git rev-parse $remote/$branch >/dev/null || blue 'L' # branch has no remote branch
    printf '):'
}


# create aliases replacing things with nicer versions
# but fall back on the command itself if nothing else is available
# `command -v` is more consistent than `which`
# `command -v` sometimes give a full path (not zsh) but we don't really care
co() { command -v "$@" | tail -n1; }
# TODO needs a way to pass options to only a specific command in the list
coalesce() { alias "$1=$(co "$@")"; }
coalesce ls exa
coalesce vi vim
export EDITOR="$(co vi vim)"
coalesce cat batcat bat
export PAGER="$(co less batcat bat)"
export VISUAL=$EDITOR
# TODO coalesce fzf to some `select` based function

# pretty print or append to $PATH. make sure not to lose the path
path() {
    if (( $# )); then for path in "$@"; do export PATH="$PATH:$path"; done
    else echo $PATH | tr ":" "\n"; fi
}

## fuzzy
fkill () {
    # interactively kill a process
    # todo awk -> cut
    local to_kill=$(ps aux|fzf |awk '{print $2}')
    [[ -z "$to_kill" ]] || kill $1 $to_kill
}

define_nav() {
    local cmd='..' val='..'
    for _ in 1 2 3 4 5; do
    #   eval "$cmd() { cd $val; }"
      alias $cmd="cd $val"
      cmd="$cmd."
      val="$val/.."
    done
    # sh: cannot parse the function even if it doesn't actually run. eval gets around it
    is_sh || eval -- '-() { cd $OLDPWD; }'
}; define_nav && unset define_nav


# TODO get path relative to this file
# bash can use BASH_SOURCE
# use that to include the include/ scripts
# find include/ -type f -name '*.sh' -exec . '{}' \;
# and to add the absolute path of bin/ to 
# path "$(cd bin/ 2>/dev/null && pwd)" >/dev/null


# TODO completions
# TODO kubernetes prompt
# TODO virtualenv prompt
# TODO index .git/ in ~/ then do fzf project switching
    # find ~ -type d -name '.git' | { IFS= read -r d; echo "${d%.git}"; } > ~/.gitdex
# TODO test suite, also run a check to look for missing core programs
 

# TODO language
# create a small language, but let every verb act on any noun
# verbs: goto, fuzzy jump, fuzzy file search, fuzzy text search, open
# nouns: directory(down), directory(up), project/git, history, file?, virtualenv, k8s resources, k8s config, libraries
# verb: CRUD, create, read, update, delete, confirm/cancel, search/select, push, pull
# confirm and search aren't really verbs, but implicit parts of all others
#   if there is nothing to confirm then it shouldn't ask
#   if there is only one thing to select it shouldn't ask

# TODO questions
# can we use bind for keybindings?
# can history be by project or by everything?
# can tab-complete open fzf?

# TODO add hook for linking self to ~/.bashrc and ~/.zshrc via ricer
