#!/bin/bash

example='
. --------------------------------------------------------.
| [Esc]                                            o o o  |
| [`][1][2][3][4][5][6][7][8][9][0][-][=][_<_] [i][h][P^] |
| [|-][Q][W][E][R][T][Y][U][I][O][P][{][}] | | [d][e][Pv] |
| [CAP][A][S][D][F][G][H][J][K][L][;]["][\]|_|            |
| [__^__][Z][X][C][V][B][N][M][,][.][/][__^__]    [^]     |
| [c][@][a][________________________][a]   [c] [<][v][>]  |
`---------------------------------------------------------'

# $qwerty
qwerty=()
#qwerty+=(Esc F{1..12} $'\n')
qwerty+=(Esc $'\n')
qwerty+=('`' {1..9} 0 - = BS $'\t' Insert Home PageUp $'\n')
qwerty+=(Tab Q W E R T Y U I O P '[' ']' $'\t' Del End PageDown $'\n')
qwerty+=(Caps A S D F G H J K L ';' "'" '\' Enter $'\n')
qwerty+=(Shift Z X C V B N M ',' '.' '/' Shift $'\t' ' ' Up $'\n')
qwerty+=(Ctrl Meta Alt Space Alt Ctrl $'\t' Left Down Right $'\n')
# $keys is an array of pairs (name, display string)
declare -A keys=()
for x in {0..12}; do keys[F$x]="$x"; done # function keys
for x in {A..Z} {0..9}; do keys[$x]="$x"; done # letter+number keys
for x in ';' '/' ',' '.' "'" \\ '`' - =; do keys[$x]=$x; done # symbol keys
x='['; keys[$x]='{'
x=']'; keys[$x]='}'
keys[Esc]='Esc'
keys[BS]='_<_'
keys[Space]='________________________'
keys[Tab]='>|'
keys[Caps]='CAP'
keys[Enter]='<-'
keys[Shift]='__^__'
keys[Alt]='a'
keys[Ctrl]='c'
keys[Meta]='@'
keys[Fn]='Fn'
# arrow keys
keys[Up]='^'
keys[Left]='<'
keys[Down]='v'
keys[Right]='>'
# what are these called??
keys[Insert]='i'
keys[PageUp]='P^'
keys[PageDown]='Pv'
keys[End]='e'
keys[Del]='d'
keys[Home]='h'


load_layout() { # returns layout max_lengths size segment_lengths
    eval "layout=(\"\${$1[@]}\")"
    tput_r="$(tput rev)"
    tput_n="$(tput sgr0)"
    max_lengths=() segment_lengths=()
    local k m=0 L=0
    for k in "${layout[@]}"; do
        case "$k" in
            $'\t'|$'\n')
                (( max_lengths[$m] < L && (max_lengths[$m]= L) ))
                segment_lengths+=($L) L=0
                [ "$k" = $'\n' ] && m=0 || ((m++))
                ;;
            ' ') ((L += 3)) ;;
            *) [ -n "${keys[$k]}" ] && ((L += ${#keys[$k]} + 2)) || return 1 ;;
        esac
    done
    size=1; for s in "${max_lengths[@]}"; do ((size+=(s+1))); done
}
printkeys() {
    printf '.'; printf '%.0s-' $(seq $size); printf -- ".\n"
    local k s=0 m=0 nl=1
    for k in "${layout[@]}"; do
        ((nl)) && printf '| ' && nl=0
        case "$k" in
            $'\t'|$'\n')
                printf "%-$((${max_lengths[$m]} - ${segment_lengths[$s]}))s "
                ((s++))
                if [ $'\n' = "$k" ]; then
                    while ((++m<${#max_lengths[@]})); do printf "%-$((${max_lengths[$m]}))s "; done
                    printf '|\n'
                    m=0 nl=1
                else
                    ((m++))
                fi
                ;;
            ' ') printf '   ' ;;
            *) [[ "$@" =~ ( |^)"$k"( |$) ]] && printf "[$tput_r${keys[$k]}$tput_n]" || printf "[${keys[$k]}]" ;;
        esac
    done
    printf '`'; printf '%.0s-' $(seq $size); printf -- "'\n"
}

input=()
reset() { clear; tput cnorm; exit; }
trap reset SIGTERM
trap reset SIGINT
clear
load_layout qwerty
printkeys
tput cup 0 0
tput civis
while true; do
    IFS= read -s -n 1 -t 0.25 val
    if [ -n "$val" ]; then
        input=("${input[@]}" "${val^^}")
        printkeys qwerty "${input[@]}"
        tput cup 0 0
    else
        ((${#input[@]})) && printkeys qwerty "${input[@]:1}" && tput cup 0 0
        input=("${input[@]:1}")
    fi
done
exit

readc() {
    # https://stackoverflow.com/a/61483332
    escape_char=$(printf "\u1b")
    read -rsn1 mode # get 1 character
    if [[ $mode == $escape_char ]]; then
        read -rsn4 -t 0.001 mode # read 2 more chars
    fi
    case $mode in
        '') echo escape ;;
        '[a') echo UP ;;
        '[b') echo DOWN ;;
        '[d') echo LEFT ;;
        '[c') echo RIGHT ;;
        '[A') echo up ;;
        '[B') echo down ;;
        '[D') echo left ;;
        '[C') echo right ;;
        '[2~') echo insert ;;
        '[7~') echo home ;;
        '[7$') echo HOME ;;
        '[8~') echo end ;;
        '[8$') echo END ;;
        '[3~') echo delete ;;
        '[3$') echo DELETE ;;
        '[11~') echo F1 ;;
        '[12~') echo F2 ;;
        '[13~') echo F3 ;;
        '[14~') echo F4 ;;
        '[15~') echo F5 ;;
        '[16~') echo Fx ;;
        '[17~') echo F6 ;;
        '[18~') echo F7 ;;
        '[19~') echo F8 ;;
        '[20~') echo F9 ;;
        '[21~') echo F10 ;;
        '[22~') echo Fy ;;
        '[23~') echo F11 ;;
        '[24~') echo F12 ;;
        '') echo backspace ;;
        *) echo $mode;;
    esac
}

#printkeys qwerty 'A'

