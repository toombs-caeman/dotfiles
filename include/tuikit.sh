#!/usr/bin/env bash
# https://github.com/dylanaraps/writing-a-tui-in-bash
# https://github.com/dylanaraps/fff
tuikit () {
: 'a utility to help create tui programs in pure bash+coreutils. The majority of this is simply wrapping vt1000 escape codes or coreutils in a nice way
'
:
}
# WRAPPER {{{
tuikit_init () {
:
}
tuikit_end () {
:
}
# WRAPPER }}}
# TERM {{{
tuikit_term_clear () {
    printf '\e[2J'
}

tuikit_term_size() {
    # Usage: get_term_size

    # (:;:) is a micro sleep to ensure the variables are
    # exported immediately.
    shopt -s checkwinsize; (:;:)
    printf '%s\n' "$LINES $COLUMNS"
}
tuikit_term_scrollarea () {
: 'set the absolute position of the cursor
tuikit cursor set x y
'
    printf '\e[%s;%sr' "$1" "$2"
}
tuikit_term_restore () {
    # Save the user's terminal screen.
    printf '\e[?1049l'
}
tuikit_term_save () {
    # Save the user's terminal screen.
    printf '\e[?1049h'
}
# TERM }}}
# CURSOR {{{
tuikit_cursor_pos() {
: 'get the current cursor position'
    # Usage: get_cursor_pos
    IFS='[;' read -p $'\e[6n' -d R -rs _ y x _
    printf '%s\n' "$x $y"
}
tuikit_cursor_mv () {
: 'move the cursor relatively
tuikit cursor mv x y
'
    declare x y
    if [[ -z ${1:+x} ]]; then
        [[ $1 == "-"* ]] && x=${1/-}D || x=$1C
        printf '\e[%s' $x
    fi
    if [[ -z ${2:+x} ]]; then
        [[ $2 == "-"* ]] && y=${2/-}A || y=$2B
        printf '\e[%s' $y
    fi
}

tuikit_cursor_set () {
: 'set the absolute position of the cursor
tuikit cursor set x y
'
    printf '\e[%s;%sH' "$1" "$2"
}
# CURSOR }}}
subtool tuikit
