# a multilingual init file for bash and zsh

#                  /\_/\____,
#        ,___/\_/\ \  ~     /
#        \     ~  \ )   XXX
#          XXX     /    /\_/\___,
#             \o-o/-o-o/   ~    /
#              ) /     \    XXX
#             _|    / \ \_/
#          ,-/   _  \_/   \
#         / (   /____,__|  )
#        (  |_ (    )  \) _|
#       _/ _)   \   \__/   (_
#      (,-(,(,(,/      \,),),)

# COMMENTS
# Comments conform to the following style.
# a function, builtin, or command 'foo' is called foo().
# a scalar variable 'foo' is called $foo.
# an array variable 'foo' is called $foo[].
# a flag 'foo' is called --foo
# Code is written in `backticks`, but $(subshells) are always preferred in real code

# DESIGN
# a function's reason to exist is in proportion that its surface is smaller than its internal complexity
# a function's usefulness is proportional to  its internal complexity over its surface area
# a function that need state should use it's own name, since function and variables have separate namespaces
# avoid --flags whenever possible, a function should do 'one thing'
# that 'one thing' can be to get/set a value based on `(( $# ))`
# Detect the underlying system and configure to handle it consistently.
# Fall back to old standards if tools aren't installed.
# When necessary, make zsh behave like bash (`emulate ksh`, `setopt BASH_REMATCH`).

# OBSCURE PATTERNS
# `command -v` >= `which` for finding commands. some versions of which() prints function definitions but not all
# `$(cd "$1"; echo ${PWD/$HOME})` >= `realpath --relative-base=$HOME "$1"`
# `printf '%.0s' ...` prints nothing but still consumes an argument
# $_ is set to the last argument of the last completed command
# `: "${1//a}"; : "${_##* }"; echo "$_"` perform multiple parameter expansions on $@ without a temporary $var
# zsh: name of source file `${(%):-%x}`


## do nothing if not in an interactive shell
case $- in *i*) ;; *) return;; esac

# print absolute paths as if the argument is always relative to the directory of this file
# TODO breaks if run as '. ./rc.sh'
here() { : "${BASH_SOURCE[0]:-${(%):-%x}}"; (( $# )) && echo "${_%/*}/${1#/}" || echo "$_"; }

apt() { [ "$1" = install ] && printf '%s\n' "${@:2}" >> "$(here installed.apt)"; }

# CONFIG
# functions with names containing '__' are considered to be a list of dependencies, ending with a name separated by __
# dependency resolution is determined by q().
# as a special case, functions starting with __ are considered completion functions and those ending in __ are for setup
rc=("$(here)")
rc() {
  if (( $# )); then
    rc+=("$*")
    q "${@:2}" && . "$1"
  else
    # set data for q() special cases
    export OS="$(uname -a | cut -d' ' -f1;)"
    export TERM="$(printf '%s\n' "$TERM";)"
    export SHELL="$(ps -p $$ -o command | cut -d' ' -f 1 | tail -n1;)"
    local f c
    # run setup functions (ending with __)
    for c in $(func ls | sed -n 's/__$//p' | sort); do q ${c/__/ } && ${c}__; done
    command -v __ >/dev/null && __
    # collapsing functions (dependencies then name, all separated by __)
    for f in $(func ls | sed -n 's/^[^_].*__\(.\)/\1/p' | sort | uniq); do
      for c in $(func ls | sed -n "s/\(.\)__$f\$/\1/p" | sort); do q ${c/__/ } && func cp "${c}__$f" "$f" && break; done
    done
    # completions (starting with __)
    # TODO what about config sensitive completions?
    for f in $(func ls | sed -n 's/^__//p'); do
        q bash && complete -C _config "$f"
        q zsh && eval ___$f'() { reply=(${(f)"$(__'$f')"}); }' && compctl -K "___$f" "$f"
    done
    return 0
  fi
}
_config() { local IFS=$'\n'; compgen -W "$(__$1)" "$2"; }

rrc() {
  # send this config file over to remote connection
#  ssh -tt "$@" "bash --init-file <(base64 -d <<<$(sed 's/^ *//;s/  *#.*$//;s/^#.*$//;/^$/d' "$(here)" | base64 -w0))"
  # TODO make an initial connection to get remote config
  # zsh rc: https://unix.stackexchange.com/questions/131716/start-zsh-with-a-custom-zshrc#131735
  local SSH CMD='bash --init-file'
  case "$(command -v mosh ssh | head -n1)" in
    *mosh) SSH=mosh ;;
    # -tt: force a psudo-tty allocation
    *ssh) SSH='ssh -tt' ;;
  esac
  # make remote call
  # sed ...: strip comments, leading whitespace and empty lines from rc files
  # base64: encode the file to avoid weird quoting issues, then decode it on the other side
  $SSH "$@" "$CMD <(base64 -d <<<$(sed 's/^ *//;s/  *#.*$//;s/^#.*$//;/^$/d' "${rc[@]}" | base64 -w0))"
}


# q() tells us if the current system matches all the features we're expecting
# for example: `q zsh nix fzf` returns 0 if the current shell is zsh AND the operating system is linux
# AND the 'fzf' command was found
q() {
  local os term shell q=()
  while (( $# )); do case "$1" in
      # TODO add local/remote special case to handle ssh/mosh/rrc
      # TODO add 256color special case
      mac)    os=Darwin ;; nix)   os=Linux  ;;
      iterm)  term=iterm;; xterm) term=xterm;;
      zsh)    shell=zsh ;; bash)  shell=bash;;
      *) q+=("$1") ;;
    esac
    shift
  done
  [ "$OS" = "${os:-$OS}" ] && [ "$TERM" = "${term:-$TERM}" ] && [ "${SHELL##*/}" = "${shell:-${SHELL##*/}}" ] &&
  command -v "${q[@]:-command}" > /dev/null || return 1
}

