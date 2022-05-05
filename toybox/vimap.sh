#!/bin/bash
shopt -s extglob
#set +m
#
#
## disable all keybindings
#for binding in $(bind -l); do
#    bind -u "$binding" 2>/dev/null
#done

whitefox=('
.------------------------------------------------.
|[Ǝ][1][2][3][4][5][6][7][8][9][0][-][=][`][\][☆]|
|[⭾ ][Q][W][E][R][T][Y][U][I][O][P][{][}][ ⌫ ][⌦]|
|[ λ ][A][S][D][F][G][H][J][K][L][;]["][  ⮐  ][▲]|
|[  ⇧  ][Z][X][C][V][B][N][M][,][.][/][ ⇧ ][↑][▼]|
|[c][🦊][⎇ ][___________________][⎇ ][λ][←][↓][→]|
`------------------------------------------------'"'
")
# follow xdotool naming convention https://gitlab.com/cunidev/gestures/-/wikis/xdotool-list-of-key-codes
whitefox+=(Escape 1 2 3 4 5 6 7 8 9 0 minus equal grave backslash Star)
whitefox+=(Tab q w e r t y u i o p bracketleft bracketright BackSpace Delete)
whitefox+=(Function a s d f g h j k l semicolon apostrophe Return Page_Up)
whitefox+=(shift z x c v b n m comma period slash shift Up Page_Down)
whitefox+=(ctrl super alt space alt Function Left Down Right)

qwerty=('
.---------------------------------------------------------.
| [Esc]                                            o o o  |
| [`][1][2][3][4][5][6][7][8][9][0][-][=][_<_] [i][h][P^] |
| [|-][Q][W][E][R][T][Y][U][I][O][P][{][}][  ] [d][e][Pv] |
| [CAP][A][S][D][F][G][H][J][K][L][;]["][\]|_|            |
| [__^__][Z][X][C][V][B][N][M][,][.][/][__^__]    [^]     |
| [c][@][a][________________________][a]   [c] [<][v][>]  |
`---------------------------------------------------------'"'
")
qwerty+=(Escape grave 1 2 3 4 5 6 7 8 9 0 minus equal BackSpace Insert Home Page_Up)
qwerty+=(Tab q w e r t y u i o p bracketleft bracketright Return Delete End Page_Down)
qwerty+=(Capslock a s d f g h j k l semicolon apostrophe backslash)
qwerty+=(shift z x c v b n m comma period slash shift Up)
qwerty+=(ctrl super alt space alt ctrl Left Down Right)

load_layout() {
    local x; eval "layout=(\"\${$1[@]}\")"
    layout[0]="${layout[0]#$'\n'}"
    layout[0]="${layout[0]%$'\n'}"$'\n'
    pattern="${layout[0]//\[*([^]])\]/[%s]}"
    x="${layout[0]//|/\\|}"
    x="${x//\[*([^]])\]/\\[([^]]*)\\]}"
    [[ "${layout[0]}" =~ $x ]] || echo fail
    caps=("${BASH_REMATCH[@]:1}")
    names=("${layout[@]:1}")
    unset -v layout; layout="$1"
}
tput_r="$(tput rev)"
tput_n="$(tput sgr0)"
printkeys() {
    local k p=()
    # for each pressed key (by name) get its index in $names[]
    # then insert colors codes at each index in a copy of caps
    for k in "$@"; do : " ${names[*]} "; k="${_%% $k *}"; : "${k// }"; p+=($((${#k} - ${#_}))); done
    k=("${caps[@]}"); for p in "${p[@]}"; do ((p <${#k[@]})) && k[$p]="$tput_r${k[$p]}$tput_n"; done
    # print the re-colored caps
    printf "$pattern" "${k[@]}"
}
xdropkeys() {
        [[ "$k" =~ ctrl\+.*[sdcgjzvm]$ ]] ||
        [[ "$k" =~ ctrl\+shift\+[fubs] ]]
}
xgetkeys() {
    win="$(xdotool getwindowfocus)"
    echo reading exact config. This might take a while
    keys=() cmd=()
    for k in "${names[@]}"; do
        [ "$k" = Return  ] && continue
        [ "$k" = shift  ] && continue
        [ "$k" = Function  ] && continue
        [ "$k" = alt  ] && continue
        [ "$k" = super  ] && continue
        [ "$k" = ctrl  ] && continue
        keys+=({,ctrl+}{,alt+}{,shift+}"$k")
    done
    for k in "${keys[@]}"; do
        xdropkeys && continue
        cmd+=("$k" Return)
    done
    xdotool key --window "$win" --delay 12 --clearmodifiers "${cmd[@]}" 2>/dev/null &
    declare -Ag keymap=()
    echo 'readc() { key=; case "$1" in' > ./readc.sh

    for k in "${keys[@]}"; do
        xdropkeys && continue
        #echo "$k" >&2
        IFS= read -rsi x line; printf "%q) key='%s' ;;\n" "$line" "$k"
    done >> ./readc.sh
    echo 'esac; }' >> ./readc.sh
}
#time xgetkeys

. ./readc.sh
#echo "${#caps[@]}"
#exit
#printf '%s\n' "${caps[@]}"
#printf 'pattern: %s\n' "$pattern"
#printf 'x: %s\n' "$x"
#printf "$pattern"  "${caps[@]}"
reset() { clear; tput cnorm; trap - SIGTERM; trap - SIGINT; }
init() { trap reset SIGTERM; trap reset SIGINT; clear; tput civis; }
typewriter() {
    load_layout whitefox
    init
    printf '%.0s\n' "$@"
    printkeys
    local line c
    while (($#)); do
        [[ "$1" =~ ${1//?/(.)} ]]
        for c in "${BASH_REMATCH[@]:1}" $'\n'; do
            [ "$c" = $'\n' ] && shift
            line+="$c"
            sleep 0.1
            tput cup 0 0
            printf "$line"
            (($#)) && printf '%.0s\n' "$@"
            readc "$c"
            printkeys "$key"
        done
    done
    sleep 3
    reset
}
typewriter "look at me, typing stuff." "  --bruh"
exit
showkeys() {
    load_layout qwerty
    init
    printkeys
    while true; do
        IFS= read -rsn 1 -t 0.25 val
        IFS= read -rsn 10 -t 0.001 rem
        val="$val$rem"
        if [ -n "$val" ]; then
            readc "${val}"
            input+=("$key")
            clear
            printkeys ${input[@]//+/ }
            echo "${input[@]}"
            tput cup 0 0
        else input=(); fi
    done
}

showkeys
