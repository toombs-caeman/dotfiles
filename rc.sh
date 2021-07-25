
# Author    : Caeman Toombs
# a trilingual init file for sh, bash, and zsh

## do nothing if not in an interactive shell
case $- in *i*) ;; *) return;; esac

# TODO query setup in an agnostic way
# return 0 if all specified options apply
# match options for OS, shell, terminal
config() { :; }

## ALIAS
# create aliases replacing things with nicer versions
# but fall back on the command itself if nothing else is available
# `command -v` is more consistent than `which`
# `command -v` sometimes give a full path (not zsh) but we don't really care
# TODO what happens if none are valid?
co() { command -v "$@" | tail -n1; }
export EDITOR="$(co vi vim)"
export PAGER="less"
export LESS="FXr"
export VISUAL=$EDITOR
# TODO needs a way to pass options to only a specific command in the list
coalesce() { alias "$1=$(co "$@")"; }
coalesce ls exa
coalesce vi vim
coalesce cat batcat bat
coalesce less bat
# TODO coalesce fzf to some `select` based function

## SHELL
# expected: zsh bash sh
# TODO can we use bind for keybindings? bash:bind vs zsh:bindkey
# $SHELL is super unreliable because it usually doesn't get reset by subshells
# this bit gets the actual shell that's running right now so we can rely on it.
export SHELL="$(ps -p $$ -o command | cut -d' ' -f 1 | tail -n1)"
case ${SHELL##*/} in
  zsh)
    RC="${(%):-%N}" # this file
    setopt prompt_subst zle autocd
    setopt appendhistory hist_expire_dups_first hist_ignore_dups
    # re/enable drawing the prompt every $TMOUT seconds
    TMOUT=2; TRAPALRM() { zle reset-prompt; }
    ;;
  bash)
    RC="$BASH_SOURCE"
    shopt -s expand_aliases checkwinsize autocd
    if ! shopt -oq posix; then
      if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
      elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
      fi
    fi
    _complete_invoke() {
        local candidates
        candidates=`invoke --complete -- ${COMP_WORDS[*]}`
        COMPREPLY=( $(compgen -W "${candidates}" -- $2) )
    }
    complete -F _complete_invoke -o default invoke inv
    ;;
  sh)
    # TODO how to get RC here? maybe [ ${SHELL##*/} != ${0##*/} ] && RC="$0"
    # but we should probably just bail before including if we can't really locate $RC
    ;;
  *) printf 'WARNING: unrecognized shell "%s"\n' "$SHELL" >&2 ;;
esac
# dirname equivalent (for this case)
export RC="${RC%/*}"
# enable vi-style line editing
# though it doesn't do anything in sh if it's not compiled with libedit support
set -o vi

## COMPLETION
# TODO source completions
command -v kubectl >/dev/null && . <(kubectl completion ${SHELL##*/})            2>/dev/null
command -v eksctl  >/dev/null && . <(eksctl completion ${SHELL##*/})             2>/dev/null
command -v helm    >/dev/null && . <(helm completion ${SHELL##*/})               2>/dev/null
command -v inv     >/dev/null && . <(inv --print-completion-script=${SHELL##*/}) 2>/dev/null

# This section is wrapped in a function which is called and then immediately deleted
# so that we can scope local variables (but not in a subshell)
define() {
    ## COLORS
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
                  ${f}_$b   () { _ \"\$tpush$(           tput setaf $fc; tput setab $bc)\$tpop%s\$tpush$(tput sgr0)\$tpop\n\" \"\$*\"; };
                  ${f}_${b}_() { _ \"\$tpush$(tput bold; tput setaf $fc; tput setab $bc)\$tpop%s\$tpush$(tput sgr0)\$tpop\n\" \"\$*\"; }"
        done
    done

    ## MOVEMENT
    # generate aliases like '...'='cd ../..'
    local cmd='..' val='..'
    for _ in 1 2 3 4 5; do
    #   eval "$cmd() { cd $val; }"
      alias $cmd="cd $val"
      cmd="$cmd."
      val="$val/.."
    done
    # shortcut going back to the previous directory
    # sh: cannot parse this even if it doesn't actually run. eval gets around it
    [ "${SHELL##*/}" = sh ] || eval -- '-() { cd -; }'
}; define && unset define

## OS
# expected: OSX Ubuntu
# TODO build up OS level functions
# beep notify volume
# https://support.mozilla.org/en-US/kb/control-audio-or-video-playback-your-keyboard?as=u&utm_source=inproduct
# https://superuser.com/questions/1531362/control-the-video-behavior-in-another-window-using-the-keyboard
case "$(uname -a)" in
  *Darwin*)
    beep() { osascript -e 'beep 3'; }
    notify() { osascript -e "display notification \"${1:-"Done"}\""; }
    ;;
  *nix*)
    beep() { :; }
    notify() { :; }
    ;;
esac

## TERM
# expected: iTerm xterm
# TODO term-level config
# window-dressing(title), copy-paste, scrollback, window-size
# this might mostly be on ricer
case ${TERM} in
    xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
    	# Change the window title of X terminals
#    	PS1+='\[$(echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007")\]' ;;
    ;;
    *) echo "not configured for terminal '$TERM'" ;;
esac

## PROMPT
# don't let virtualenv do weird stuff
VIRTUAL_ENV_DISABLE_PROMPT=yes
# precmd() is a special zsh value equivalent to bash's PROMPT_COMMAND
# export PROMPT_COMMAND=precmd; precmd() { :; }
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
        if [ "${SHELL##*/}" = zsh ]; then
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
        # TODO history -w
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


alias wget='wget -c'
alias mkdir='mkdir -p'
alias cp="cp -i"
alias du='du -hs'
alias df='df -h'
alias la='ls -A'
alias ll='ls -l'
alias sl='ls'

# pretty print or append to $PATH. make sure not to lose the path
path() {
    # zsh: $path is an alias for $PATH, so don't use it as a variable
    if (( $# )); then for p in "$@"; do export PATH="$PATH:$p"; done
    else printf '%s\n' "$PATH" | tr ":" "\n"; fi
}

## FUZZ FZ
# can tab-complete open fzf?
fkill () {
    # interactively kill a process
    local to_kill="$(ps aux | fzf | tr -s ' ' | cut -d' ' -f 2)"
    [[ -n "$to_kill" ]] && kill "${1:--TERM}" "$to_kill"
}

# TODO index .git/ in ~/ then do fzf project switching
    # find ~ -type d -name '.git' | { IFS= read -r d; echo "${d%.git}"; } > ~/.gitdex

# TODO test suite, also run a check to look for missing core programs
# TODO add check_install() for linking self to ~/.bashrc and ~/.zshrc via ricer and giving warnings

## SSH
# TODO ssh/kubectl migrate, copy this file as remote rc
# TODO coalesce ssh mosh

## HISTORY
# TODO history is one of the COLD contexts. fzf has --history=
# can history be by project or by everything?
HISTSIZE=100000000
HISTFILE=~/.sh_history

## INCLUDE
# source everything from $RC/include
while IFS= read -r f; do
  # TODO include is disabled
  : # . "$f"
done < <(find "$RC/include" -type f -name '*.sh')
# and add $RC/bin to $PATH
path "$RC/bin"