func() { # working with shell functions
  case "$1" in
    ls) declare -f + || declare -F | cut -d' ' -f 3 ;;
    cp) test -n "$(declare -f "$2")" && eval "${_/$2/$3}" ;;
    rm) unset -f "$2" ;;
    mv) func mv "$2" "$3"; func rm "$2" ;;
  esac
}

# OPT
# opt() generates a script that parses arguments.
# example: `eval "$(opt x y z: job,j='a job' -d 'foo description')"`
# in this example, $x will be set to 1 if -x is passed. Same with $y. -z must be passed and takes an argument.
# $job will be set to its argument if --job or -j is passed, otherwise it will have the value 'a job'
# if -h or --help is passed, 'foo description' will be used as a description in the help text.
# if opt() is passed --nargs, positional arguments are disallowed.
# if opt() is passed --nohelp, -h|--help flags won't be generated
opt() {
  local description='generate a script that parses arguments'
  # recurse to process our own arguments
  if [ -- != "$1" ]; then eval "$(opt -- description,d="no description found" nargs nohelp)"; else shift; fi
  local vars=() cases=() required=() names=() sed=''
  # generate variable names and cases from arguments
  sed='s/^\([^,:=]*\)/\1,\1/;s/,/|--/g;s/-\(.\)\([:=|]\|$\)/\1\2/g;s/|/ /;' # 'a,bc,d=' -> 'a -a|--bc|-d='
  sed=$sed'/\(:\|=\)$/!{s/\([^ ]*\) \(.*\)/\1 \2) \1=1/;};' # 'a -b|-c' -> 'a -b|-c) a=1'
  sed=$sed'/\(:\|=\)$/{s/.$/)/;s/\([^ ]*\) \(.*\)/\1 \2 shift\;\1=\$1/;};' # 'a -b|-c:' -> 'a -b|-c) shift;a=$1'
  while M "$1" '^(.[^=:]*)(=(.*)|:)?$'; do # M (names list)(flag + value)(value)
      v="$(sed "$sed" <<< "${M[1]}${M[2]:0:1}")" vars+=("${v%% *}" "${M[3]}") cases+=("${v#* }")
      [ "${M[2]}" = : ] && required+=("${names[0]}")
      shift
  done
  (( $# )) && printf 'malformed opt definition: "%s"\n' "$1" >&2 && return 1
  local help="echo ${FUNCNAME[1]:-${funcstack[1]}}: $(printf '%q' "$description") >&2"
  (( nohelp )) || cases+=("-h|--help) $help; return")
  cases+=('--) shift;__opt_args+=("$@"); break')
  cases+=("-*) echo ${FUNCNAME[1]:-${funcstack[1]}}: unrecognized flag "\$1"; $help; return 1")
  cases+=('*) __opt_args+=("$1")')
  fmt 'local __opt_args=()\n'
  (( ${#vars[@]} )) && fmt 'local %s\n%L%s=%q%I ' "${vars[@]}"
  fmt 'while (( $# )); do case "$1" in\n%sesac; shift; done\n%L %s ;;\n' "${cases[@]}"
  fmt 'set -- "${__opt_args[@]}"\n'
  if (( ${#required[@]} )); then
    fmt 'for __opt_args in %s; do\n%L%s%I ' "${required[@]}"
    fmt ' if [ -z "${!__opt_args}" ]; then echo missing arg "$__opt_args"; %s; return 1; fi\ndone\n' "$help"
  fi
  fmt 'unset __opt_args\n'
  (( nargs )) && fmt 'if (( $# )); then echo positional arguments not allowed; %s; return 1; fi;' "$help"
}

timer() {
  # echo the elapsed system time in seconds (millisecond precision)
  # call as `timer cmd` or as `timer; cmd1; cmd2; timer`
  # `time` is problematic since bash:time zsh:time and /usr/bin/time all have different behavior
  local ts=$(date +%s%N)
  if (( $# )); then
    "$@"; local err=$?; bc <<< "scale=6;($(date +%s%N)-$ts)/10^9" >&2; return $err
  else
    if [ -z "$timer" ]; then timer=$ts; else bc <<< "scale=6;($ts-$timer)/10^9"; timer=; fi
  fi
}

# zsh: $path is an alias for $PATH, so don't use it as a variable
path() { (( $# )) || tr : '\n' <<< "$PATH"; while (( $# )); do export PATH="$PATH:$(cd "$1" && pwd)"; shift; done; }



# TODO debug|warning|error all defeat the trace setup of log()
log=warning
# thanks to https://unix.stackexchange.com/a/453170
zsh__log() { printf '%s %s\n' "${funcfiletrace[0]%:*}:${funcstack[1]}:${funcfiletrace[0]##*:}" "$*" >&2; }
bash__log() { printf '%s %s\n' "${BASH_SOURCE[1]}:${FUNCNAME[1]}:${BASH_LINENO[0]}" "$*" >&2; }
debug() { case "$log" in debug) log "$@" ;; esac; }
warning() { case "$log" in debug|warning) log warning: "$@" ;; esac; }
error() { case "$log" in debug|warning|error) log error: "$@" ;; esac; }

gg() {
  # goto project (if arg given), git root or home
  test -d "${1:-$(git rev-parse --show-toplevel 2>/dev/null || echo ~)}" || : "$(projects | grep "$_$" | head -n1 )"
  cd "$_"
}
__gg() { projects | grep -o '[^/]*$'; }
projects() { find ~/my/* -maxdepth 5 -type d -name '.git' -prune 2>/dev/null | sed 's,^\(.*\)/.git,\1,' ; }

venv() { if [ -n "$1" ]; then . ~/my/venv/$1/bin/activate; else [ -n "$VIRTUAL_ENV" ] && deactivate; fi; }
venv() {
  [ -n "$VIRTUAL_ENV" ] && deactivate;
  if [ -n "$1" ]; then
    if [ -d "~/my/venv/$1" ]; then
      . ~/my/venv/$1/bin/activate
    else
      :
    fi
  fi
}
__venv() { ls ~/my/venv/; }

minecraft() {
  eval "$(opt port,p=25565 ip_file,ip,i=$HOME/.minecraft_server.ip)"
  local old_ip="$(cat "$ip_file")"
  curl https://ipinfo.io/ip 2>/dev/null > "$ip_file"
  if [ "$(cat "$ip_file")" != "$old_ip" ]; then
    echo "The new address is $(cat "$ip_file")"; return 1
  else
    sudo docker run -p $port:25565 -v "$HOME/.minecraft/saves/$1":/data/world -e EULA=TRUE itzg/minecraft-server
  fi
}
__minecraft() { ls ~/.minecraft/saves/; }

zsh__() {
  autoload -Uz compinit
  compinit
  emulate ksh # bash and zsh index arrays differently if KSH_ARRAYS isn't set
  setopt prompt_subst zle autocd BASH_REMATCH nolocaloptions
  setopt shwordsplit
  setopt appendhistory hist_expire_dups_first hist_ignore_dups noextendedhistory
  PROMPT='$(EXIT="$?" fmt[pp]="%%{"  fmt[qq]="%%}"; prompt)%# '
}
bash__() {
  PS1='$(   EXIT="$?" fmt[pp]="\001" fmt[qq]="\002";prompt)\$ '
  shopt -s expand_aliases checkwinsize autocd
  if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
      . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
      . /etc/bash_completion
    fi
  fi
}
kubectl__() { . <(kubectl completion ${SHELL##*/}); }
eksctl__() { . <(eksctl completion ${SHELL##*/}); }
helm__() { . <(helm completion ${SHELL##*/}); }
inv__() { . <(inv --print-completion-script=${SHELL##*/}); }


# convenience wrapper for regex matching match
M() { unset -v M; [[ "$1" =~ $2 ]] && M=("${BASH_REMATCH[@]}"); }

# FMT
# fmt() is printf(), but understands additional directives.
# The %TXX directive, where XX is any two characters, will be replaced by a lookup into the tput() cache, $fmt[].
# Additionally, %T is prompt aware and will escape tput() sequences when drawing the prompt.
# The %L directive divides the pattern into two parts. The right half acts as a normal printf pattern and will be
# repeated as necessary to consume all the arguments. Once this is done, the left half will be expanded once with the
# output of the right half as its sole argument.
# The %I directive indicates a literal string on its right, to the end of the pattern. This literal is used as a
# separator whenever the pattern needs to be repeated in order to consume all the given arguments.
# Used together `fmt '^%s$%L(%s)%I, ' a b 'c d'` prints '^(a), (b), (c d)$'
declare -A fmt=() # fmt is a cache of tput values so we don't constantly make subshells when formatting
fmt() {
  if (( $# )); then
#    (( fmt )) || fmt # ensure cache is populated
    local f="$1"; shift
    # replace %T00 directives with cached tput codes (and prompt escapes if set)
    while M "$f" '%T(..)'; do f="${f//${M[0]}/"${fmt[pp]}${fmt[${M[1]}]}${fmt[qq]}"}"; done
    # match pattern for %L and %I directives
    M "$f" "((.*)%L)?(([^%]*(%[^I])?)*)(%I(.*))?" || return 1
    : "$(printf "${M[3]}${M[7]}" "$@"; printf 'x')" # sets $_. subshell truncates trailing \n
    printf "${M[2]:-"%s"}" "${_%"${M[7]}x"}"
  else
    # populate cache
#    fmt[0]=1;
    local f b cf c=(b r g y u m c w)
    for f in {0..7}; do fmt[${f}-]="$(tput setaf $f)" fmt[-$f]="$(tput setab $f)"; done
    for f in {0..7}; do
      cf=${c[$f]} fmt[${cf}-]="${fmt[${f}-]}" fmt[-$cf]="${fmt[-$f]}"
      for b in {0..7}; do fmt[$f$b]="${fmt[${f}-]}${fmt[-$b]}" fmt[$cf${c[$b]}]="${fmt[$f$b]}"; done
    done
    fmt[--]="$(tput sgr0)" fmt[__]="$(tput smul)" fmt[di]="$(tput dim)" fmt[bo]="$(tput bold)"
    # follow printf and return 1 if no pattern is given
    return 1
  fi
}

prompt() {
  # virtual env
  [ -n "$VIRTUAL_ENV" ] && fmt '%Tg-(%s)' "${VIRTUAL_ENV##*/}"
  # kubernetes context and namespace
  command -v kubectl >/dev/null && fmt '%Tu-(%s⎈%s)' $(k8s_ctx_ns)
  location 2>/dev/null
  (( EXIT )) && fmt '%Tr- %s%T--' "$EXIT"
}

# get the kubernetes context and namespace
k8s_ctx_ns() { kubectl config get-contexts | grep '^\*' | tr -s ' ' | cut -d' ' -f 2,5; }
location() {
  # print a string like `toplevel(*master↓2↑1):sub(9ab9999):/dir/path` if in a git repository or `~/working/dir` if not.
  local C="$(git -C "$1" rev-parse --show-toplevel)" remote branch left right
  if [ -z "$C" ]; then [ -n "$1" ] || printf '%s' "${PWD//${HOME}/"~"}"; return; fi
  location "$C/.."  # recurse up the file tree
  remote="$(git -C "$C" remote | head -n1)" # lets hope that they only have one remote, probably 'origin'
  branch="$(git -C "$C" rev-parse --abbrev-ref HEAD)"
  branch="${branch:-$(git -C "$C" rev-parse --short HEAD)}"
  left="$( git -C "$C" rev-list --left-only  --count remotes/$remote/$branch...$branch)"
  right="$(git -C "$C" rev-list --right-only --count remotes/$remote/$branch...$branch)"
  fmt "%T--%s(" "${C##*/}"
  test -n "$(git -C "$C" status --porcelain | grep -v '^??')"  && fmt '%Tr-*' || printf "${_:+*}"
  fmt '%Tg-%s' "$branch"
  (( left )) && fmt '%Tu-↓%s' "$left"  # branch is behind by left
  (( right )) && fmt '%Tu-↑%s' "$right" # branch is ahead  by right
  git rev-parse $remote/$branch >/dev/null || fmt '%Tu-L' # branch has no remote branch
  fmt '%T--):%s/' "${PWD//"$C"}"
}

## MISC
trace () { trace_pid $(ps aux | fzf | awk '{print $2}'); }
trace_pid () {
    [ "${1:-$$}" = "1" ] && return
    printf '%10s %s\n' "$(ps -h -o ppid -p ${1:-$$} 2> /dev/null)" "$(ps -h -o comm -p ${1:-$$} 2> /dev/null)"
    trace_pid $(ps -h -o ppid -p ${1:-$$} 2> /dev/null)
}

nix__open() { xdg-open "$1"; }
mac__open() { if [ -e "$1" ]; then command open "$@"; else command open -a "$@"; fi; }

mac__beep() { osascript -e 'beep 1'; }
nix__beep() { paplay /usr/share/sounds/Yaru/stereo/bell.oga; }

mac__notify() { osascript -e "display notification \"${1:-"Done"}\""; }
nix__notify() { notify-send "$*"; }

mac__speak() { say "$*"; }
nix__speak() {
  # https://askubuntu.com/questions/53896/natural-sounding-text-to-speech
  # packages: festival festvox-us-slt-hts
  festival -b "(voice_cmu_us_slt_arctic_hts)" "(SayText \"$*\")"
  #spd-say "$*";
}

#            _
#           /(}
#      _.___/ \ _.
#     (__)...\__m
     -() { cd -; }
    ..() { cd ..; }
   ...() { cd ../..; }
  ....() { cd ../../..; }
 .....() { cd ../../../..; }
......() { cd ../../../../..; }

__() {
  # enable vi-style line editing
  # though it doesn't do anything in sh if it's not compiled with libedit support
  set -o vi

  # don't let virtualenv do weird stuff
  VIRTUAL_ENV_DISABLE_PROMPT=yes
  export EDITOR="$(command -v vi vim | tail -n1)"
  export PAGER="less"
  export LESS="FXr"
  export VISUAL=$EDITOR
  alias vi="$EDITOR"
  alias wget='wget -c'
  alias mkdir='mkdir -p'
  alias cp="cp -i"
  alias du='du -hs'
  alias df='df -h'
  alias la='ls -A'
  alias ll='ls -l'
  alias sl='ls'
  alias ls='ls -F --color=auto'

  fmt # populate tput cache
  rc "$(here include/fzf_complete.bash)" fzf bash
  rc "$(here include/fzf_complete.zsh)" fzf zsh
  path "$(here bin)"
  # enable history
  HISTSIZE=100000000
  SAVEHIST=100000000
  HISTFILE=~/.sh_history

}
timer rc

# ascii art credit https://ascii.co.uk/art/cerberus https://ascii.co.uk/art/sphinx

# TODO - one per line
# track sourced rc (and related config)
# rename config()->rc() inject_ssh()->rrc()
# source fzf completion https://stackoverflow.com/a/70273843
# _fzf_setup_completion https://github.com/junegunn/fzf#supported-commands autogen for *__complete()
# fmt() make sure %%L doesn't match pattern %L since it should be a literal '%'
# get rid of all aliases, functions() are more consistent
# timer(): `opt repeat=1` # repeat command n times and print min max average n
# add ./bin to path
# venv() auto-create virtual environments
# don't parse ls http://mywiki.wooledge.org/ParsingLs
# git: use diff3 https://blog.nilbus.com/take-the-pain-out-of-git-conflict-resolution-use-diff3/ https://blog.nilbus.com/take-the-pain-out-of-git-conflict-resolution-use-diff3/
# git: integrate forgit with existing fzf completion architecture
# installer system - separate from config() but install tools specified by config
# degrade/fallback system - as part of config(), fallback to available tools if preferred versions aren't available
# install/fallback grep=rg ls=exa find=fd https://github.com/sharkdp/fd cat=batcat vipe
# config() warn when a function is only partially defined ( like foo__bash exists but foo__zsh doesn't)
# config() consistent way to set $TERM
# config() term: [iTerm xterm] [window-dressing(title), copy-paste, scrollback, window-size]
# help() unify bash.help, man, info, -h, -help, --help, type, __help
# rc.sh description in header
# art
# M() -v VAR: save repeated groups (...)* as $VAR[] then return $M[] as usual
# `sed -E` gives a lot nicer syntax, when isn't it available? compatible with M()
# inject_ssh() - get config of remote machine in initial connection, use that to trim files to send over
# config() detect ssh/mosh remote
# help() - try all the ways to get info about a thing()
# meta-query/introspection interface to BASH_SOURCE, FUNCNAME, LINENO, etc. perhaps join with config as general query
# https://マリウス.com/command-line/
# in launcher, figure out if an application is terminal based and optionally run in a terminal https://askubuntu.com/a/1091249
