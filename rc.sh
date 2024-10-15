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


. "$(lib)" # import lib

# print absolute paths as if the argument is always relative to the directory of this file
# TODO breaks if run as '. ./rc.sh'
here() { : "${BASH_SOURCE[0]:-${(%):-%x}}"; (( $# )) && echo "${_%/*}/${1#/}" || echo "$_"; }


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
path() { (($#)) || fmt ':%J%s\n' "$PATH"; while (($#)); do export PATH="$PATH:$(cd "$1" 2>/dev/null && pwd)"; shift; done; }


DOTROOT=~/my
lib_test() { for shell in bash zsh; do echo $'\n'"$shell"; "$shell" -c '. ./rc.sh; _lib_test'; done; echo; }
gg() {
    # $1 is either a project name, a url, or missing
    if (($#)); then
        local r="${DOTROOT:-~}" d=("${DOTROOT:-~}"/*/"$1"/)
        # if the project exists, go there
        [ -d "$d" ] && cd "$d" && return
        [[ "$1" == 'http'*'github.com'* ]] && M "$1" 'github.com/(.*)$' && set -- "git@github.com:${M[1]}.git"
        M "$1" '([^/:]+/[^/:]+)/?$' && d="${M[1]%.git}"
        mkdir -p "$r/$d" && git clone --depth 1 -- "$1" "$r/$d" && cd "$r/$d"
    else
        cd "$(git rev-parse --show-toplevel 2>/dev/null || echo ~)"
    fi
}
__gg() { fmt '([^/]*)$%M%1ms\n' "$DOTROOT"/*/*; }

venv="$DOTROOT/venv"
venv() { # [<virtual env>]
    [ -n "$VIRTUAL_ENV" ] && deactivate;
    if (($#)); then
        if [ ! -d "$venv/$1" ]; then
            printf 'create virtualenv "%s"?' "$1"; read
            python -m venv "$venv/$1"
        fi
        . "$venv/$1/bin/activate"
    fi
}
__venv() { ls "$venv"; }
# TODO conda  https://whiteboxml.com/blog/the-definitive-guide-to-python-virtual-environments-with-conda
# disable conda autoprompt https://stackoverflow.com/questions/36499220/anaconda-disable-prompt-change




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

fe() {
    # interactively edit a stream with fzf
    # inspired by https://github.com/DanielFGray/fzf-scripts/blob/master/fzrepl
    local ret in hist=~/.fe_history

    # don't run without a base command, for safety
    # instead, show what the last command executed was
    if (( ! $# )); then tail -n 1 "$hist"; return $?; fi

    # make sure the query affects results
    if [[ "$*" != *'{q}'* ]]; then set -- "$@" '{q}'; fi
    # store input
    in="$(mktemp)"
    cat > "$in"
    fzf \
        --history="$hist" \
        --layout=reverse-list \
        --phony \
        --prompt "$1 " \
        --bind  "start:reload:$* < '$in'" \
        --bind "change:reload:$* < '$in'" \
        --multi \
        --bind "enter:select-all+accept+transform-query:printf %s \"$*\"" \
        < "$in"
    ret="$?"
    rm "$in"
    return "$ret"
}
ff() { fe grep "$@"; }
fs() { fe sed "$@"; }
fq() { fe jq "$@"; }

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
    # aws, terraform, node, conda

    # show the hostname iff we're tunneled to a remote
    [ -n "$SSH_CLIENT" ] && fmt '%TU-%s:' "$HOST"
    # show 'HH:MM:SS' of runtime if a command took 5 or more seconds
    ((tdelta >= 5)) && fmt '%Ty-%02d%T--%F:%j%s ' $((tdelta/3600)) $((tdelta%3600/60)) $((tdelta%60))
    [ -n "$CONDA_DEFAULT_ENV" ] && fmt '%TB-∝<%s>' "$CONDA_DEFAULT_ENV"
    # show virtual-env if active
    [ -n "$VIRTUAL_ENV" ] && fmt '%Tg-⍼(%s)' "${VIRTUAL_ENV##*/}"
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
    PS1="$(fmt[pp]="${1:-%%{}" fmt[qq]="${2:-%%\}}"; prompt)${3:-%#} "
    precmd=''
}
preexec() { precmd=$SECONDS; }
location() { # if in a git repo print like `toplevel(*master↓2↑1):sub(9ab9999):/dir/path` else `~/working/dir`
    local C="$(git -C "$1" rev-parse --show-toplevel)"
    if [ -z "$C" ]; then [ -n "$1" ] || fmt '%T--%s' "${PWD/#"${HOME}"/"~"}"; return; fi
    location "$C/.."
    local remote="$(git -C "$C" remote | head -n1)" mod="$(git -C "$C" status --porcelain)" branch L R s l
    : "$(git -C "$C" rev-parse --abbrev-ref HEAD)"; branch="${_:-$(git -C "$C" rev-parse --short HEAD)}"
    git rev-parse $remote/$branch >/dev/null || l='L'
    : "$(git -C "$C" rev-list --left-only  --count remotes/$remote/$branch...$branch)"; ((_)) && L="↓$_"
    : "$(git -C "$C" rev-list --right-only --count remotes/$remote/$branch...$branch)"; ((_)) && R="↑$_"
    [[ "$(git rev-parse --is-shallow-repository)" == true ]] && s='√'
    fmt -v _ $'\n''%J^[^?]%w' "$mod" && mod="${mod:+%Tr-*}" || mod="${mod:+*}"
    fmt "%T--%s($mod%Tg-%s%Tu-$L$R$s$l%T--):%s/" "${C##*/}" "$branch" "${PWD//"$C"}"
}

kubectl__() { . <(kubectl completion ${SHELL##*/}); }
eksctl__() { . <(eksctl completion ${SHELL##*/}); }
helm__() { . <(helm completion ${SHELL##*/}); }
inv__() { . <(inv --print-completion-script=${SHELL##*/}); }


colortest() {
    local f b c=(b r g y u m c w B R G Y U M C W)
    for f in "${c[@]}"; do for b in "${c[@]}"; do fmt "%T$f$b%s" "${1:-"##"}"; done; fmt "%T--\n"; done
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

roll() {
    local r=() i
    while (($#)); do
        case "$1" in
            *d*)
                M "$1" '([0-9]*)d([0-9]+)'
                printf -v i '%*s' "${M[1]:-1}"; i="${i// /i }"
                for _ in $i; do r+=($((1+$RANDOM%${M[2]}))); done
                ;;
            +) pop r i; r[-1]=$((r[-1] + i)) ;;
            *) r+=("$1") ;;
        esac
        shift
    done
    printf '%s\n' "${r[@]}"
}

fonts() {
    for family in serif sans-serif monospace Arial Helvetica Verdana "Times New Roman" "Courier New"; do
        printf '%s: ' "$family"
        fc-match "$family"
    done
}
icat() { kitty +kitten icat "$@"; }

gtd=~/Documents/inbox.md
gtd() { (($#)) && printf '%s\n' "$*" >> "$gtd" || "$EDITOR" "$gtd"; }
alias g=gtd

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
    export FZF_DEFAULT_OPTS='--color=16 --bind=alt-h:backward-char,alt-j:down,alt-k:up,alt-l:forward-char '
    export EDITOR="$(command -v vi vim nvim | tail -n1)" PAGER="less" LESS="FXr" VISUAL=$EDITOR
    alias vi="$EDITOR" wget='wget -c' mkdir='mkdir -p' cp="cp -i" du='du -hs' df='df -h'
    alias la='ls -A' ll='ls -lh' sl='ls' ls='ls -F --color=auto'
    alias mount='sudo mount -o gid=$(whoami),uid=$(whoami),fmask=113,dmask=002'
    alias umount='sudo umount'
    rc "$(here include/fzf_complete.bash)" fzf bash
    rc "$(here include/fzf_complete.zsh)" fzf zsh
    path "$(here bin)"
    path ~/.local/bin
    # enable history
    HISTSIZE=100000000
    SAVEHIST=100000000
    HISTFILE=~/.sh_history
}

rc
__ # TODO idk why but git doesn't recognize the editor unless its set twice, but only in zsh


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

# ascii art credit https://ascii.co.uk/art/cerberus https://ascii.co.uk/art/sphinx
