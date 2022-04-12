
# Author    : Caeman Toombs
# a trilingual init file for sh, bash, and zsh

## do nothing if not in an interactive shell
case $- in *i*) ;; *) return;; esac

perf() { # echo the elapsed time in seconds (millisecond precision)
  local ts=$(date +%s%N)
  if (( $# )); then
    "$@"
    bc <<< "scale=6;($(date +%s%N)-$ts)/10^9"
  else
    if [ -z "$perf" ]; then
      perf=$ts
    else
      bc <<< "scale=6;($ts-$perf)/10^9"
      perf=
    fi
  fi
}

declare -A log; log=([info]=0 [warning]=1 [error]=2 [lvl]=info);
# TODO BASH_SOURCE[0] === zsh ${(%):-%N}
log() { (( ${log[$1]:-0} >= ${log[${log[lvl]}]} )) && printf "%s\n" "${BASH_SOURCE[0]##*/}:${FUNCNAME[1]}: $*" >&2; }

# QUERY - figure out exactly what system we're on
os() { uname -a | cut -d' ' -f1; }
term() { printf '%s\n' "$TERM"; } # TODO
shell() { ps -p $$ -o command | cut -d' ' -f 1 | tail -n1; }
config() {
  if (( $# )); then
    # return 0 if all specified options apply
    local os term shell x
    for x in "$@"; do
      case "$x" in
        mac) os=Darwin;;    nix) os=Linux;;
        iterm) term=iterm;; xterm) term=xterm;;
        zsh) shell=zsh ;;   bash) shell=bash ;; sh) shell=sh;;
        *) return 1 ;;
      esac
    done
    [ "$OS" = "${os:-$OS}" ] || return 1
    [ "$TERM" = "${term:-$TERM}" ] || return 1
    [ "${SHELL##*/}" = "${shell:-${SHELL##*/}}" ] || return 1
  else
    export OS="$(os)"
    export TERM="$(term)"
    export SHELL="$(shell)"
  fi
}; config

