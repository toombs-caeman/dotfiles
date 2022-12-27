# a multilingual init file for bash and zsh
#
#                  /\_/\____,
#        ,___/\_/\ \  ~     /
#        \     ~  \ )   XXX
#          XXX     /    /\_/\___,
#             \o-o/    /   ~    /
#              \ /o-o-o\    XXX
#             _|    / \ \_/
#          ,-/   _  \_/   \
#         / (   /_______|  )
#        (  |_ (    )  \) _|
#       _/ _)   \   \__/   (_
#      (,-(,(,(,/      \,),),)


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


. "$(lib)" # import lib
# print absolute paths as if the argument is always relative to the directory of this file
# TODO breaks if run as '. ./rc.sh'
here() { : "${BASH_SOURCE[0]:-${(%):-%x}}"; (( $# )) && echo "${_%/*}/${1#/}" || echo "$_"; }

# TODO warn when a function is only partially defined ( like foo__bash exists but foo__zsh doesn't)
rc=("$(here)")
rc() {
    if (( $# )); then
        rc+=("$*")
        q "${@:2}" && . "$1"
    else
        # set data for q() special cases
        export OS="$(uname -s)"
        export TERM="$TERM" # TODO consistent way to set $TERM
        export SHELL="$(ps -p $$ -o comm=)"
        local f c fsetup=() fcollapse=() fnames=() fcomplete=()
        for f in $(fls); do
            case "$f" in
                *__) fsetup+=("$f") ;;
                __*) fcomplete+=("$f") ;;
                *__*) fcollapse+=("$f"); fnames+=("${f##*__}") ;;
            esac
        done
        fnames=($(printf "%s\n" "${fnames[@]}" | sort -u))
        # run setup functions (ending with __)
        for f in "${fsetup[@]}"; do q ${f/__/ } && "$f"; done
        command -v __ >/dev/null && __
        # collapsing functions (dependencies then name, all separated by __)
        for f in "${fnames[@]}"; do
            for c in $(fmt "$f$%w%s\n" "${fcollapse[@]}"); do : "${c%__*}"; q ${_/__/ } && fcp "$c" "$f" && break; done
        done
        # completions (starting with __)
        # TODO what about config sensitive completions?
        # TODO _fzf_setup_completion https://github.com/junegunn/fzf#supported-commands autogen for __*()
        for f in "${fcomplete[@]}"; do
            q bash && complete -C _rc "${f##*__}"
            q zsh && eval _$f'() { reply=(${(f)"$('$f')"}); }' && compctl -K "_$f" "${f##*__}"
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
    while (( $# )); do 
        # TODO add local/remote special case to handle ssh/mosh/rrc
        # TODO add xterm-256color special case
        case "$1" in
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


timer() { # echo the (average) elapsed system time in seconds (millisecond precision)
    # call as `timer cmd` or as `timer; cmd1; cmd2; timer`
    # `time` is problematic since bash:time zsh:time and /usr/bin/time all have different behavior
    local ts=($(date +%s%N))
    if (( $# )); then
        eval "`opt repeat,r=1`"
        while (( repeat-- > 0 )); do
            eval "$@"
            ts+=($(date +%s%N))
        done
        fmt "n=%s;x=(n-o)/10^9;t+=x;c+=1; o=n;%F%jscale=6;o=$ts;%s;t/c\n" "${ts[@]:1}" | bc >&2
    else
        if [ -z "$timer" ]; then timer=$ts; else bc <<< "scale=6;($ts-$timer)/10^9"; timer=; fi
    fi
}

# zsh: $path is an alias for $PATH, so don't use it as a variable
path() { (( $# )) || tr : '\n' <<< "$PATH"; while (( $# )); do export PATH="$PATH:$(cd "$1" && pwd)"; shift; done; }

# thanks to https://unix.stackexchange.com/a/453170
zsh__log() { printf '%s %s\n' "${funcfiletrace[0]%:*}:${funcstack[1]}:${funcfiletrace[0]##*:}" "$*" >&2; }
bash__log() { printf '%s %s\n' "${BASH_SOURCE[1]}:${FUNCNAME[1]}:${BASH_LINENO[0]}" "$*" >&2; }

DOTROOT=~/my
gg() {
    # if no arguments are given, go to the git root or home
    (($#)) || cd "$(git rev-parse --show-toplevel 2>/dev/null || echo ~)"
    # if arguments are given, resolve each into a directory or url
    while (($#)); do
        # $1 is either project location/project http://blah.com/location/project or git@blah.com:location/project.git
        local domain='' parent='' project=''
        # https://github.com/toombs-caeman/dotfiles
        M "$1" '^https?://([^/]*)/([^/]+)/([^/]*)$' ||
        # git@github.com:toombs-caeman/dotfiles.git
        M "$1" '^git@([^:]*):([^/]+)/([^/]*).git$' ||
        # github.com/toombs-caeman/dotfiles
        M "$1" '^([^:/]*)/([^/]+)/([^/]*)$' ||
        # toombs-caeman/dotfiles
        M "$1" '(^)([^:/]+)/([^/]*)$' ||
        # dotfiles
        M "$1" '(^)(^)([^/]*)$'

        if (($?)); then
            echo "couldn't parse argument $1" >&2; shift; continue
        fi
        domain="${M[1]}" parent="${M[2]}" project="${M[3]}"
        if [ ! -n "$parent" ]; then
            fmt -v parent "/$project$%w([^/]*)/[^/]*$%M%1ms" $(projects)
            if [ ! -n "$parent" ]; then
                echo "couldn't find project $project"
                shift; continue
            fi
        fi
        if [ ! -n "$domain" ]; then
            domain='github.com'
        fi
        #echo "domain=${domain} parent=${parent} project=${project}"
        if [[ ! -d "${DOTROOT:-~}/$parent/$project" ]]; then
            mkdir -p "${DOTROOT:-~}/$parent"
            git clone --depth 1 -- "git@${domain}:$parent/$project.git" "${DOTROOT:-~}/$parent/$project"
        fi
        cd "${DOTROOT:-~}/$parent/$project"
        shift
    done
}
__gg() { projects | grep -o '[^/]*$'; }
projects() { find "$DOTROOT"/* -maxdepth 5 -type d -name '.git' -prune 2>/dev/null | sed 's,^\(.*\)/.git,\1,' ; }
get() {
    # check to see if 
    local url="${1}"
    if M "${url}" "([^/]*)/([^/]*)$"; then
        local parent="${M[1]}"
        local repo="${M[1]}/${M[2]%.git}"
        echo "clone to $repo ?"
        echo "ctrl-c to cancel"
        if read; then
            mkdir -p ~/my/"$parent"
            git clone --depth 1 -- "${url}" ~/my/"$repo"
            cd ~/my/"$repo"
        fi
    else
        echo "couldn't parse url '$url'"
    fi
}

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
    setopt noshglob # hack to handle error 'compinit:141: parse error: ...' in some zsh versions
    autoload -Uz compinit
    compinit
    setopt promptsubst zle autocd nolocaloptions
    setopt appendhistory histexpiredupsfirst histignoredups noextendedhistory
}
bash__() {
    shopt -s expand_aliases checkwinsize autocd
    # activate preexec for bash only
    trap '[ -n "$precmd" ] || precmd=$SECONDS' DEBUG
    if ! shopt -oq posix; then
        if [ -f /usr/share/bash-completion/bash_completion ]; then
            . /usr/share/bash-completion/bash_completion
        elif [ -f /etc/bash_completion ]; then
            . /etc/bash_completion
        fi
    fi
}

prompt() {
    # for section ideas see: https://liquidprompt.readthedocs.io/en/stable/functions/data.html

    # show 'HH:MM:SS' of runtime if a command took 5 or more seconds
    ((tdelta >= 5)) && fmt '%Ty-%02d%T--%F:%j%s ' $((tdelta/3600)) $((tdelta%3600/60)) $((tdelta%60))
    # show any active virtual-env
    [ -n "$VIRTUAL_ENV" ] && fmt '%Tg-(%s)' "${VIRTUAL_ENV##*/}"
    # show kubernetes environment: context and namespace
    command -v kubectl >/dev/null && fmt '%Tu-(%s⎈%s)' $(kubectl config get-contexts | grep '^\*' | tr -s ' ' | cut -d' ' -f 2,5)
    # show git-relative directory
    location 2>/dev/null
    # show return code if nonzero
    (( EXIT )) && fmt '%Tr- %s%T--' "$EXIT"
}

PROMPT_COMMAND='precmd "\001" "\002" "\$"'
precmd() { 
    local EXIT="$?" tdelta=$((SECONDS-${precmd:-$SECONDS}));
    PS1="$(fmt[pp]="${1:-%%{}" fmt[qq]="${2:-%%\}}"; prompt)${3:-%#}"
    precmd=''
}
preexec() { precmd=$SECONDS; }

kubectl__() { . <(kubectl completion ${SHELL##*/}); }
eksctl__() { . <(eksctl completion ${SHELL##*/}); }
helm__() { . <(helm completion ${SHELL##*/}); }
inv__() { . <(inv --print-completion-script=${SHELL##*/}); }


colortest() {
    local f b c=(b r g y u m c w B R G Y U M C W)
    for f in "${c[@]}"; do for b in "${c[@]}"; do fmt "%T$f$b%s" "${1:-"##"}"; done; fmt "%T--\n"; done
}

location() { # if in a git repo print like `toplevel(*master↓2↑1):sub(9ab9999):/dir/path` else `~/working/dir`
    local C="$(git -C "$1" rev-parse --show-toplevel)" remote branch left right
    if [ -z "$C" ]; then [ -n "$1" ] || fmt '%T--%s' "${PWD/#"${HOME}"/"~"}"; return; fi
    location "$C/.."  # recurse up the file tree
    remote="$(git -C "$C" remote | head -n1)" # lets hope that they only have one remote, probably 'origin'
    branch="$(git -C "$C" rev-parse --abbrev-ref HEAD)"
    branch="${branch:-$(git -C "$C" rev-parse --short HEAD)}"
    left="$( git -C "$C" rev-list --left-only  --count remotes/$remote/$branch...$branch)"
    right="$(git -C "$C" rev-list --right-only --count remotes/$remote/$branch...$branch)"
    fmt "%T--%s(" "${C##*/}"
    test -n "$(git -C "$C" status --porcelain | grep -v '^??')"  && fmt '%Tr-%s' '*' || printf "${_:+*}"
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

nix__open() { xdg-open "$1" & disown; }
mac__open() { if [ -e "$1" ]; then command open "$@"; else command open -a "$@"; fi; }

mac__beep() { osascript -e 'beep 1'; }
#nix__beep() { paplay /usr/share/sounds/Yaru/stereo/bell.oga; }
nix__beep() { paplay /usr/share/sounds/freedesktop/stereo/complete.oga; }

mac__notify() { osascript -e "display notification \"${1:-"Done"}\""; }
nix__notify() { notify-send "$*"; }

mac__speak() { say "$*"; }
nix__speak() {
    # https://askubuntu.com/questions/53896/natural-sounding-text-to-speech
    # packages: festival festvox-us-slt-hts
    # install festival festival-us
    festival -b "(SayText \"$*\")"
    #spd-say "$*";
}

fonts() {
    for family in serif sans-serif monospace Arial Helvetica Verdana "Times New Roman" "Courier New"; do
        printf '%s: ' "$family"
        fc-match "$family"
    done
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
    export FZF_DEFAULT_OPTS='--color=16 --bind=alt-h:backward-char,alt-j:down,alt-k:up,alt-l:forward-char'
    export EDITOR="$(command -v vi vim nvim | tail -n1)" PAGER="less" LESS="FXr" VISUAL=$EDITOR
    alias vi="$EDITOR" wget='wget -c' mkdir='mkdir -p' cp="cp -i" du='du -hs' df='df -h'
    alias la='ls -A' ll='ls -lh' sl='ls' ls='ls -F --color=auto'
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
# add execution time to prompt if it's over some threshold
# detect when in nvim, and nvim and don't open nested editors, split instead
# detect nvim, disable vi-mode line editing, and goto terminal normal
# don't parse ls http://mywiki.wooledge.org/ParsingLs
# git: use diff3 https://blog.nilbus.com/take-the-pain-out-of-git-conflict-resolution-use-diff3/ https://blog.nilbus.com/take-the-pain-out-of-git-conflict-resolution-use-diff3/
# git: integrate forgit with existing fzf completion architecture
# term__(): [iTerm xterm] [window-dressing(title), copy-paste, scrollback, window-size]
# help() unify bash.help(), man, info, -h, -help, --help, type, link to docs?
# test suite? especially for bash vs zsh https://bach.sh/
# installer system - separate from rc() but install tools specified by rc
# degrade/fallback system - as part of rc(), fallback to available tools if preferred versions aren't available
# install/fallback grep=rg ls=exa find=fd https://github.com/sharkdp/fd cat=batcat vipe
# art
# https://マリウス.com/command-line/
# input syntax highlighting https://github.com/akinomyoga/ble.sh https://github.com/zsh-users/zsh-syntax-highlighting
# replace ~/my with $DOTROOT
# as part of human data-formats [todo.txt](https://github.com/todotxt/todo.txt) and [cal.txt](https://terokarvinen.com/2021/calendar-txt/)
#
icat() { kitty +kitten icat "$@"; }
