# a multilingual init file for bash and zsh
#
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
# a flag 'foo' is called --foo. a flag 'f' is called -f
# Code is written in `backticks`, but $(subshells) are always preferred in real code
# foo*() means any function whose name starts with 'foo', including foo()

# DESIGN
# When necessary, make zsh behave like bash (`emulate ksh`, `setopt BASH_REMATCH`).
# if foo() needs to persist state or return multiple values, it should use $foo[].
# foo() helper functions should start with '_foo'.
# in this file, functions are defined only and then configured with rc()
# rc() handles *__*() specially. *__*() names are a list of dependencies then a name, separated by '__'
# dependency resolution is determined by q(). The type of function is determined by the following cases
# *__() are setup functions. foo__bar__() is run by rc() if `q foo bar`. __() is always run
# __*() are completion functions. __foo() prints a list of newline separated completion options for foo()
# *__*() are considered collapsing functions. rc() copies foo__bar__baz() to baz() if `q foo bar`

## do nothing if not in an interactive shell
case $- in *i*) ;; *) return;; esac

# print absolute paths as if the argument is always relative to the directory of this file
# TODO breaks if run as '. ./rc.sh'
here() { : "${BASH_SOURCE[0]:-${(%):-%x}}"; (( $# )) && echo "${_%/*}/${1#/}" || echo "$_"; }

# TODO track apt installs
#apt() { [ "$1" = install ] && printf '%s\n' "${@:2}" >> "$(here installed.apt)"; }

# TODO warn when a function is only partially defined ( like foo__bash exists but foo__zsh doesn't)
rc=("$(here)")
rc() {
  if (( $# )); then
    rc+=("$*")
    q "${@:2}" && . "$1"
  else
    # set data for q() special cases
    export OS="$(uname -a | cut -d' ' -f1;)"
    export TERM="$(printf '%s\n' "$TERM";)" # TODO consistent way to set $TERM
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
    # TODO _fzf_setup_completion https://github.com/junegunn/fzf#supported-commands autogen for __*()
    for f in $(func ls | sed -n 's/^__//p'); do
        q bash && complete -C _rc "$f"
        q zsh && eval ___$f'() { reply=(${(f)"$(__'$f')"}); }' && compctl -K "___$f" "$f"
    done
    return 0
  fi
}
_rc() { local IFS=$'\n'; compgen -W "$(__$1)" "$2"; }

rrc() {
  # send this config file over to remote connection
#  ssh -tt "$@" "bash --init-file <(base64 -d <<<$(sed 's/^ *//;s/  *#.*$//;s/^#.*$//;/^$/d' "$(here)" | base64 -w0))"
  # TODO make an initial connection to get remote config and trim files to send over
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

q() {  # query the current os, terminal, or shell, or if commands are present in $PATH
  local os term shell q=()
  while (( $# )); do case "$1" in
      # TODO add local/remote special case to handle ssh/mosh/rrc
      # TODO add xterm-256color special case
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

timer() { # echo the (average) elapsed system time in seconds (millisecond precision)
  eval "`opt repeat,r=1`"
  # call as `timer cmd` or as `timer; cmd1; cmd2; timer`
  # `time` is problematic since bash:time zsh:time and /usr/bin/time all have different behavior
  local ts=($(date +%s%N))
  if (( $# )); then
    while (( repeat-- > 0 )); do
      "$@"
      ts+=($(date +%s%N))
    done
    fmt "scale=6;o=$ts;%s;t/c\n%Ln=%s;x=(n-o)/10^9;t+=x;c+=1; o=n;" "${ts[@]:1}" | bc >&2
  else
    if [ -z "$timer" ]; then timer=$ts; else bc <<< "scale=6;($ts-$timer)/10^9"; timer=; fi
  fi
}

# zsh: $path is an alias for $PATH, so don't use it as a variable
path() { (( $# )) || tr : '\n' <<< "$PATH"; while (( $# )); do export PATH="$PATH:$(cd "$1" && pwd)"; shift; done; }

# thanks to https://unix.stackexchange.com/a/453170
zsh__log() { printf '%s %s\n' "${funcfiletrace[0]%:*}:${funcstack[1]}:${funcfiletrace[0]##*:}" "$*" >&2; }
bash__log() { printf '%s %s\n' "${BASH_SOURCE[1]}:${FUNCNAME[1]}:${BASH_LINENO[0]}" "$*" >&2; }

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
  local d=~/my/venv/
  if [ -n "$1" ]; then
    if [ ! -d "$d$1" ]; then
      printf '%s' "?? virtualenv $d$@"; read
      virtualenv $d"$@"
    fi
      . $d$1/bin/activate
  fi
}
__venv() { ls ~/my/venv/; }

minecraft-server() {
  eval "`opt port,p=25565 ip_file,ip,i=$HOME/.minecraft_server.ip -d "start a minecraft server"`"
  local old_ip="$(cat "$ip_file")"
  curl https://ipinfo.io/ip 2>/dev/null > "$ip_file"
  if [ "$(cat "$ip_file")" != "$old_ip" ]; then
    echo "The new address is $(cat "$ip_file")"; return 1
  else
    sudo docker run -p $port:25565 -v "$HOME/.minecraft/saves/$1":/data/world -e EULA=TRUE itzg/minecraft-server
  fi
}
__minecraft-server() { ls ~/.minecraft/saves/; }

zsh__() {
  autoload -Uz compinit
  compinit
  emulate ksh # bash and zsh index arrays differently if KSH_ARRAYS isn't set
  setopt promptsubst zle autocd bashrematch nolocaloptions shwordsplit
  setopt appendhistory histexpiredupsfirst histignoredups noextendedhistory
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


M() { unset -v M; [[ "$1" =~ $2 ]] && M=("${BASH_REMATCH[@]}"); } # wrapper for regex matching

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
# TODO `fmt -v VAR` pass `-v VAR` to final printf, use __local_vars to avoid collision
declare -A fmt=() # fmt is a cache of tput values so we don't constantly make subshells when formatting
fmt() {
  if (( $# )); then
    (( ${#fmt} )) || fmt
    local f="$1"; shift
    # replace %TXX directives with cached tput codes (and prompt escapes if set)
    while M "$f" '%T(..)'; do f="${f//${M[0]}/"${fmt[pp]}${fmt[${M[1]}]}${fmt[qq]}"}"; done
    # match pattern for %L and %I directives
    M "$f" "(((%%|[^%]|%[^LI])*)%L)?((%%|[^%]|%[^I])*)(%I(.*))?" || return 1
    printf -v f "${M[7]//"%"/%%}${M[4]}" "$@"
    printf "${M[2]:-"%s"}" "${f#"${M[7]}"}"
  else
    fmt[0]=1 # populate cache
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

spark() {
  # directly inspired by https://github.com/holman/spark/blob/master/spark
  # eval "$(opt wrap,scroll,overwrite? use_stdin,s sine)"
  local use_stdin n min='2^99' max='-2^99' ticks=('▁' '▂' '▃' '▄' '▅' '▆' '▇' '█')
  if [ '-' == "$1" ]; then
    use_stdin=1 min=${2:-$min} max=${3:-$max}
  fi
  {
    printf "z=$max\na=$min\n define l (n) {\n if (n<a) a=n; if (n>z) z=n; }\n" # adjust limits
    printf "define q (n) {\n x=l(n); if (a == z) return (3); return (7.999 * (n-a)/(z-a)); }\n" # quantize input
    if (( use_stdin )); then
      while read n; do printf 'q(%s)\n' "$n"; done
    else
      printf 'x=l(%f)\n' "${@//,}"
      printf 'q(%f)\n' "${@//,}"
    fi
    # check with `bc -s`
  } | bc | { while read n; do printf "%s" "${ticks[$n]}"; done; }
}
sine() { bc -l <<< "while(1){s(x++/3);}"; }
zsh__rate() { local n; while read -ku0 n; do printf '%s' "$n"; sleep "$1"; done; }
bash__rate() { local n; while read -sn 1 n; do printf '%s' "$n"; sleep "$1"; done; }
# try `sine | spark - -1 1 | rate 0.1`
scroll_line() {
  : # scroll a line instead of wrapping around when printing
}
heartbeat_line() {
   :  # overwrite the beginning of a line when wrapping
}

prompt() {
  # for section ideas see: https://liquidprompt.readthedocs.io/en/stable/functions/data.html
  # virtual env
  [ -n "$VIRTUAL_ENV" ] && fmt '%Tg-(%s)' "${VIRTUAL_ENV##*/}"
  # kubernetes context and namespace
  command -v kubectl >/dev/null && fmt '%Tu-(%s⎈%s)' $(k8s_ctx_ns)
  location 2>/dev/null
  (( EXIT )) && fmt '%Tr- %s%T--' "$EXIT"
}

k8s_ctx_ns() { kubectl config get-contexts | grep '^\*' | tr -s ' ' | cut -d' ' -f 2,5; } # context and namespace
location() { # if in a git repo print like `toplevel(*master↓2↑1):sub(9ab9999):/dir/path` else `~/working/dir`
  local C="$(git -C "$1" rev-parse --show-toplevel)" remote branch left right
  if [ -z "$C" ]; then [ -n "$1" ] || fmt '%T--%s' "${PWD//${HOME}/"~"}"; return; fi
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

# TODO use fzf_complete here instead
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
  set -o vi # enable vi-style line editing
  VIRTUAL_ENV_DISABLE_PROMPT=yes # don't let virtualenv do weird stuff to the prompt
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

rc

# ascii art credit https://ascii.co.uk/art/cerberus https://ascii.co.uk/art/sphinx

# TODO - one per line
# don't parse ls http://mywiki.wooledge.org/ParsingLs
# git: use diff3 https://blog.nilbus.com/take-the-pain-out-of-git-conflict-resolution-use-diff3/ https://blog.nilbus.com/take-the-pain-out-of-git-conflict-resolution-use-diff3/
# git: integrate forgit with existing fzf completion architecture
# term__(): [iTerm xterm] [window-dressing(title), copy-paste, scrollback, window-size]
# help() unify bash.help, man, info, -h, -help, --help, type, __help
# test suite? especially for bash vs zsh
# installer system - separate from rc() but install tools specified by rc
# degrade/fallback system - as part of rc(), fallback to available tools if preferred versions aren't available
# install/fallback grep=rg ls=exa find=fd https://github.com/sharkdp/fd cat=batcat vipe
# art
# https://マリウス.com/command-line/