path() {
    # pretty print or append to $PATH
    # zsh: $path is an alias for $PATH, so don't use it as a variable
    if (( $# )); then for p in "$@"; do export PATH="$PATH:$p"; done
    else printf '%s\n' "$PATH" | tr ":" "\n"; fi
}

suggest() {
  # $1: completion function
  # $2: function to complete
  if [ "${SHELL##*/}" = zsh ]; then
    eval "_${2}_zsh() { reply=( \$($1) ); }"
    # this uses an older zsh style completion, but it parallels the bash options
    compctl -K "_${2}_zsh" "$2"
  else
    eval "_${2}_bash() { COMPREPLY=( \$(compgen -W \"\$($1)\" \"\${COMP_WORDS[1]}\") ); }"
    builtin complete -F "_${2}_bash" "$2"
  fi
}
## HISTORY
# can history be by project or by everything?
HISTSIZE=100000000
HISTFILE=~/.sh_history
# TODO get rid of all aliases, zsh treats them weirdly
# create aliases replacing things with nicer versions
# but fall back on the command itself if nothing else is available
# `command -v` is more consistent than `which`
# `command -v` sometimes give a full path (not zsh) but we don't really care
export EDITOR="$(command -v vi vim | tail -n1)"
export PAGER="less"
export LESS="FXr"
export VISUAL=$EDITOR
alias vi="$EDITOR"
# TODO new commands with graceful fallbacks?
# alias grep=rg
# alias ls=exa
# alias find=fd # https://github.com/sharkdp/fd
# alias cat=bat
# fzf
alias wget='wget -c'
alias mkdir='mkdir -p'
alias cp="cp -i"
alias du='du -hs'
alias df='df -h'
alias la='ls -A'
alias ll='ls -l'
alias sl='ls'
alias ls='ls -F --color=auto'

## SHELL
# expected: zsh bash sh
# TODO can we use bind for keybindings? bash:bind vs zsh:bindkey
# $SHELL is super unreliable because it usually doesn't get reset by subshells
# this bit gets the actual shell that's running right now so we can rely on it.
case ${SHELL##*/} in
  zsh)
    RC="${(%):-%N}" # this file
    autoload -Uz compinit
    compinit
    # bash and zsh index arrays differently if KSH_ARRAYS isn't set
    setopt prompt_subst zle autocd BASH_REMATCH KSH_ARRAYS
    setopt appendhistory hist_expire_dups_first hist_ignore_dups
    ;;
  bash)
    RC="$BASH_SOURCE" # this file
    shopt -s expand_aliases checkwinsize autocd
    if ! shopt -oq posix; then
      if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
      elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
      fi
    fi
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
command -v kubectl >/dev/null && . <(kubectl completion ${SHELL##*/}) 
command -v eksctl  >/dev/null && . <(eksctl completion ${SHELL##*/})
command -v helm    >/dev/null && . <(helm completion ${SHELL##*/})
command -v inv     >/dev/null && . <(inv --print-completion-script=${SHELL##*/})

# list non-nested git repositories in ~
projects() { find ~/my/* -maxdepth 5 -type d -name '.git' -prune 2>/dev/null | sed 's,^\(.*\)/.git,\1,' ; }
gg() {
  # goto project (if arg given), git root or home
  local d="${1:-$(git rev-parse --show-toplevel 2>/dev/null || echo ~)}"
  [ -d "$d" ] || d="$(projects | grep "$d$" | head -n1 )"
  cd "$d"
}
_gg() { projects | grep -o '[^/]*$'; }
suggest _gg gg

# virtual environments
venv() { if [ -n "$1" ]; then . ~/my/venv/$1/bin/activate; else [ -n "$VIRTUAL_ENV" ] && deactivate; fi; }
_venv() { ls ~/my/venv/; }
suggest _venv venv


_() { ## MOVEMENT
    # generate aliases like '...'='cd ../..'
    local cmd='..' val='..'
    for _ in 1 2 3 4 5; do
      cmd="$cmd." val="$val/.."
      eval "$cmd() { cd $val; }"
    done
    # shortcut going back to the previous directory
    # sh: cannot parse this even if it doesn't actually run. eval gets around it
    config sh || eval -- '-() { cd -; }'
    unset -f _
}; _

## OS
# TODO build up OS level functions
# beep notify volume xdg_open wifimenu
# https://support.mozilla.org/en-US/kb/control-audio-or-video-playback-your-keyboard?as=u&utm_source=inproduct
# https://superuser.com/questions/1531362/control-the-video-behavior-in-another-window-using-the-keyboard
if config mac; then
    beep() { osascript -e 'beep 3'; }
    notify() { osascript -e "display notification \"${1:-"Done"}\""; }
    speak() { say "$*"; }
fi
if config nix; then
    beep() { paplay /usr/share/sounds/Yaru/stereo/bell.oga; }
    notify() { notify-send "$*"; }
    speak() {
      # https://askubuntu.com/questions/53896/natural-sounding-text-to-speech
      # packages: festival festvox-us-slt-hts
      festival -b "(voice_cmu_us_slt_arctic_hts)" "(SayText \"$*\")"
      #spd-say "$*";
    }
fi

# TODO term-level config: [iTerm xterm] [window-dressing(title), copy-paste, scrollback, window-size]
# TODO ssh/kubectl/mosh migrate, copy this file as remote rc

## INCLUDE
# source everything from $RC/include
# don't use `find -exec` because it creates a subshell
# while IFS= read -r f; do . "$f"; done < <(find "$RC/include" -type f -name '*.sh')

# and add $RC/bin to $PATH
path "$RC/bin"

## PROMPT

# don't let virtualenv do weird stuff
VIRTUAL_ENV_DISABLE_PROMPT=yes

_() { ## COLORS
    # This gets wonky if $tpush or $tpop are set elsewhere
    local exe='' colors=(black red green yellow blue magenta cyan white)
    # zsh: array definitions conflict, just copy it here
    local fc bc bold="$(tput bold)" sgr="$(tput sgr0)"
    local af=("$(tput setaf 0)" "$(tput setaf 1)" "$(tput setaf 2)" "$(tput setaf 3)" "$(tput setaf 4)" "$(tput setaf 5)" "$(tput setaf 6)" "$(tput setaf 7)")
    local ab=("$(tput setab 0)" "$(tput setab 1)" "$(tput setab 2)" "$(tput setab 3)" "$(tput setab 4)" "$(tput setab 5)" "$(tput setab 6)" "$(tput setab 7)")
    for fc in $(seq 0 7); do
        local affc="${af[$fc]}" abfc="${ab[$fc]}" f="${colors[$fc]}"
        # foreground OR background
        exe="$exe
               $f   () { printf \"\$tpush$affc\$tpop%s\$tpush$sgr\$tpop\n\" \"\$*\"; };
              _$f   () { printf \"\$tpush$abfc\$tpop%s\$tpush$sgr\$tpop\n\" \"\$*\"; };
               ${f}_() { printf \"\$tpush$bold$affc\$tpop%s\$tpush$sgr\$tpop\n\" \"\$*\"; };
              _${f}_() { printf \"\$tpush$bold$abfc\$tpop%s\$tpush$sgr\$tpop\n\" \"\$*\"; };"
        for bc in $(seq 0 7); do
            # foreground AND background
           local abbc="${ab[$bc]}" b="${colors[$bc]}"
            exe="$exe
              ${f}_$b   () { printf \"\$tpush$affc$abbc\$tpop%s\$tpush$sgr\$tpop\n\" \"\$*\"; };
              ${f}_${b}_() { printf \"\$tpush$bold$affc$abbc\$tpop%s\$tpush$sgr\$tpop\n\" \"\$*\"; };"
        done
    done
    eval "$exe"
    unset -f _
}; _

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

location() {
    # Output a string like `toplevel(*master↓2↑1):sub(9ab9999):/dir/path` if in a git repository.
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
    branch="$(git rev-parse --abbrev-ref HEAD)"
    branch="${branch:-$(git rev-parse --short HEAD)}"
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


## MISC

fkill () {
    # interactively kill a process
    local to_kill="$(ps aux | fzf | tr -s ' ' | cut -d' ' -f 2)"
    [ -n "$to_kill" ] && kill "${1:--TERM}" "$to_kill"
}
trace () { trace_pid $(ps aux | fzf | awk '{print $2}'); }
trace_pid () {
    [ "${1:-$$}" = "1" ] && return
    printf '%10s %s\n' "$(ps -h -o ppid -p ${1:-$$} 2> /dev/null)" "$(ps -h -o comm -p ${1:-$$} 2> /dev/null)"
    trace_pid $(ps -h -o ppid -p ${1:-$$} 2> /dev/null)
}

ex () {
  # archive extractor
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           printf '"%s" cannot be extracted via ex()\n' "$1" ;;
    esac
  else
    printf '"%s" is not a valid file\n' "$1"
  fi
}

fmt() {
  # printf with separate formats for for line, field and separator
  local arg args=() line='' l='%s\n' f='%s' s=' '
  while (( $# )); do
    case "$1" in
      -l) shift; l="$1" ;;
      -f) shift; f="$1" ;;
      -s) shift; s="$1" ;;
      --) shift; args+=("$@"); break ;;
      *) args+=("$1") ;;
    esac
    shift
  done
  # return 1 if there aren't any arguments instead of printing an empty line
  # this can be used to do `fmt "$@" || printf default`
  ((${#args[@]})) || return 1
  line="$(printf "$f" "${args[@]:0:1}")"
  for arg in "${args[@]:1}"; do line="$line$(printf "$s$f" "$arg")"; done
  printf "$l" "$line"
}

# convenience wrapper for regex matching match
M() { unset -v M; [[ "$1" =~ $2 ]] && M=("${BASH_REMATCH[@]}"); }
ff() {
  firefox -new-tab "duckduckgo.com/?q=$(python3 -c 'print(__import__("urllib.parse").parse.quote(input()))' <<< "$*")"
}